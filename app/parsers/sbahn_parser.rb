class SbahnParser


  class << self

    # Parse the HTML and return a list of lifts, that are broken
    def parse(html_file, network)
      doc = Nokogiri::HTML.parse(html_file.read)
      doc.encoding = 'utf-8'

      container = find_lift_container(doc)

      broken_lifts = []

      container.css('#Row').each do |row|
        broken_lifts << process_row(row, network)
      end

      broken_lifts
    end

    def process_row(row, network)
      lines = find_lines(row, network)
      station_name = find_station_name(row)

      station = find_or_create_station_for_lines(station_name, lines)

      description = find_lift_description(row)

      find_or_create_lift_for_station(description, station)
    end

    def find_or_create_lift_for_station(description, station)
      lift = station.lifts.where(['lifts.description = ?', description]).first
      lift ||= Lift.create(:station => station, :operator => network.operator, :description => description)
    end

    def find_or_create_station_for_lines(station_name, lines)
      station = nil
      lines.each do |line|
        station = find_station_for_line(station_name, line)

        # if not found, check if station exists in this network
        if station.blank?
          station = find_station_for_network(station_name, network)
          # if it was found, add the line to this station
          station.lines << line if station
        end

        # if it is still not found, creat this station
        if station.blank?
          station = Station.create(:lines => [line], :name => station_name)
        end
      end
      station
    end

    def find_station_for_network(station_name, network)
      network.stations.where(['stations.name = ?', station_name]).first
    end

    def find_station_for_line(station_name, line)
      line.stations.where(['stations.name = ?', station_name]).first
    end

    def find_lines(row, network)
      line_names = row.search("#{row.path}//td[4]").css('a').map(&:content)
      line_names.collect do |line_name|
        line = network.lines.where(["lines.name = ?", line_name]).first
        line = Line.create(:network => network, :name => line_name) if line.blank?
        line
      end.compact
    end

    def find_station_name(row)
      row.search("#{row.path}//td[1]").css('a').first.content
    end

    def find_lift_description(row)
      row.search("#{row.path}//td[2]").first.content
    end

    def find_lift_container(doc)
      find_lift_headline(doc).ancestors('#Tabelle')
    end

    def find_lift_headline(doc)
      headlines = doc.css('#Tabelle h4')
      lift_headline = nil
      headlines.each do |headline|
        if headline.content.include?('Aufzüge')
          lift_headline = headline
          break
        end
      end
      lift_headline
    end
  end
end