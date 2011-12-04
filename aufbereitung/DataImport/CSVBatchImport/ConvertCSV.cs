/****************************************************************
 * RHoK / Berlin 
 * DataImport for Sozialhelden / BrokenLift 
 * 
 * Author: Daniel Bedarf
 **************************************************************** 
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace CSVBatchImport
{
    /// <summary>
    /// Convert a CSV - File.
    /// Read the CSV to internal Objects, than export objects to specific format
    /// </summary>
    class ConvertCSV
    {
        /// <summary>
        /// Converts the specified source.
        /// </summary>
        /// <param name="Source">The source.</param>
        /// <param name="Data">The data.</param>
        /// <param name="Mode">The mode.</param>
        /// <returns></returns>
        internal static List<LiftEvent> Read(string Source, List<string> Data, OutputMode Mode)
        {
            List<LiftEvent> retVal = new List<LiftEvent>();
            try
            {
                Program.Write("Start Parse: {0}", Source);
                //just to simple parse the headers
                List<string> Header = new List<string>();
                bool firstRow = true;
                foreach (string line in Data)
                {
                    if (firstRow)
                    {
                        firstRow = false;
                        //create the header for propbags
                        foreach (string sheader in line.Split(new char[] { ';' }))
                        {
                            Header.Add(sheader.ToLower());
                        }
                        //just to ignore errors
                        for (int i = 0; i <= 8; i++) Header.Add("dummy_" + i.ToString());
                    }
                    else
                    {

                        Dictionary<string, string> propBag = new Dictionary<string, string>();
                        propBag.Add("source", Source);
                        int propCount = 0;
                        foreach (string prop in line.Split(new char[] { ';' }))
                        {
                            propBag.Add(Header[propCount], prop);
                            propCount++;
                        }

                        LiftEvent le = new LiftEvent(propBag);
                        retVal.Add(le);
                        if (propBag.ContainsKey("ende"))
                        {
                            DateTime dt;
                            if (DateTime.TryParse(propBag["ende"], out dt))
                            {
                                //TODO: better check, datetime.parse or so 
                                propBag["start"] = propBag["ende"];
                                le = new LiftEvent(propBag);
                                le.isBroken = false;
                                retVal.Add(le);
                            }
                            else
                            {
                                le.Memo = propBag["ende"];
                            }
                        }//contains ende

                    }//end else first row
                }//end foreach entry
                Program.Write("Read \"{0}\" sucessfull with {1} entrys", Source, retVal.Count);

            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());
                throw new Exception("Error while parsing CSV", ex);
            }
            return retVal;
        }

        /// <summary>
        /// Converts to SQL - Statements
        /// </summary>
        /// <param name="events">The events.</param>
        /// <param name="?">The ?.</param>
        /// <param name="StationLocationsLongAlt">The station locations long alt. or an empty collection. not null!</param>
        /// <returns></returns>
        public static string ConvertToDB(List<LiftEvent> events, Dictionary<string, KeyValuePair<string, string>> StationLocationsLongAlt)
        {
            string retVal = "";
            try
            {
                System.IO.StringWriter sw = new System.IO.StringWriter();

                Dictionary<string, int> Operators = new Dictionary<string, int>();
                Dictionary<string, int> Networks = new Dictionary<string, int>();
                Dictionary<bool, int> EventTypes = new Dictionary<bool, int>();
                Dictionary<string, int> Lines = new Dictionary<string, int>();
                Dictionary<string, int> Stations = new Dictionary<string, int>();
                Dictionary<string, int> Lifts = new Dictionary<string, int>();
                Dictionary<string, int> Locations = new Dictionary<string, int>();
                List<string> LinesToStations = new List<string>();

                // add operators
                Program.Write("add operators and operators");
                Operators.Add(Program.OPERATOR_BVG, 1);
                Operators.Add(Program.OPERATOR_SBAHN, 2);
                foreach (var op in Operators)
                {
                    sw.WriteLine(string.Format("insert into operators (id, name) values ({0}, '{1}');", op.Value, op.Key));
                }

                //add networks, currently trhe same as operators
                Program.Write("add networks");
                Networks.Add(Program.OPERATOR_BVG, 1);
                Networks.Add(Program.OPERATOR_SBAHN, 2);
                foreach (var nw in Networks)
                {
                    sw.WriteLine(string.Format("insert into networks (id, name, operator_id) values ({0}, '{1}', {2});", nw.Value, nw.Key, Operators[nw.Key]));
                }

                //TODO add eventstypes
                Program.Write("add eventtypes");
                EventTypes.Add(true, 1);
                EventTypes.Add(false, 2);
                foreach (var kvp in EventTypes)
                {
                    sw.WriteLine(string.Format("insert into event_types (id, name, is_working) values ({0}, '{1}', {2});", kvp.Value, kvp.Key ? "broken" : "working", kvp.Key ? "FALSE" : "TRUE"));
                }

                Program.Write("search stations, lines, lifts and events");
                foreach (var entry in events)
                {
                    if (!Lines.ContainsKey(entry.Line))
                    {
                        Lines.Add(entry.Line, Lines.Count + 1);
                        sw.WriteLine(string.Format("insert into lines (id, name, network_id) values ({0}, '{1}', {2});", Lines[entry.Line], entry.Line, Networks[entry.Operator]));
                    }
                    if (!Stations.ContainsKey(entry.Station))
                    {
                        Stations.Add(entry.Station, Stations.Count + 1);
                        sw.WriteLine(string.Format("insert into stations (id, name) values ({0}, '{1}');", Stations[entry.Station], entry.Station));


                        ///mapping stations to gps
                        string stationkey = entry.Station.ToLower();
                        if (StationLocationsLongAlt.ContainsKey(stationkey))
                        {
                            if (!Locations.ContainsKey(stationkey))
                            {
                                Locations.Add(stationkey, Locations.Count + 1);
                                sw.WriteLine(string.Format("insert into locations (id, longitude, latitude) values ({0}, {1}, {2});", Locations[stationkey], StationLocationsLongAlt[stationkey].Key, StationLocationsLongAlt[stationkey].Value));
                            }//end insert location 
                            //now update the station
                            sw.WriteLine(string.Format("update stations set location_id={0} where station_id={1}", Locations[stationkey], Stations[entry.Station]));
                        }
                    }

                    //mapping lines to stations
                    if (!LinesToStations.Contains(string.Format("{0};#{1}", Lines.ContainsKey(entry.Line), Stations.ContainsKey(entry.Station))))
                    {
                        LinesToStations.Add(string.Format("{0};#{1}", Lines.ContainsKey(entry.Line), Stations.ContainsKey(entry.Station)));
                        sw.WriteLine(string.Format("insert into lines_stations (line_id, station_id) values ({0}, {1});", Lines[entry.Line], Stations[entry.Station]));
                    }

                    if (!Lifts.ContainsKey(entry.Lift))
                    {
                        Lifts.Add(entry.Lift, Lifts.Count + 1);
                        sw.WriteLine(string.Format("insert into lifts (id, description, station_id, operator_id) values ({0}, '{1}', {2}, {3});", Lifts[entry.Lift], entry.Lift, Stations[entry.Station], Operators[entry.Operator]));
                    }

                    sw.WriteLine(string.Format("insert into events (lift_id, event_type_id, timestamp) values ({0}, {1}, '{2}');", Lifts[entry.Lift], EventTypes[entry.isBroken], entry.EventTimestamp.ToString("yyyy-MM-dd HH:mm:ss")));
                }
                Program.Write("found {0} stations, {1} lines, {2} lifts, {3} events", Stations.Count, Lines.Count, Lifts.Count, events.Count);

#warning Just for RHoK Import !!
                //TODO replace with correct operator data (currently not available)
                sw.WriteLine("insert into manufacturers (id, name) values (1,'RHoK Fahrstuhlservice');");
                sw.WriteLine("update lifts set manufacturer_id=1;");
                //end RHoK special

                retVal = sw.ToString();
                System.Diagnostics.Trace.Write(retVal);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());
                throw new Exception("Error while creating sql", ex);
            }
            return retVal;

        }

    }
}
