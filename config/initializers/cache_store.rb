Rails.application.config.tap do |config|
  config.cache_store = :redis_cache_store, { driver: :hiredis, url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379/' } }
end
