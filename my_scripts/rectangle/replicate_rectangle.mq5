//+------------------------------------------------------------------+
//|           load_rectangle_config.mq5                              |
//|   Loads chart ID and rectangle name from a text file             |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

// Variables that will be filled from the file
long   source_chart_id_input = 0;
string rect_name             = "";

// Function to load chart ID and rectangle name from file
bool LoadConfig(string filename)
{
   int handle = FileOpen(filename, FILE_READ | FILE_TXT | FILE_ANSI);
   if(handle == INVALID_HANDLE)
   {
      Print("Error opening config file: ", GetLastError());
      return false;
   }

   // First line: chart ID
   string line1 = FileReadString(handle);
   if(StringLen(line1) > 0)
      source_chart_id_input = (long)StringToInteger(line1);

   // Second line: rectangle name
   string line2 = FileReadString(handle);
   if(StringLen(line2) > 0)
      rect_name = line2;

   FileClose(handle);
   return true;
}

void OnStart()
{
   string filename = "config.txt"; // must be inside MQL5/Files
   if(!LoadConfig(filename))
   {
      Print("Failed to load config. Exiting.");
      return;
   }

   // If chart ID is 0, auto-detect current chart
   if(source_chart_id_input == 0)
      source_chart_id_input = ChartID();

   Print("Loaded config:");
   Print(" Chart ID = ", source_chart_id_input);
   Print(" Rectangle name = ", rect_name);

   // Example usage: check if rectangle exists
   if(ObjectFind(source_chart_id_input, rect_name) >= 0)
   {
      Print("Rectangle '", rect_name, "' found on chart ", source_chart_id_input);
   }
   else
   {
      Print("Rectangle '", rect_name, "' NOT found on chart ", source_chart_id_input);
   }
}
