require 'spec_helper'

describe UbahnParser do
  let(:html_file) {File.open(File.expand_path("../spec/fixtures/ubahn_message.html", "__FILE__"))}
  let(:doc) {Nokogiri::HTML.parse(html_file.read)}

  it "should find the container" do
    UbahnParser::find_lift_container(doc).count.should == 1
  end

  it "should find the rows in the container" do
    UbahnParser::find_lift_rows(doc).count.should == 2
  end

  it "should find the 'station name' of each row" do
    rows = UbahnParser::find_lift_rows(doc)
    rows.each do |row|
      station_name = UbahnParser::find_station_name(row)
      station_name.should be_a(String)
      station_name.should_not be_empty
    end
  end

  it "should find 'lift location' of each row" do
    rows = UbahnParser::find_lift_rows(doc)
    rows.each do |row|
      lift_location = UbahnParser::find_lift_location(row)
      lift_location.should be_a(String)
      lift_location.should_not be_empty
    end
  end

  it "should return an array of broken lifts" do
    UbahnParser::parse(html_file).size.should == 2
  end

end

