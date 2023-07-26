def expand_window_to_see_confirm_modal
  page.driver.browser.manage.window.resize_to(1200,800)
end

def verify_confirm_modal_appeared
  expect(page).to have_css('button.swal-button--confirm', visible: true)
end

When("I accept the confirmation dialog") do
  find('button.swal-button--confirm').click
end

When("I dismiss the confirmation dialog") do
  find('button.swal-button--cancel').click
end
