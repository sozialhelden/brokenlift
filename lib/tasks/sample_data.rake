# encoding: utf-8
namespace :db do
  desc "Fill in the database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_stations
    make_event_types
    make_operators
    make_networks
    make_lines
    make_lifts
    make_events
  end
end

  def make_stations
    Station.create(:name => 'S+U Rathaus Steglitz')
    Station.create(:name => 'S+U Hauptbahnhof')
    Station.create(:name => 'U Mehringdamm')
    Station.create(:name => 'U Kottbusser Tor')
    Station.create(:name => 'S+U Rathaus Spandau')
  end

  def make_event_types
    EventType.create(:name => 'broken', :is_working => 0)
    EventType.create(:name => 'working', :is_working => 1)
  end

  def make_operators
    Operator.create(:name => 'BVG')
    Operator.create(:name => 'S-Bahn')
  end

  def make_networks
    Network.create(:name => 'BVG', :operator_id => 1)
    Network.create(:name => 'S-Bahn', :operator_id => 2)
  end

  def make_lines
    Line.create(:name => 'U1', :network_id => 1)
    Line.create(:name => 'U2', :network_id => 1)
    Line.create(:name => 'U3', :network_id => 1)
    Line.create(:name => 'U4', :network_id => 1)
    Line.create(:name => 'U5', :network_id => 1)
    Line.create(:name => 'U6', :network_id => 1)
    Line.create(:name => 'U7', :network_id => 1)
    Line.create(:name => 'U8', :network_id => 1)
    Line.create(:name => 'U9', :network_id => 1)
  end

  def make_lifts
    Lift.create(:description => 'S+U Rathaus Steglitz - Straße <> Zwischenebene', :station_id => 1, :operator_id => 1)
    Lift.create(:description => 'S+U Hauptbahnhof Straße <> Bahn', :station_id => 2, :operator_id => 1)
    Lift.create(:description => 'U Mehringdamm Straße <> Schule', :station_id => 3, :operator_id => 1)
    Lift.create(:description => 'U Kottbusser Tor <> Kirche', :station_id => 4, :operator_id => 1)
    Lift.create(:description => 'S+U Rathaus Spandau Burgers <> MacDonalds', :station_id => 5, :operator_id => 1)
  end

  def make_events
    date1 = Time.now - 10000000
    date2 = Time.now

    # lift 1
    5000.times do
      time = Time.at((date2.to_f - date1.to_f)*rand + date1.to_f)
      Event.create(:timestamp => time, :event_type_id => (1..2).to_a.sample, :lift_id => 5)
    end

    # lift 2
    5000.times do
      time = Time.at(rand Time.now.to_i)
      Event.create(:timestamp => time, :event_type_id => (1..2).to_a.sample, :lift_id => 2)
    end

    # lift 3
    5000.times do
      time = Time.at(rand Time.now.to_i)
      Event.create(:timestamp => time, :event_type_id => (1..2).to_a.sample, :lift_id => 3)
    end

    # lift 4
    5000.times do
      time = Time.at(rand Time.now.to_i)
      Event.create(:timestamp => time, :event_type_id => (1..2).to_a.sample, :lift_id => 4)
    end

    # lift 5
    5000.times do
      time = Time.at(rand Time.now.to_i)
      Event.create(:timestamp => time, :event_type_id => (1..2).to_a.sample, :lift_id => 5)
    end
  end



