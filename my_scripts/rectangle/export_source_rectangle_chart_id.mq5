//+------------------------------------------------------------------+
//|                           export_source_rectangle_chart_id.mq5   |
//|   Exports chart ID and rectangle names to a JSON file             |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string output_filename = "chart_rectangles.json";

void OnStart()
{
   long chart_id = ChartID();
   int total_objects = ObjectsTotal(0, -1, -1); // all objects on current chart

   string json = "{\n";
   json += StringFormat("  \"chart_id\": %I64d,\n", chart_id);
   json += "  \"rectangles\": [";

   int rect_count = 0;
   for(int i = 0; i < total_objects; i++)
   {
      string name = ObjectName(0, i);
      if(ObjectGetInteger(0, name, OBJPROP_TYPE) == OBJ_RECTANGLE)
      {
         if(rect_count > 0)
            json += ", ";
         json += StringFormat("\"%s\"", name);
         rect_count++;
      }
   }

   json += "]\n}";

   // Save file in MQL5/Files
   int handle = FileOpen(output_filename, FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(handle != INVALID_HANDLE)
   {
      FileWriteString(handle, json);
      FileClose(handle);

      string full_path = TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL5\\Files\\" + output_filename;
      Print("Exported rectangle names to: ", full_path);
   }
   else
   {
      Print("Error opening file for writing: ", GetLastError());
   }
}
