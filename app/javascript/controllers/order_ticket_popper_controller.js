import { Controller } from 'stimulus'
function test(){
  alert('dsfdsf')
}
export default class extends Controller {
  static targets = ['ticket',
    'drugInstrumentId',
    'visibleWhenUp',
    'visibleWhenDown',
    'visibleWhenHasCounterOrderId',
    'enabledWhenUp',
    'enabledWhenDown',
    'upLeverageFactor',
    'upReturnCap',
    'netRevenueProjection',
    'downLeverageFactor',
    'downReturnCap',
    'amount',
    'hiddenCounterOrderId'
  ]

  initialize() {
    this.activeSide = 'up'
    this.amountIsFixed = false
  }

  showUpElements() {
    this.activeSide=='up'
    this.visibleWhenUpTargets.forEach(el => { el.classList.remove('hidden') })
    this.visibleWhenDownTargets.forEach(el => { el.classList.add('hidden') })
    this.enabledWhenUpTargets.forEach(el => { el.disabled = false })
    this.enabledWhenDownTargets.forEach(el => { el.disabled = true })
  }

  showDownElements() {
    this.activeSide=='down'
    this.visibleWhenUpTargets.forEach(el => { el.classList.add('hidden') })
    this.visibleWhenDownTargets.forEach(el => { el.classList.remove('hidden') })
    this.enabledWhenUpTargets.forEach(el => { el.disabled = true })
    this.enabledWhenDownTargets.forEach(el => { el.disabled = false })
  }

  showCounterOrderIdElements() {
    this.visibleWhenHasCounterOrderIdTargets.forEach(el => { el.classList.remove('hidden') })
  }
  
  hideCounterOrderIdElements() {
    this.visibleWhenHasCounterOrderIdTargets.forEach(el => { el.classList.add('hidden') })
  }

  show(event) {
    console.log('show')
    this.activeSide = event.target.attributes['order-side'].value

    var parentAtts = event.target.closest(".instrumentRow").attributes
    this.upsAllowed = parentAtts['ups-allowed'].value=='true'
    this.downsAllowed = parentAtts['downs-allowed'].value=='true'

    this.amountIsFixed = false
    if(event.target.attributes['amountIsFixed']) {
      this.amountIsFixed = true
    }

    this.hiddenCounterOrderIdTarget.value = -1
    if(event.target.attributes['match-order']) {
      this.hiddenCounterOrderIdTarget.value = event.target.attributes['match-order'].value
      this.showCounterOrderIdElements()
    } else {
      this.hideCounterOrderIdElements()
    }

    if(this.activeSide=='up') {
      this.showUpElements()
    } else {
      this.showDownElements()
    }

    if(this.upsAllowed==false || this.downsAllowed== false) { // i.e. if one of them is false
      document.querySelectorAll('button.toggler').forEach(el => { el.classList.add('hidden') })
    } else {
      document.querySelectorAll('button.toggler').forEach(el => { el.classList.remove('hidden') })
    }

    if(this.amountIsFixed) {
      this.amountTargets.forEach(el => { el.readOnly = true })
    } else {
      this.amountTargets.forEach(el => { el.readOnly = false })
    }

    this.drugInstrumentIdTarget.value = parentAtts['di-id'].value
    this.upLeverageFactorTarget.value = parentAtts['di-up-lev'].value
    this.upReturnCapTarget.value = parentAtts['di-up-return-cap'].value
    this.netRevenueProjectionTargets.forEach(el => {el.value = parentAtts['di-net-rev-proj'].value})
    this.downReturnCapTarget.value = parentAtts['di-down-return-cap'].value
    this.downLeverageFactorTarget.value = parentAtts['di-down-lev'].value

    var initialAmount = event.target.attributes['initial-amount'] ? event.target.attributes['initial-amount'].value : 1000
    this.amountTargets.forEach(el => {
      el.value = initialAmount
    })

    this.ticketTarget.classList.remove('hidden')
  }
  showNotes(event) {
    
   // console.log('show123',event.target.attributes['data-notes'].value)

  alert("Notes: "+event.target.attributes['data-notes'].value)
  }
  hide() {
    this.ticketTarget.classList.add('hidden')
  }
}

