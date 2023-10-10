ActiveAdmin.register DrugPeriod do
  permit_params :label, :drug_id, :region_id, :period_type,
                :prediction_period_date_range,
                :trailing_period_date_range,
                :status,
                :net_revenue_actual

  config.batch_actions = false

  index download_links: false do
    id_column
    column :drug
    column :region
    column :label
    column :period_type
    column :status
    column :net_revenue_actual
    actions
  end

  show do |x|
    attributes_table do
      row :id
      row :drug
      row :region
      row :label
      row :period_type
      row :prediction_period_date_range
      row :trailing_period_date_range
      row :net_revenue_actual
      row :status
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :drug
      f.input :region
      f.input :label
      f.input :period_type
      f.input :prediction_period_date_range
      f.input :trailing_period_date_range
      f.input :net_revenue_actual
      f.input :status, as: :select, collection: DrugPeriod.statuses.keys
    end
    f.actions
  end
  
end
