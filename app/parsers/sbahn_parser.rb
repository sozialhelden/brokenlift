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
      external_id = find_station_id(row)

      station = find_or_create_station_for_lines(external_id, station_name, lines, network)

      description = find_lift_description(row)

      find_or_create_lift_for_station(description, station, network)
    end

    def find_or_create_lift_for_station(description, station, network)
      # Make sure this description is properly utf-8 encoded
      lift = station.lifts.where(["lifts.description = ?", description]).first
      lift ||= Lift.create(:station => station, :operator => network.operator, :description => description)
    end

    def find_or_create_station_for_lines(external_id, station_name, lines, network)
      station = nil
      lines.each do |line|
        station = find_station_for_line(external_id, station_name, line)

        # if not found, check if station exists in this network
        if station.blank?
          station = find_station_for_network(station_name, network)
          # if it was found, add the line to this station
          LinesStation.create(:line => line, :station => station, :external_id => external_id) if station
        end

        # if it is still not found, create this station
        if station.blank?
          station = Station.create(:name => station_name)
          LinesStation.create(:line => line, :station => station, :external_id => external_id)
        end
      end
      station
    end

    def find_station_for_line(external_id, station_name, line)
      station =    line.stations.where(['lines_stations.external_id = ?', external_id]).first
      station ||= line.stations.where(['stations.name = ?', station_name]).first
      if station
        lines_station = LinesStation.find_by_station_id_and_line_id(station.id, line.id)
        lines_station.update_attribute(:external_id, external_id) unless lines_station.external_id.present?
      end
      station
    end

    def find_station_for_network(station_name, network)
      network.stations.where(['stations.name = ?', station_name]).first
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
      # TODO manually convert from iso to utf
      row.search("#{row.path}//td[1]").css('a').first.content
    end

    def find_station_id(row)
      link_path = row.search("#{row.path}//td[1]//a/@href").to_s
      link_path.gsub(/^.*?ID=(\d+)/, '\1').to_i
    end

    def find_lift_description(row)
      # TODO manually convert from iso to utf
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