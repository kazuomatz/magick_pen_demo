<template v-slot:default="slotProps">
  <div>
    <div v-show="editing" style="width: 100%">
      <div class="editor-wrapper" >
        <textarea v-model="innerHTML" ref="textarea"></textarea>
      </div>
      <div class="btn-wrapper">
        <div class="form-inline" v-if="versions().length > 0">
          <label>{{ versionLabel }}</label>
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
    <div class="html-view" v-show="! editing && !preview">
      <div v-on:mouseenter="onMouseEnter($event)" v-on:mouseleave="onMouseLeave($event)" :class="textOverlayClass">
        <div class="icon" v-if="editable"><i :class="buttonIcon('edit')"></i></div>
        <div ref="content">
          <slot></slot>
        </div>
        <div class="text-overlay"></div>
        <button type="button" :class="buttonClass('edit') + ' edit-btn'" v-on:click="showEditor"><i :class="buttonIcon('edit')"></i>
          {{ buttonLabel('edit') }}
        </button>
      </div>
    </div>
    <div class="html-view" v-show="preview">
      <div class="icon"><i :class="buttonIcon('preview')"></i></div>
      <div class="preview">
        <div v-html="this.innerHTML"></div>
        <div class="text-overlay preview-overlay"></div>
      </div>
      <div class="btn-wrapper preview">
        <button :class="buttonClass('cancel')" v-on:click="onCancel" ><i :class="buttonIcon('cancel')"></i> {{ buttonLabel('cancel') }}</button>
        <button :class="buttonClass('edit')" v-on:click="mode = 'edit'" ><i :class="buttonIcon('edit')"></i> {{ buttonLabel('edit') }}</button>
        <button :class="buttonClass('update')" v-on:click="onSubmit" v-if="preview" ><i :class="buttonIcon('update')"></i> {{ buttonLabel('update') }}</button>
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
      if (this.$magickPenConfig.updateSnippet) {
        this.$magickPenConfig.updateSnippet(this.penKey, this.innerHTML, this.originalContent,(s)=> {
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
      const text = this.$refs.textarea
      setTimeout(()=> {
        text.style.height = 'auto';
        text.style.height = (text.scrollHeight - 15) + 'px';
      })
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
      if ( 'buttons' in this.$magickPenConfig ) {
        if ( buttonName in this.$magickPenConfig.buttons ) {
          return this.$magickPenConfig.buttons[buttonName];
        }
      }
      return null;
    },
    dateFormat(date) {
      let format;
      if(this.$magickPenConfig.date_format) {
        format = this.$magickPenConfig.date_format
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
      const snippet = this.$magickPenConfig.snippets.filter((snippet) => {return snippet.pen_key === this.penKey})
      return snippet[0];
    },
  },
  computed: {
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
      if ( typeof(this.$magickPenConfig.editable) === 'undefined'){
        return true
      }
      else {
        return this.$magickPenConfig.editable
      }
    },
    versionLabel() {
      if ( 'select' in this.$magickPenConfig ) {
        if ( 'label' in this.$magickPenConfig.select ) {
          return this.$magickPenConfig.select.label.version ? this.$magickPenConfig.select.label.version : 'version'
        }
        return  'version'
      }
    },
    currentLabel() {
      if ( 'select' in this.$magickPenConfig ) {
        if ( 'label' in this.$magickPenConfig.select ) {
          return this.$magickPenConfig.select.label.current ? this.$magickPenConfig.select.label.current : 'current'
        }
        return  'current'
      }
    },
    originalLabel() {
      if ( 'select' in this.$magickPenConfig ) {
        if ( 'label' in this.$magickPenConfig.select ) {
          return this.$magickPenConfig.select.label.original ? this.$magickPenConfig.select.label.original : 'original'
        }
      }
      return  'original'
    },
    selectClass() {
      if ( 'select' in this.$magickPenConfig ) {
        if ( 'class' in this.$magickPenConfig.select ) {
          return this.$magickPenConfig.select.class ? this.$magickPenConfig.select.class : ''
        }
      }
      return ''
    },
    edited() {
      return this.innerHTML !== this.beforeContent
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
      if(this.$magickPenConfig.getVersion) {
        this.$magickPenConfig.getVersion(this.penKey, this.version, (snippet)=> {
          this.innerHTML = beautify.html(snippet.content)
        });
      }
    }
  }
}
</script>

<style scoped lang="scss">
.editor-wrapper {
  margin: 20px 0 5px 0;
  textarea {
    border: 1px solid #e4e7ea;
    display: block;
    width: calc(100% - 22px);
    font-size: 0.875rem;
    line-height: 1.6;
    padding: 10px;
    color: #000;
    background-color: #fff;
    outline:0 none transparent;
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
  top: -20px;
  left: -20px;
  color: orangered;
  font-size: 1.3rem;
  background-color: #fff;
}

.text-over, .preview {
  position: relative;
  cursor: context-menu;
  .edit-btn {
    display: block;
    animation-name: fadeIn;
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
    }
  }
}

.edit-btn {
  display: none;
  position: absolute;
  width: 100px;
  height: 46px;
  top: calc(50% - 23px);
  left: calc(50% - 50px);
  z-index: 9999;
}

.btn-wrapper {
  text-align: right;
  padding: 10px 0;
  &.preview {
    margin-top: 20px;
    margin-right: -22.5px;
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
    left:-15px;
    border-top-left-radius: 25px;
    border-color: #666;
  }
}

div.form-inline {
  display: inline-block;
  margin-right: 5px;
  label {
    font-weight: bold;
    margin-right: 10px;
  }
}

</style>
