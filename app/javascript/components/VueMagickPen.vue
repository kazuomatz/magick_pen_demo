<template v-slot:default="slotProps">
  <div class="magick-pen">
    <div v-if="penKey">
      <div v-if="editing" style="width: 100%">
        <div class="editor-wrapper" >
          <textarea v-model="innerHTML" ref="textarea" v-on:input="textInput"></textarea>
        </div>
        <div class="btn-wrapper">
          <div class="inline" v-if="versions().length > 0">
            <label class="version-label">{{ versionLabel }}</label>
            <select v-model="version" :class="selectClass">
              <option value="0">{{ currentLabel }}</option>
              <option v-for="(version,index) in versions()" :key="version.id" :value="version.id">
                {{index === versions().length -1 ? originalLabel : dateFormat(version.date)}}
              </option>
            </select>
          </div>
          <button :class="buttonClass('cancel')" v-on:click="onCancel" ><i :class="buttonIcon('cancel')"></i> {{ buttonLabel('cancel') }}</button>
          <button :disabled="!edited" :class="buttonClass('preview')" v-on:click="mode = 'preview'" ><i :class="buttonIcon('preview')"></i> {{ buttonLabel('preview') }}</button>
        </div>
      </div>
      <div class="html-view" v-show="!editing && !preview">
        <div v-on:mouseenter="onMouseEnter($event)" v-on:mouseleave="onMouseLeave($event)" :class="textOverlayClass" v-if="editable">
          <div :class="iconClass"><i :class="buttonIcon('edit')"></i></div>
          <div ref="content">
            <slot></slot>
          </div>
          <div class="text-overlay"></div>
          <button type="button" :class="buttonClass('edit') + ' edit-btn'" v-on:click="showEditor"><i :class="buttonIcon('edit')"></i>
            {{ buttonLabel('edit') }}
          </button>
        </div>
        <div v-else>
          <div ref="content">
            <slot></slot>
          </div>
        </div>
      </div>
      <div class="html-view" v-if="preview">
        <div :class="iconClass"><i :class="buttonIcon('preview')"></i></div>
        <div class="preview">
          <div v-html="this.innerHTML"></div>
          <div :class="previewOverlayClass"></div>
        </div>
        <div class="btn-wrapper preview">
          <button :class="buttonClass('cancel')" v-on:click="onCancel" ><i :class="buttonIcon('cancel')"></i> {{ buttonLabel('cancel') }}</button>
          <button :class="buttonClass('edit')" v-on:click="mode = 'edit'" ><i :class="buttonIcon('edit')"></i> {{ buttonLabel('edit') }}</button>
          <button :class="buttonClass('update')" v-on:click="onSubmit" v-if="preview" ><i :class="buttonIcon('update')"></i> {{ buttonLabel('update') }}</button>
        </div>
      </div>
    </div>
    <div v-else>
      <div class="alert">
        <span class="bold">vue-magick-pen:</span>   property "pen-key" is not set.
      </div>
      <div ref="content">
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script>
import  beautify  from 'js-beautify'
import dayjs from 'dayjs'

