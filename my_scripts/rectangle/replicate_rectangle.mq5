//+------------------------------------------------------------------+
//| Copy rectangle from one chart to another                         |
//+------------------------------------------------------------------+
#property strict

// Inputs
long   source_chart_id_input = 0;       // Source chart ID (0 = auto-detect another chart)
string rect_name             = "r0"; // Name of the rectangle to copy
long   target_chart_id       = 0;       // Target chart ID (0 = current chart)


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

//+------------------------------------------------------------------+
void OnStart()
{
   if(!LoadConfig(ChartSymbol(0) + "_rectangles.txt"))
      return;

   Print("Loaded chart_id=", source_chart_id_input, " rectangle=", rect_name);

   // If source_chart_id not given, try to find another open chart for the same symbol
   if(source_chart_id_input == 0)
   {
      long chart = ChartFirst();
      while(chart != -1)
      {
         if(chart != ChartID()) // not current chart
         {
            source_chart_id_input = chart;
            break;
         }
         chart = ChartNext(chart);
      }
   }

   if(source_chart_id_input == 0)
   {
      Print("No source chart found.");
      return;
   }

   // Read coordinates from source chart
   datetime t1, t2;
   double p1, p2;
   if(ObjectFind(source_chart_id_input, rect_name) < 0)
   {
      Print("Rectangle not found on source chart.");
      return;
   }

   ObjectGetInteger(source_chart_id_input, rect_name, OBJPROP_TIME, 0, t1);
   ObjectGetDouble(source_chart_id_input, rect_name, OBJPROP_PRICE, 0, p1);
   ObjectGetInteger(source_chart_id_input, rect_name, OBJPROP_TIME, 1, t2);
   ObjectGetDouble(source_chart_id_input, rect_name, OBJPROP_PRICE, 1, p2);

   // Create on target chart
   string new_rect_name = rect_name + "_copy";
   if(!ObjectCreate(target_chart_id, new_rect_name, OBJ_RECTANGLE, 0, t1, p1, t2, p2))
   {
      Print("Error creating rectangle on target chart: ", GetLastError());
      return;
   }

   // Copy style
   ObjectSetInteger(target_chart_id, new_rect_name, OBJPROP_COLOR, clrGreen);
   ObjectSetInteger(target_chart_id, new_rect_name, OBJPROP_WIDTH, 1);
   ObjectSetInteger(target_chart_id, new_rect_name, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(target_chart_id, new_rect_name, OBJPROP_FILL, true);
   ObjectSetInteger(target_chart_id, new_rect_name, OBJPROP_BACK, false);

   PrintFormat("Rectangle copied from Chart ID: %I64d to Chart ID: %I64d", source_chart_id_input, target_chart_id);
}