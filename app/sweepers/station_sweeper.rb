class StationSweeper < ActionController::Caching::Sweeper
  observe Station # This sweeper is going to keep an eye on the Station model

  # If our sweeper detects that a Station was created call this
  def after_create(station)
    Rails.logger.debug("Sweep Station #{station.to_param} after create.")
    expire_cache_for(station)
  end

  # If our sweeper detects that a Station was updated call this
  def after_update(station)
    Rails.logger.debug("Sweep Station #{station.to_param} after update.")
    expire_cache_for(station)
  end

  # If our sweeper detects that a Station was touched by a save
  # of a related object
  def after_touch(station)
    Rails.logger.debug("Sweep Station #{station.to_param} after touch.")
    expire_cache_for(station)
  end

  # If our sweeper detects that a Station was deleted call this
  def after_destroy(station)
    Rails.logger.debug("Sweep Station #{station.to_param} after destroy.")
    expire_cache_for(station)
  end

  def expire_cache_for(station)
    FileUtils.rm_rf(Rails.root.join('public', 'stations'),    :verbose => Rails.env.development?)
    FileUtils.rm_rf(Rails.root.join('public', 'api'),         :verbose => Rails.env.development?)
    FileUtils.rm(Rails.root.join('public', 'stations.html'),  :verbose => Rails.env.development?, :force => true)
    FileUtils.rm(Rails.root.join('public', 'index.html'),     :verbose => Rails.env.development?, :force => true)
  end
end