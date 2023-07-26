import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['companies']

  initialize() {
    easydropdown('#region-select')

    this.activeChoice = this.data.get('initialValue')
    this.updateVisibleCompanies()
  }

  onChange(event) {
    this.activeChoice = event.target.value // region id
    this.updateVisibleCompanies()
  }

  updateVisibleCompanies() {
    this.companiesTargets.forEach(el => {
      if(el.getAttribute('region-id')==this.activeChoice)
        el.classList.remove('hidden')
      else
        el.classList.add('hidden')
    })
  }
}

