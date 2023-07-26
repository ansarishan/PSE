import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['link']

  show(e) {
    if(this.isConfirmed()) {
      return true;
    }
    e.preventDefault();

    const text   = this.linkTarget.getAttribute('data-confirm-text')   || 'Are you sure?'
    const title  = this.linkTarget.getAttribute('data-confirm-title')  || ''
    const cancel = this.linkTarget.getAttribute('data-confirm-cancel') || 'Cancel'
    const commit = this.linkTarget.getAttribute('data-confirm-commit') || 'OK'

    swal({
      title: title,
      text: text,
      buttons: [cancel, commit],
      dangerMode: true,
    }).then((result) => {
      if(result) {
        this.doConfirm();
      }
    });
  }

  hide() {
    console.log('hide')
  }

  isConfirmed() {
    if(this.linkTarget.getAttribute('data-confirm-text') === null) {
      return true;
    }
    return false;
  }

  doConfirm() {
    this.linkTarget.removeAttribute('data-confirm-text');
    this.linkTarget.click();
  }
}
