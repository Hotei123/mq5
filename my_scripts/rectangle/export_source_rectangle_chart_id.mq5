//+------------------------------------------------------------------+
//| Prints Chart ID in Experts tab                                   |
//+------------------------------------------------------------------+
#property strict
void OnStart()
{
   long id = ChartID();
   PrintFormat("📌 Chart ID for %s (%s) is: %I64d", _Symbol, EnumToString(_Period), id);
}
