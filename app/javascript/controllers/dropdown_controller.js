import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['menuWrapper', 'visibleMenu']

  toggle() {
    this.menuWrapperTarget.classList.toggle('hidden')
  }

  hide(event) {
    if(event.target.attributes['data-action'] && event.target.attributes["data-action"].value.includes("dropdown#toggle")) {
      // don't trigger when opening it!
      return
    }
    
    if(this.visibleMenuTarget.contains(event.target) === false) {
      this.menuWrapperTarget.classList.add('hidden')
    }
  }
}
