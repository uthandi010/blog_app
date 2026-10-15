# Comma-separated list of allowed origins, e.g.
#   CORS_ORIGINS=https://blog.example.com,http://localhost:8080
allowed_origins = ENV.fetch('CORS_ORIGINS', 'http://localhost:8080,http://localhost:5173')
                     .split(',').map(&:strip).reject(&:empty?)

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*allowed_origins)
    resource '*',
             headers: :any,
             methods: %i[get post patch put delete options],
             credentials: false
  end
end