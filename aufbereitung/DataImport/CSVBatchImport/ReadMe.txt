Requirements:

.Net Frameworkk 4

The output is formatted as UTF8

Data:
	BGV.csv (";") as splitter and with the following columns
		Line
		Station
		Ebene
		Start
		Ende

	SBahn.csv (";") as splitter and with the following columns
		Line
		Station
		Ebene
		Start
		Ende

	you can edit the columns in LiftEvent.cs

	Location.csv with ";" as splitter and teh following data
		1. row = StationName
		2. row = Longitude
		3. row = Altitude

		you can change this in Program.cs