using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSVBatchImport
{
    /// <summary>
    /// Convert a CSV - File
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

        public static string ConvertToDB(List<LiftEvent> events)
        {
            string retVal = "";
            try
            {
                Dictionary<string, int> Operators = new Dictionary<string, int>();
                Dictionary<string, int> Networks = new Dictionary<string, int>();
                Dictionary<string, int> Lines = new Dictionary<string, int>();
                Dictionary<string, int> Stations = new Dictionary<string, int>();
                Dictionary<string, int> Lifts = new Dictionary<string, int>();


                //find stations
                Program.Write("find stations");

                //TODO add operators
                //TODO add networks
                //TODO add eventstypes
                //TODO add lines
                //TODO add stations
                //TODO add stations to lines
                //TODO add lifts
                //TODO add events
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());
                throw new Exception("Error while parsing CSV", ex);
            }
            return retVal;

        }
    }
}
