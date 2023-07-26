class CreateOnboardingInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :onboarding_invites do |t|
      t.string :url_code, null: false
      t.string :email, null: false
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
