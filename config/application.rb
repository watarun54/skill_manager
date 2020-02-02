require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SkillManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.i18n.default_locale = :ja

    # ActiveJobがSidekiqを使うことを宣言
    config.active_job.queue_adapter = :sidekiq

    config.update_papers_logger = Logger.new(Rails.root.join('log/update_papers_job.log'))

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.autoload_paths += %W(#{config.root}/lib)
  end
end
