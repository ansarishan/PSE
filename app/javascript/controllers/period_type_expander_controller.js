import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['icon', 'periods']

  initialize() {
    this.state = this.data.get('startState') || 'closed'
    this.update()
  }

  toggle() {
    if(this.state=='closed') {
      this.state='open'
    } else {
      this.state='closed'
    }
    this.update()
  }

  update() {
    if(this.state=='closed') {
      this.iconTarget.classList.remove('fa-minus')
      this.iconTarget.classList.add('fa-plus')
      this.periodsTarget.classList.add('hidden')
    } else {
      this.iconTarget.classList.remove('fa-plus')
      this.iconTarget.classList.add('fa-minus')
      this.periodsTarget.classList.remove('hidden')
    }
  }
}

