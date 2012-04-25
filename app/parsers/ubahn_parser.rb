class UbahnParser

  class << self
    # Internal: parse the HTMl file and returns an array
    #
    # html_file - file containing the HTML presentation
    #
    # Examples
    #
    #   parse(html_file)
    #   # => [['U Nollendorfplatz', 'Straße &lt;&gt; Bahnsteig U-Bahn']]
    #
    # Returns an array of arrays with where each entry consists of <station-name>
    # an <location-name>
    def parse(html_file)
      doc = Nokogiri::HTML.parse(html_file.read)
      doc.encoding = 'utf-8'

      broken_lifts = []
      lift_rows = find_lift_rows(doc)

      lift_rows.each do |row|
        lift_row = []
        lift_station = find_station_name(row)
        lift_location = find_lift_location(row)
        lift_row << lift_station
        lift_row << lift_location
        broken_lifts << lift_row
      end

      broken_lifts
    end

    # Internal: find the Container for the lift objects
    #
    # doc - HTMl in Nokogiri format with utf-8 encoding
    #
    # Examples:
    #
    #   file = File.open('test.html')
    #   find_lift_container(file)
    #   # => '<!DOCTYPE html>
    #         <html>
    #         <head>
    #           ....
    #         </head>
    #         <body>
    #           ...
    #         </body>
    #         </html>
    #
    # Returns the Nokogiri nodeset for the elevator overview
    def find_lift_container(doc)
      container = doc.xpath('//table[@class="col2_tbl elevator_overview"]')
      container
    end

    # Internal: saves each row with broken lifts in an array
    #
    # doc - HTMl in Nokogiri format with utf-8 encoding
    #
    # Examples:
    #
    #   find_lift_container(File.open('test.html'))
    #   # => ['<tr>
    #          <td class="col_two">U Nollendorfplatz</td>
    #          <td> <a href="/9466/name/Aufzugsmeldungen/elevator/133158.html">...</td>
    #          </tr>']
    #
    # Returns an array with the HTM entries of table rows
    def find_lift_rows(doc)
      lift_rows = []

      container = find_lift_container(doc)
      rows = container.xpath('//tbody/tr').each do |row|
        lift_rows << row
      end

      lift_rows
    end

    # Internal: parse the row and extract the station name
    #
    # row - a string in the form of a <tr>-HTML element
    #
    # Examples
    #
    #   row <<=START
    #     <tr>
    #      <td class="col_one"><span class="line" style="background-color:#D71910">U2</span></td>
    #      <td class="col_two">U Nollendorfplatz</td>
    #     <tr>
    #
    #   find_station_name(row)
    #   # => 'U Nollendorfplatz'
    #
    # Returns a string with name of the lift station
    def find_station_name(row)
      # find the element
      station_name = row.css('td[2]').text
      # remove line-breaks
      station_name.gsub(/\n/, " ")
    end

    # Internal: parse the row and extract the location name
    #
    # row - a string in the form of a <tr>-HTML element
    #
    # Examples
    #
    #   row <<=START
    #     <tr>
    #      <td class="col_one">...</td>
    #      <td class="col_two">...</td>
    #      <td>Straße &lt;&gt; Bahnsteig U-Bahn</td>
    #     <tr>
    #
    #   find_station_name(row)
    #   # => 'Straße &lt;&gt; Bahnsteig U-Bahn'
    #
    # Returns a string with name of the lift station
    def find_lift_location(row)
      # find the element
      lift_location = row.css('td[3]').text
      # remove line-breaks
      lift_location.gsub(/\n/, " ")
    end

  end

end

