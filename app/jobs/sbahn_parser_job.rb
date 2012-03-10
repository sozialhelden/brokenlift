class SbahnParserJob < Struct.new(:timestamp)


  # Ist der Job unabhängig von der Reihenfolge der Abarbeitung?
  def perform
    time = Time.at(timestamp.to_i)
    puts Rails.root.join('public', 'system', 'SBAHN', "#{timestamp}.html")
    file = File.open(Rails.root.join('public', 'system', 'SBAHN', "#{timestamp}.html"))
    broken_lifts = SbahnParser.parse(file, network)

    network.lifts.inverse(broken_lifts.map(&:id)).each do |working_lift|
      event_type = EventType.find_by_name('working')
      Event.create(:event_type => event_type, :lift => working_lift, :timestamp => time) if working_lift.broken?
    end

    broken_lifts.each do |broken_lift|
      event_type = EventType.find_by_name('broken')
      Event.create(:event_type => event_type, :lift => broken_lift, :timestamp => time) unless broken_lift.broken?
    end

  end

  def network
    @network ||= Network.where("name = 'S-Bahn'").first
  end

  def on_permanent_failure
    #TODO
  end

  def on_success
    # Strip file to relevant content
  end

end