ActiveAdmin.register Address do
  permit_params :line1, :line2, :city, :state,
    :postcode, :country, :user_id

  config.batch_actions = false

  index download_links: false do
    id_column
    column :user
    column :city
    column :state
    column :postcode
    column :country
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :user
      row :line1
      row :line2
      row :city
      row :state
      row :postcode
      row :country
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :id
      f.input :user
      f.input :line1
      f.input :line2
      f.input :city
      f.input :state
      f.input :postcode
      f.input :country, as: :string  #todo change to country plugin
    end
    f.actions
  end
end
