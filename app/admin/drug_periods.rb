ActiveAdmin.register DrugPeriod do
  permit_params :label, :drug_id, :region_id, :period_type,
                :prediction_period_date_range,
                :trailing_period_date_range,
                :status,
                :net_revenue_actual,
                :special_situation

  config.batch_actions = false

  index download_links: false do
    id_column
    column :drug
    column :region
    column :label
    column :period_type
    column :status
    column :net_revenue_actual
    column :special_situation
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
      row :special_situation
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
      f.input :special_situation_array,  as: :check_boxes  , collection: Organization.all.map { |c| [c.name, c.id] }
    end
    f.actions
  end
  before_save do |model|
    model.special_situation = params[:drug_period][:special_situation_array].join(',') if params[:drug_period][:special_situation_array].is_a?(Array)
  end
end
