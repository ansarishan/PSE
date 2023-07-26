# Preview all emails at http://localhost:3000/rails/mailers/new_order_legal_review_mailer
class NewOrderLegalReviewMailerPreview < ActionMailer::Preview
  def notify
    order1 = FactoryBot.create(:order)
    FactoryBot.create(:lawyer, organization: order1.organization, first_name: 'Matt', last_name: 'Murdock')
    NewOrderLegalReviewMailer.with(order: order1).notify
  end
end
