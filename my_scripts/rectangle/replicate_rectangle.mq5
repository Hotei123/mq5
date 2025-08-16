//+------------------------------------------------------------------+
//| Copy rectangle from one chart to another                         |
//+------------------------------------------------------------------+
#property strict

// Inputs
input long   source_chart_id_input = 132617308278369132; // Source chart ID (0 = auto-detect another chart)
input string rect_name             = "r0"; // Name of the rectangle to copy
input long   target_chart_id       = 0;       // Target chart ID (0 = current chart)

//+------------------------------------------------------------------+
void OnStart()
{
   long source_chart_id = source_chart_id_input; // Local copy so we can modify

   // If source_chart_id not given, try to find another open chart for the same symbol
   if(source_chart_id == 0)
   {
      long chart = ChartFirst();
      while(chart != -1)
      {
         if(chart != ChartID()) // not current chart
         {
            source_chart_id = chart;
            break;
         }
         chart = ChartNext(chart);
      }
   }

   if(source_chart_id == 0)
   {
      Print("No source chart found.");
      return;
   }

   // Read coordinates from source chart
   datetime t1, t2;
   double p1, p2;
   if(ObjectFind(source_chart_id, rect_name) < 0)
   {
      Print("Rectangle not found on source chart.");
      return;
   }

   ObjectGetInteger(source_chart_id, rect_name, OBJPROP_TIME, 0, t1);
   ObjectGetDouble(source_chart_id, rect_name, OBJPROP_PRICE, 0, p1);
   ObjectGetInteger(source_chart_id, rect_name, OBJPROP_TIME, 1, t2);
   ObjectGetDouble(source_chart_id, rect_name, OBJPROP_PRICE, 1, p2);

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

   PrintFormat("Rectangle copied from Chart ID: %I64d to Chart ID: %I64d", source_chart_id, target_chart_id);
}
