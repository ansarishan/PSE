# Wrap previews in a transaction so they don't create objects.
Rails.application.config.to_prepare do

  class Rails::MailersController
    alias_method :preview_orig, :preview

    def preview
      ActiveRecord::Base.transaction do
        preview_orig
        raise ActiveRecord::Rollback
      end
    end
  end

end
