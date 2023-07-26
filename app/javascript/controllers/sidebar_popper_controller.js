//  %div{'data-controller': 'sidebar-popper'}
//    %button{'data-action': 'click->sidebar-popper#popout'} OPEN MENU BUTTON
//    %div.sidebarMenuContainer.hidden{'data-target': 'sidebar-popper.sidebar'}
//      %p blah
//      %button{'data-action': 'click->sidebar-popper#hide'} HIDE MENU BUTTON

import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['sidebar']

  popout() {
    this.sidebarTarget.classList.remove('hidden')
  }

  hide() {
    this.sidebarTarget.classList.add('hidden')
  }
}

