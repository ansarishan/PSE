ActiveAdmin.register Trade do
  permit_params :state

  config.batch_actions = false

  #config.sort_order = 'name_asc'

  #filter :name
  #filter :some_assoc, collection: proc { SomeAssoc.order(:name) }

  index download_links: false do
    id_column
    column :state
    column('Above') {|trade| trade.above.display_name}
    column('Below') {|trade| trade.below.display_name}

    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :state
      row('Above') {|trade| trade.above.display_name }
      row('Below') {|trade| trade.below.display_name }

      row :created_at
      row :updated_at
    end
  end

  form do |f|
    #f.semantic_errors(*f.object.errors.keys)
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :state
    end
    f.actions
  end
end
