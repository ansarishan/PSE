ActiveAdmin.register Organization do
  permit_params :name, :ss_link

  config.batch_actions = false

  index download_links: false do
    id_column
    column :name
    column :ss_link
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :name
      row :ss_link
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    #f.semantic_errors(*f.object.errors.keys)
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :name
      f.input :ss_link
    end
    f.actions
  end
end
