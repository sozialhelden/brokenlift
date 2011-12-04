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
using System.Windows.Forms;

namespace CSVBatchImport
{
    class Program
    {

        public const string OPERATOR_BVG = "BVG";
        public const string OPERATOR_SBAHN = "S-Bahn";

        /// <summary>
        /// application entry point
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            bool silentMode = System.Environment.CommandLine.Contains(" /s ");
            try
            {

                Write("BrokenLift - DataImport Version: {0}", System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString());

                Write("-----------------------------------------------------------------");
                Write("\nCommands:\n");
                Write("\t/s\t\tsilent mode");
                Write("\t/bvg:filename\tthe import file (csv) for the \"bvg\" data");
                Write("\t/sbahn:filename\tthe import file (csv) for the \"s-bahn\" data");
                Write("\n-----------------------------------------------------------------\n\n");

                string filenameBVG = "bvg.csv";
                if (System.Environment.CommandLine.Contains(" /bvg:")) throw new NotImplementedException();
                string filenameSBahn = "sbahn.csv";
                if (System.Environment.CommandLine.Contains(" /sbahn:")) throw new NotImplementedException();
                string filenameLocations = "";
                if (System.Environment.CommandLine.Contains(" /locations:")) throw new NotImplementedException();
                OutputMode mode = OutputMode.SQL;

                if (!silentMode)
                {
                    OpenFileDialog ofd = new OpenFileDialog();
                    ofd.Filter = "*.csv|*.csv|*.*|*.*";
                    ofd.Multiselect = false;
                    ofd.CheckFileExists = true;

                    ofd.Title = "Open BVG Data";
                    if (ofd.ShowDialog() != DialogResult.OK) throw new Exception("No BVG-File selected.");
                    filenameBVG = ofd.FileName;

                    ofd.Title = "Open S-Bahn Data";
                    if (ofd.ShowDialog() != DialogResult.OK) throw new Exception("No BVG-File selected.");
                    filenameSBahn = ofd.FileName;

                    ofd.Title = "GPS Locations";
                    if (ofd.ShowDialog() == DialogResult.OK) filenameLocations = ofd.FileName;

                    //if (MessageBox.Show("Do you like to output the data as json?", "Please define output-format", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                    //    mode = OutputMode.JSON;

                }

                List<LiftEvent> events = new List<LiftEvent>();

                List<string> csvData = new List<string>(System.IO.File.ReadAllLines(filenameBVG, System.Text.ASCIIEncoding.Default));
                events.AddRange(ConvertCSV.Read(Source: OPERATOR_BVG, Data: csvData, Mode: mode));

                csvData = new List<string>(System.IO.File.ReadAllLines(filenameSBahn, System.Text.ASCIIEncoding.Default));
                events.AddRange(ConvertCSV.Read(Source: OPERATOR_SBAHN, Data: csvData, Mode: mode));

                Dictionary<string, KeyValuePair<string, string>> StationLocationsLongAlt = new Dictionary<string, KeyValuePair<string, string>>();
                if (!string.IsNullOrEmpty(filenameLocations))
                {
                    foreach (string line in System.IO.File.ReadAllLines(filenameLocations, System.Text.ASCIIEncoding.Default))
                    {
                        string[] arrGPS = line.ToLower().Split(new char[] { ';' });
                        if (!StationLocationsLongAlt.ContainsKey(arrGPS[0]))
                        {
                            StationLocationsLongAlt.Add(arrGPS[0].Replace("(berlin)", "").Trim(), new KeyValuePair<string, string>(arrGPS[1], arrGPS[2]));
                        }
                    }
                }

                string script = ConvertCSV.ConvertToDB(events, StationLocationsLongAlt);

                //TODO Silent Mode
                System.Windows.Forms.SaveFileDialog sfd = new SaveFileDialog();
                sfd.Filter = string.Format("*.{0}|*.{0}", mode.ToString());
                sfd.Title = string.Format("Save {0} - File", mode.ToString());
                if (sfd.ShowDialog() == DialogResult.OK) System.IO.File.WriteAllText(sfd.FileName, script, System.Text.ASCIIEncoding.UTF8);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());
                Write(ex);
                if (!silentMode) MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }

        }

        #region Helper
        /// <summary>
        /// Writes the specified exception
        /// </summary>
        /// <param name="ex">The ex.</param>
        internal static void Write(Exception ex)
        {
            ConsoleColor corg = Console.ForegroundColor;
            Console.ForegroundColor = ConsoleColor.Yellow;
            if (ex.InnerException != null) Write(ex.InnerException);
            Console.Error.WriteLine("Error: {0}", ex.Message);
            Console.ForegroundColor = corg;
        }

        /// <summary>
        /// Writes the specified message.
        /// </summary>
        /// <param name="Message">The message.</param>
        internal static void Write(string Message)
        {
            Write(Message, "");
        }

        /// <summary>
        /// Writes the specified message.
        /// </summary>
        /// <param name="Message">The message.</param>
        /// <param name="args">The args.</param>
        internal static void Write(string Message, params object[] args)
        {
            Console.WriteLine(Message, args);
        }
        #endregion

    }
}
