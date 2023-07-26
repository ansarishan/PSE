FactoryBot.define do
  factory :trade do
    state { 'unconfirmed' }
    orders {[
      FactoryBot.create(:order, side: 'up', drug_instrument: FactoryBot.create(:drug_instrument)),
      FactoryBot.create(:order, side: 'down', drug_instrument: DrugInstrument.last)
    ]}
    upside_gain { 99 if state=='settled' }
  end
end
