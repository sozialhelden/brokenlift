class SbahnParserJob < Struct.new(:timestamp)

  def network
    @network ||= Network.find_or_create_by_name('S-Bahn')
  end

  # Ist der Job unabhängig von der Reihenfolge der Abarbeitung?
  def perform
    time = Time.at(timestamp.to_i)
    file = File.open(Rails.root.join('public', 'system', 'SBAHN', "#{timestamp}.html"))
    broken_lifts = SbahnParser.parse(file, network)

    working_type = EventType.working
    broken_type = EventType.broken

    network.lifts.find_each do |lift|
      if broken_lifts.include?(lift)
        # Setze alle Lifts, die in der html datei enthalten sind auf broken
        Event.create(:event_type => broken_type, :lift => lift, :timestamp => time) unless Event.exists?(:event_type_id => broken_type.id, :lift_id => lift.id, :timestamp => time)
      else
        # Setze alle Lifts, die nicht in der html datei vorkommen auf working
        Event.create(:event_type => working_type, :lift => lift, :timestamp => time)  unless Event.exists?(:event_type_id => working_type.id, :lift_id => lift.id, :timestamp => time)
      end
      lift.prune_events
    end
  end

  # Do something before the actual job is performed
  def before(delayed_job)
  end

  def after(delayed_job)
  end

  # Do something when the job was successfully done
  def success(delayed_job)
    # Delete all cached files
    StationSweeper.instance.expire_cache_for(Station.first)
  end

  def error(delayed_job, exception)
    # Do something when the job failed

    # Delete all cached files
    StationSweeper.instance.expire_cache_for(Station.first)
  end

  def failure
    # Do something when the job failed 25 times
  end

end