class SbahnParserJob < Struct.new(:timestamp)

  def network
    @network ||= Network.where("name = 'S-Bahn'").first
  end

  # Ist der Job unabhängig von der Reihenfolge der Abarbeitung?
  def perform
    time = Time.at(timestamp.to_i)
#    puts Rails.root.join('public', 'system', 'SBAHN', "#{timestamp}.html")
    file = File.open(Rails.root.join('public', 'system', 'SBAHN', "#{timestamp}.html"))
    broken_lifts = SbahnParser.parse(file, network)

    working_type = EventType.working
    broken_type = EventType.broken

    network.lifts.find_each do |lift|
      if broken_lifts.include?(lift)
        # Setze alle Lifts, die in der html datei enthalten sind auf broken
        Event.create(:event_type => broken_type, :lift => lift, :timestamp => time)
      else
        # Setze alle Lifts, die nicht in der html datei vorkommen auf working
        Event.create(:event_type => working_type, :lift => lift, :timestamp => time)
      end
    end
  end

  # Do something before the actual job is performed
  def before(delayed_job)
  end

  def after(delayed_job)
  end

  # Do something when the job was successfully done
  def success(delayed_job)
    # Delete the file which has been parsed?
    STDOUT.putc '.'
    STDOUT.flush
  end

  # Do something when the job failed
  def error(delayed_job, exception)
    STDERR.putc 'E'
    STDERR.flush
  end

  # Do something when the job failed 25 times
  def failure
  end

end