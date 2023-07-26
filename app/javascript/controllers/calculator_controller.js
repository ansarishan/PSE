import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = [
    'calcPane',
    'ticketUpProjection',
    'ticketDownProjection',
    'ticketUpAmount',
    'ticketDownAmount',
    'ticketAboveReturnCap',
    'ticketBelowReturnCap',
    'ticketAboveLeverage',
    'ticketBelowLeverage',

    'contractProjection',
    'examplePeriodRevenue',
    'tradingAmount',
    'aboveLeverage',
    'aboveReturnCap',
    'belowLeverage',
    'belowReturnCap',
    'sideToggle',
    'toggleAboveLabel',
    'toggleBelowLabel',
    'maxReturn',
    'maxLoss',
    'totalReturnOrLoss'
  ]

  initialize() {
    this.side = '?'
    this.contractProj = 0
    this.exampleProj = 0
    this.amount = 0
    this.upLev = 0
    this.upReturnCap = 0
    this.downLev = 0
    this.downReturnCap = 0

    this.maxReturn = 0
    this.maxLoss = 0
    this.totalRol = 0
  }

  recalculate() {
    var percent_change = (this.exampleProj - this.contractProj) / this.contractProj
    var isUp = percent_change > 0

    var lev = Math.abs(percent_change) * (isUp ? this.upLev : this.downLev)
    var cap = (isUp ? this.upReturnCap : this.downReturnCap) / 100.0

    var upsideGain = Math.min(lev, cap) * this.amount * 1000
    if(isUp==false && upsideGain != 0)
      upsideGain *= -1

    if(this.side=='up') {
      this.totalRol = upsideGain
      this.maxReturn = (this.upReturnCap / 100.0) * this.amount * 1000
      this.maxLoss = (this.downReturnCap / 100.0) * this.amount * 1000 * -1
    } else {
      this.totalRol = -1 * upsideGain
      this.maxReturn = (this.downReturnCap / 100.0) * this.amount * 1000
      this.maxLoss = (this.upReturnCap / 100.0) * this.amount * 1000 * -1
    }
  }

  redgreenify(element, value) {
    if(value > 0) {
      element.classList.remove('red')
      element.classList.add('green')
    } else if(value < 0) {
      element.classList.remove('green')
      element.classList.add('red')
    } else {
      element.classList.remove('red')
      element.classList.remove('green')
    }
  }

  formatCurrency(val) {
    if(!this.currency) {
      this.currency = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'})
    }
    return this.currency.format(val)
  }

  updateResultsDisplay() {
    if(this.side=='up') {
      this.toggleAboveLabelTarget.classList.add('active')
      this.toggleBelowLabelTarget.classList.remove('active')
    } else {
      this.toggleAboveLabelTarget.classList.remove('active')
      this.toggleBelowLabelTarget.classList.add('active')
    }

    this.maxReturnTarget.textContent = this.formatCurrency(this.maxReturn)
    this.redgreenify(this.maxReturnTarget, this.maxReturn)

    this.maxLossTarget.textContent = this.formatCurrency(this.maxLoss)
    this.redgreenify(this.maxLossTarget, this.maxLoss)

    this.totalReturnOrLossTarget.textContent = this.formatCurrency(this.totalRol)
    this.redgreenify(this.totalReturnOrLossTarget, this.totalRol)
  }

  updateLocalVarsFromForm() {
    this.side = this.sideToggleTarget.checked ? 'down' : 'up'
    this.exampleProj = this.examplePeriodRevenueTarget.value
    this.contractProj = this.contractProjectionTarget.value
    this.amount = this.tradingAmountTarget.value
    this.upLev = this.aboveLeverageTarget.value
    this.downLev = this.belowLeverageTarget.value
    this.upReturnCap = this.aboveReturnCapTarget.value
    this.downReturnCap = this.belowReturnCapTarget.value
  }

  show(event) {
    this.side = event.target.attributes['order-side'].value

    // init locals
    if(this.side == 'up') {
      this.contractProj = this.ticketUpProjectionTarget.value
      this.amount = this.ticketUpAmountTarget.value
    } else if(this.side=='down') {
      this.contractProj = this.ticketDownProjectionTarget.value
      this.amount = this.ticketDownAmountTarget.value
    } else {
      console.log('Illegal or unspecified side')
    }
    this.exampleProj = this.contractProj
    this.upReturnCap = this.ticketAboveReturnCapTarget.value
    this.downReturnCap = this.ticketBelowReturnCapTarget.value
    this.upLev = this.ticketAboveLeverageTarget.value
    this.downLev = this.ticketBelowLeverageTarget.value

    // init the side toggle
    this.sideToggleTarget.checked = (this.side=='down')

    // init the user input blanks
    this.contractProjectionTarget.value = this.contractProj
    this.examplePeriodRevenueTarget.value = this.exampleProj
    this.tradingAmountTarget.value = this.amount
    this.aboveLeverageTarget.value = this.upLev
    this.belowLeverageTarget.value = this.downLev
    this.aboveReturnCapTarget.value = this.upReturnCap
    this.belowReturnCapTarget.value = this.downReturnCap

    this.recalculate();
    this.updateResultsDisplay();

    // show it
    this.calcPaneTarget.classList.remove('hidden')
  }

  hide() {
    this.calcPaneTarget.classList.add('hidden')
  }

  onChange() {
    this.updateLocalVarsFromForm()
    this.recalculate()
    this.updateResultsDisplay()
  }
}

