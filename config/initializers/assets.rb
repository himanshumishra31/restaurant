Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w( jquery_nested_form.js )
Rails.application.config.assets.precompile += %w( store.js )
Rails.application.config.assets.precompile += %w( order.js )
