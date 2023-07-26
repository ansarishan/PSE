ActiveAdmin.register Region do
  permit_params :name

  config.batch_actions = false
  config.clear_action_items!

  controller do
    def action_methods
      super - ['new', 'create', 'destroy', 'edit']
    end
  end

  index download_links: false do
    id_column
    column :name
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    #f.semantic_errors(*f.object.errors.keys)
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