export default {
  name: 'vue-magick-pen',
  props: ['penKey'],
  data () {
    return {
      mode: 'view',
      innerHTML: '',
      beforeContent: '',
      originalContent: '',
      mouseOver: false,
      version: 0
    }
  },
  methods: {
    onMouseEnter ( event ) {
      event.preventDefault()
      if(this.editable) {
        this.mouseOver = true
      }
      return false
    },
    onMouseLeave ( event ) {
      event.preventDefault()
      this.mouseOver = false
      return false
    },
    onSubmit () {
      this.$refs.content.innerHTML = this.innerHTML
      this.mode = 'view';
      this.$emit('changed', this.innerHTML)
      if (this.config.updateSnippet) {
        this.config.updateSnippet(this.penKey, this.innerHTML, this.originalContent,()=> {
          this.version = 0
        })
      }
    },
    onCancel() {
      this.mode = 'view'
      this.innerHTML = this.beforeContent
      this.version = 0
    },
    showEditor() {
      this.mode = 'edit'
      setTimeout(()=> {
        this.adjustTextAreaHeight()
      });
    },
    adjustTextAreaHeight() {
      const text = this.$refs.textarea
      text.style.height = 'auto'
      text.style.height = (text.scrollHeight) + 'px'
    },
    textInput() {
      this.adjustTextAreaHeight()
    },
    buttonClass(buttonName) {
      const prop = this.buttonProperty(buttonName);
      if (prop) {
        return prop.class?  prop.class : ''
      }
      else {
        return ''
      }
    },
    buttonIcon(buttonName) {
      const prop = this.buttonProperty(buttonName);
      if (prop) {
        return prop.icon?  prop.icon : ''
      }
      else {
        return ''
      }
    },
    buttonLabel(buttonName) {
      const prop = this.buttonProperty(buttonName);
      function capitalizeString(str) {
        return str[0].toUpperCase() + str.slice(1);
      }
      if (prop) {
        return prop.label?  prop.label : capitalizeString(buttonName)
      }
      else {
        return capitalizeString(buttonName)
      }
    },
    buttonProperty(buttonName) {
      if ( 'buttons' in this.config ) {
        if ( buttonName in this.config.buttons ) {
          return this.config.buttons[buttonName];
        }
      }
      return null;
    },
    dateFormat(date) {
      let format;
      if(this.config.date_format) {
        format = this.config.date_format
      }
      else {
        format = 'YYYY/MM/DD HH:mm'
      }
      return dayjs(date).format(format)
    },
    versions () {
      if (this.currentSnippet() && this.currentSnippet().versions) {
        return this.currentSnippet().versions.sort((a,b) => {
          if( a.id > b.id ) return -1
          if( a.id < b.id ) return 1
          return 0
        })
      }
      else {
        return []
      }
    },
    currentSnippet() {
      if (this.config.snippets) {
        const snippet = this.config.snippets.filter((snippet) => {
          return snippet.pen_key === this.penKey
        })
        return snippet[0]
      } else {
        return null
      }
    }
  },
  computed: {
    config () {
      return this.$magickPenConfig || {}
    },
    textOverlayClass () {
      return this.mouseOver ?  'text-over' : ''
    },
    editing() {
      return this.mode === 'edit'
    },
    preview() {
      return this.mode === 'preview'
    },
    editable() {
      if ( typeof(this.config.editable) === 'undefined'){
        return true
      }
      else {
        return this.config.editable
      }
    },
    versionLabel() {
      if ( 'select' in this.config ) {
        if ( 'label' in this.config.select ) {
          return this.config.select.label.version ? this.config.select.label.version : 'version'
        }
      }
      return  'version'
    },
    currentLabel() {
      if ( 'select' in this.config ) {
        if ( 'label' in this.config.select ) {
          return this.config.select.label.current ? this.config.select.label.current : 'current'
        }
      }
      return  'current'
    },
    originalLabel() {
      if ( 'select' in this.config ) {
        if ( 'label' in this.config.select ) {
          return this.config.select.label.original ? this.config.select.label.original : 'original'
        }
      }
      return  'original'
    },
    selectClass() {
      if ( 'select' in this.config ) {
        if ( 'class' in this.config.select ) {
          return this.config.select.class ? this.config.select.class : ''
        }
      }
      return ''
    },
    edited() {
      return this.innerHTML !== this.beforeContent
    },
    isGlobal() {
      return this.penKey.slice(0,2) === 'g-'
    },
    iconClass() {
      return this.isGlobal ? 'icon global' : 'icon'
    },
    previewOverlayClass() {
      return this.isGlobal ? 'text-overlay preview-overlay global' :  'text-overlay preview-overlay'
    }
  },
  mounted () {
    if (this.currentSnippet()) {
      this.$refs.content.innerHTML = this.currentSnippet().content
    }
    else {
      this.originalContent = this.$refs.content.innerHTML.replace(/data-v-[a-z0-9]*=""/g, '')
      this.originalContent = beautify.html(this.originalContent)
    }
    let html = this.$refs.content.innerHTML
    html = beautify.html(html)
    this.innerHTML = html.replace(/data-v-[a-z0-9]*=""/g, '')
    this.beforeContent = this.innerHTML
  },
  watch: {
    version() {
      if(!this.version || !this.editing) return
      if(this.config.getVersion) {
        this.config.getVersion(this.penKey, this.version, (snippet)=> {
          this.innerHTML = beautify.html(snippet.content)
        });
      }
    }
  }
}
</script>

