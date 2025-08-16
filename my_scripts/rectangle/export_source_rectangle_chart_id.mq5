//+------------------------------------------------------------------+
//|         export_source_rectangle_chart_id_plaintext.mq5           |
//|   Exports chart ID and rectangle names to a text file            |
//+------------------------------------------------------------------+
#property script_show_inputs
#property strict

input string base_filename = "chart_rectangles.txt"; // file extension is .txt

void OnStart()
{
   string symbol = ChartSymbol(0);               
   string output_filename = symbol + "_" + base_filename;

   long chart_id = ChartID();
   int total_objects = ObjectsTotal(0, -1, -1); 

   // Open file for writing (ANSI text)
   int handle = FileOpen(output_filename, FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(handle == INVALID_HANDLE)
   {
      Print("Error opening file for writing: ", GetLastError());
      return;
   }

   // First line: chart ID
   FileWriteString(handle, IntegerToString(chart_id) + "\n");

   // Next lines: rectangle names
   for(int i = 0; i < total_objects; i++)
   {
      string name = ObjectName(0, i);
      if(ObjectGetInteger(0, name, OBJPROP_TYPE) == OBJ_RECTANGLE)
      {
         FileWriteString(handle, name + "\n");
      }
   }

   FileClose(handle);

   string full_path = TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL5\\Files\\" + output_filename;
   Print("Exported chart ID and rectangle names to: ", full_path);
}
