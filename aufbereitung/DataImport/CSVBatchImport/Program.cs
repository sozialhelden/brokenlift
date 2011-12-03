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
        /// <summary>
        /// application entry point
        /// </summary>
        static void Main(string[] args)
        {
            try
            {

                Write("BrokenLift - DataImport Version: {0}", System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString());
                Write("\nCommands: ");
                Write("\t/s\tsilent mode");
                Write("\t/bvg:filename\tthe import file (csv) for the \"bvg\" data");
                Write("\t/sbahn:filename\tthe import file (csv) for the \"s-bahn\" data");

                bool silentMode = System.Environment.CommandLine.Contains(" /s ");
                string filenameBVG = "bvg.csv";
                if (System.Environment.CommandLine.Contains(" /bvg:")) throw new NotImplementedException();
                string filenameSBahn = "sbahn.csv";
                if (System.Environment.CommandLine.Contains(" /sbahn:")) throw new NotImplementedException();

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
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());
                Write(ex);
            }

        }

        #region Helper
        /// <summary>
        /// Writes the specified exception
        /// </summary>
        /// <param name="ex">The ex.</param>
        private static void Write(Exception ex)
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
        private static void Write(string Message)
        {
            Write(Message, "");
        }

        /// <summary>
        /// Writes the specified message.
        /// </summary>
        /// <param name="Message">The message.</param>
        /// <param name="args">The args.</param>
        private static void Write(string Message, params object[] args)
        {
            Console.WriteLine(Message, args);
        }
        #endregion

    }
}