<style scoped lang="scss">
.magick-pen {
  *, *:before, *:after {
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
  }

  .alert {
    background-color: #faf0f0;
    padding: 10px 20px;
    border: solid 2px red;
    margin: 0 0 10px 0;

    span.bold {
      font-weight: bold;
    }
  }

  .editor-wrapper {
    margin: 20px 0 5px 0;

    textarea {
      border: 1px solid #e4e7ea;
      display: block;
      width: 100%;
      font-size: inherit;
      font-weight: inherit;
      line-height: inherit;
      padding: 10px;
      color: #000;
      background-color: #fff;
      outline: 0 none transparent;
      border-radius: 0.25rem;
      transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
      resize: none;

      &:focus {
        outline: 0;
      }
    }
  }

  .html-view {
    position: relative;

    .text-overlay {
      position: absolute;
      display: none;
      top: -15px;
      left: -15px;
      opacity: 0.2;
    }
  }

  .icon {
    position: absolute;
    background: transparent;
    top: -20px;
    left: -20px;
    width: 24px;
    height: 24px;
    color: orangered;
    font-size: 1.2rem;

    &.global {
      color: #4f7fdd;
    }

    i {
      &.fa, &.fas, &.fad, &.fab, &.far {
        font-size: 1.2rem !important;
      }
    }
  }

  .text-over, .preview {
    position: relative;
    cursor: context-menu;

    .edit-btn {
      display: block;
      animation-name: fadeIn;
      vertical-align: middle;
      animation-duration: .5s;
      animation-timing-function: ease-out;
    }

    .text-overlay {
      background-color: #f1f1f1;
      display: block;
      border: dotted 3px #000000;
      border-top-left-radius: 25px;
      animation-name: border-draw;
      animation-duration: .5s;
      animation-timing-function: ease-out;
      width: calc(100% + 30px);
      height: calc(100% + 30px);
      top: -15px;
      left: -15px;

      &.preview-overlay {
        border: dotted 3px orangered;
        animation: none;

        &.global {
          border: dotted 3px #4f7fdd;
        }
      }
    }
  }

  .edit-btn {
    display: none;
    position: absolute;
    width: 100px;
    height: 32px;
    top: calc(50% - 16px);
    left: calc(50% - 50px);
    vertical-align: middle;
    z-index: 9999;
    font-size: 0.75rem;
    i {
      &.fa, &.fas, &.fad, &.fab, &.far {
        font-size: 1rem !important;
        padding: 0;
        vertical-align: middle;
        display: inline-block;
      }
    }
    [data-icon] {
      font-size: 1rem !important;
      vertical-align: middle;
      padding: 0;
      display: inline-block;
    }
  }

  .btn-wrapper {
    width: 100%;
    text-align: right;
    padding: 10px 0;

    &.preview {
      position: relative;
      margin-top: 20px;
      right: -18px;
    }

    button {
      outline: none;
      vertical-align: middle;
      margin: 0 0 7.5px 0;
      display: inline-block;
      &:last-child {
        margin-right: 0;
      }

      &:disabled, &[disabled] {
        cursor: not-allowed;
      }

      i {
        &.fa, &.fas, &.fad, &.fab, &.far {
          font-size: 1.2rem !important;
          vertical-align: middle;
          padding: 0;
        }
      }

      [data-icon] {
        font-size: 1.2rem !important;
        vertical-align: middle;
        padding: 0;
      }
    }
  }

  @keyframes fadeIn {
    0% {
      opacity: 0;
    }
    100% {
      opacity: 100%;
    }
  }
  @keyframes border-draw {
    0% {
      border-top-left-radius: 0;
      width: calc(100%);
      height: calc(100%);
      top: 0;
      left: 0;
      border-color: #aaa;
    }
    100% {
      width: calc(100% + 30px);
      height: calc(100% + 30px);
      top: -15px;
      left: -15px;
      border-top-left-radius: 25px;
      border-color: #666;
    }
  }

  div.inline {
    display: inline-block;
    margin-bottom: 7.5px;
    label.version-label {
      font-weight: bold;
      margin-right: 10px;
      font-size: .8rem;
    }
  }
}
</style>
<style lang="scss">
select.magick-pen-select {
  background-color: #fff;
  background-repeat: no-repeat;
  background-position: right 6px top 14px;
  background-size: 8px 6px;
  color: #000;
  padding: 1.5px 7.5px;
  appearance: none;
  -webkit-appearance: none;
  -ms-appearance: none;
  -moz-appearance: none;
  border: solid 1px #e4e7ea;
  outline: 0;
  -webkit-transition: 0.3s ease all;
  -moz-transition: 0.3s ease all;
  -ms-transition: 0.3s ease all;
  -o-transition: 0.3s ease all;
  transition: 0.3s ease all;
  font-weight: normal;
  height: 30px;
  margin-right: 5px;
  margin-bottom: 7.5px;
  vertical-align: middle;
}
</style>
