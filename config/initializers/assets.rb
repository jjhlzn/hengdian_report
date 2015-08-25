# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( network_order_area_compares.js )
Rails.application.config.assets.precompile += %w( network_order_today_reports.js )
Rails.application.config.assets.precompile += %w( network_order_today_ticket_reports.js )
Rails.application.config.assets.precompile += %w( network_order_yearly_agent_reports.js )
Rails.application.config.assets.precompile += %w( network_order_yearly_reports.js )
Rails.application.config.assets.precompile += %w( network_order_month_reports.js )
Rails.application.config.assets.precompile += %w( group_order_day_reports.js )
Rails.application.config.assets.precompile += %w( group_order_month_reports.js )
Rails.application.config.assets.precompile += %w( all_yearly_reports.js )