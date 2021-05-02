
import Vue from 'vue'
import vueMagickPen from 'vue-magick-pen'
import "vue-magick-pen/dist/vue-magick-pen.css";
import page from '../pages/topPage'


/*
import { BootstrapVue } from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
Vue.use(BootstrapVue)



*/


import Buefy from 'buefy'
import 'buefy/dist/buefy.css'

Vue.use(Buefy)


Vue.component('vue-magick-pen', vueMagickPen )
document.addEventListener('DOMContentLoaded', () => {
  Vue.prototype.$magickPenConfig = magickPenConfig
  const app = new Vue({
    render: h => h(page),
  }).$mount()

  const el = document.getElementById('app')
  el.appendChild(app.$el)
})
