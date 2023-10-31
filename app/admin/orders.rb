ActiveAdmin.register Order do
  permit_params :amount, :state, :drug_instrument_id, :organization_id

  config.batch_actions = false

  #config.sort_order = 'name_asc'

  #filter :name
  #filter :some_assoc, collection: proc { SomeAssoc.order(:name) }

  index download_links: false do
    id_column
    column :state
    column :side
    column :amount
    column :drug_instrument
    column :notes
    column :organization
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :state
      row :side
      row :amount
      row :drug_instrument
      row :notes
      row :organization
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    #f.semantic_errors(*f.object.errors.keys)
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :state
      f.input :side
      f.input :amount, hint: "in thousands, interval of 50"
      f.input :drug_instrument, member_label: :debug_name
      f.input :organization
      f.input :drug_instrument, member_label: :notes
    end
    f.actions
  end
end
