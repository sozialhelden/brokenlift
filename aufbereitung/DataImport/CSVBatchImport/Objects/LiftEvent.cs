using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSVBatchImport
{
    /// <summary>
    /// a Event 
    /// </summary>
    public class LiftEvent
    {
        public LiftEvent(Dictionary<string,string> propBag)
        {
            if (propBag.ContainsKey("source")) Operator = propBag["source"]; else Operator = "";
            if (propBag.ContainsKey("start"))
            {
                DateTime dt = DateTime.MinValue; ;
                if (DateTime.TryParse(propBag["start"], out dt) == false)
                {
                    if (propBag.ContainsKey("ende"))
                    {
                        if (DateTime.TryParse(propBag["ende"], out dt))
                            EventTimestamp = dt;
                    }
                }
                if(dt!=DateTime.MinValue) 
                    EventTimestamp = dt;
                System.Diagnostics.Debug.Assert(dt != DateTime.MinValue, "Datum konnte nicht geparst werden");
            }
            if (propBag.ContainsKey("linie")) Line = propBag["linie"]; else Line = "";
            if (propBag.ContainsKey("station")) Station = propBag["station"]; else Station = "";
            if (propBag.ContainsKey("ebene")) Level = propBag["ebene"]; else Level = "";
            Memo = "";
            isBroken = true;
        }

        /// <summary>
        /// an internal ID, Currently the Station
        /// </summary>
        /// <value>The ID.</value>
        public string ID { get { return Station; } }

        /// <summary>
        /// Gets or sets the source.
        /// e.g. BVG, or S-Bahn
        /// </summary>
        /// <value>The source.</value>
        public string  Operator { get; set; }

        /// <summary>
        /// Gets or sets the event timestamp.
        /// </summary>
        /// <value>The event timestamp.</value>
        public DateTime EventTimestamp { get; set; }

        /// <summary>
        /// Gets or sets the line.
        /// e.g. U9, S75
        /// </summary>
        /// <value>The line.</value>
        public string Line { get; set; }

        /// <summary>
        /// Gets or sets the station.
        /// e.g: U Libschitzallee
        /// </summary>
        /// <value>The station.</value>
        public string Station { get; set; }

        /// <summary>
        /// Gets or sets the description from csv - file
        /// </summary>
        /// <value>The description.</value>
        public string Level { get; set; }

        /// <summary>
        /// Gets or sets the lift.
        /// Currently Station + Level
        /// </summary>
        /// <value>The lift.</value>
        public string Lift { get { return string.Format("{0} - {1}", Station, Level); } }

        /// <summary>
        /// Gets or sets the memo.
        /// Somtimes a end - value contains not a timestamp, then the memo is used to store these informations
        /// </summary>
        /// <value>The memo.</value>
        public string Memo { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this Elevator is broken.
        /// </summary>
        /// <value><c>true</c> if this instance is broken; otherwise, <c>false</c>.</value>
        public bool isBroken { get; set; }

        /// <summary>
        /// Detailed Informations
        /// </summary>
        /// <value>The event description.</value>
        public string EventDescription { get { return string.Format("{0} - {1} - {2} {3}", Line, Station, Level, Memo).Trim(); } }

        public override string ToString()
        {
            return EventDescription;
        }
    }
}
