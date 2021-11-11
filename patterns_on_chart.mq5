//+------------------------------------------------------------------+
//|                                               Chart_Patterns.mq5 |
//|                                    Copyright 2021, Filip Materak |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property description "Recognizes Japanese candlestick patterns and sends notifications."

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
#property indicator_color1 Blue
#property indicator_type1   DRAW_ARROW
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
#property indicator_color2 Orange
#property indicator_type2   DRAW_ARROW
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

input bool UseExtraDigit=false; //True if your broker uses extra digit in quotes

input bool Show_Alert=true;

input bool Display_ShootStar_2=true;
input bool Show_ShootStar_Alert_2=true;
input bool Display_ShootStar_3=true;
input bool Show_ShootStar_Alert_3=true;
input bool Display_ShootStar_4=true;
input bool Show_ShootStar_Alert_4=true;
input color Color_ShootStar=DeepPink;
int Text_ShootStar=8;

input bool Display_Hammer_2=true;
input bool Show_Hammer_Alert_2=true;
input bool Display_Hammer_3=true;
input bool Show_Hammer_Alert_3=true;
input bool Display_Hammer_4=true;
input bool Show_Hammer_Alert_4=true;
input color Color_Hammer=Green;
int Text_Hammer=8;

input bool Display_Doji=true;
input bool Show_Doji_Alert=true;
input color Color_Doji=SpringGreen;
int Text_Doji=8;

input bool Display_Stars=true;
input bool Show_Stars_Alert = true;
input int  Star_Body_Length = 5;
input color Color_Star=Aqua;
int Text_Star=8;

input bool Display_Dark_Cloud_Cover=true;
input bool Show_DarkCC_Alert=true;
input color Color_DarkCC=Brown;
int Text_DarkCC=8;

input bool Display_Piercing_Line=true;
input bool Show_Piercing_Line_Alert=true;
input color Color_Piercing_Line=Green;
int Text_Piercing_Line=8;

input bool Display_Bearish_Engulfing=true;
input bool Show_Bearish_Engulfing_Alert=true;
input color Color_Bearish_Engulfing=Red;
int Text_Bearish_Engulfing=8;

input bool Display_Bullish_Engulfing=true;
input bool Show_Bullish_Engulfing_Alert=true;
input color Color_Bullish_Engulfing=Green;
int Text_Bullish_Engulfing=8;

//---- buffers
double upArrow[];
double downArrow[];

string period;
double Doji_Star_Ratio= 0;
double Doji_MinLength = 0;
double Star_MinLength = 0;
int  Pointer_Offset = 0;         // The offset value for the arrow to be located off the candle high or low point.
int  High_Offset = 0;            // The offset value added to the high arrow pointer for correct plotting of the pattern label.
int  Offset_ShootStar = 0;       // The offset value of the shooting star above or below the pointer arrow.
int  Offset_Hammer = 0;          // The offset value of the hammer above or below the pointer arrow.
int  Offset_Doji = 0;            // The offset value of the doji above or below the pointer arrow.
int  Offset_Star = 0;            // The offset value of the star above or below the pointer arrow.
int  Offset_Piercing_Line = 0;   // The offset value of the piercing line above or below the pointer arrow.
int  Offset_DarkCC = 0;          // The offset value of the dark cloud cover above or below the pointer arrow.
int  Offset_Bullish_Engulfing = 0;
int  Offset_Bearish_Engulfing = 0;
int  IncOffset=0;              // The offset value that is added to a cummaltive offset value for each pass through the routine so any 
                               // additional candle patterns that are also met, the label will print above the previous label. 
double Piercing_Line_Ratio = 0;
int Piercing_Candle_Length = 0;
int Engulfing_Length=0;
double Candle_WickBody_Percent=0;
int CandleLength=0;
string symbol = ChartSymbol(0);
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME,"PRM");

   PlotIndexSetInteger(0,PLOT_ARROW,71);
   PlotIndexSetInteger(1,PLOT_ARROW,72);

   SetIndexBuffer(0,upArrow);
   SetIndexBuffer(1,downArrow);

   ArraySetAsSeries(upArrow,true);
   ArraySetAsSeries(downArrow,true);

   Comment("\n","\n","Bearish",
           "\n","Shooting_Star 2,3,4 - Shooting Star",
           "\n","Evening_Star   - Evening Star",
           "\n","Evening_DojiS   - Evening Doji Star",
           "\n","Dark_Cloud      - Dark Cloud Pattern",
           "\n","Bear_Engulfing      - Bearish Engulfing Pattern",
           "\n","\n","Bullish",
           "\n","Bull_Hammer 2,3,4 - Bullish Hammer",
           "\n","Morning_Star    - Morning Star",
           "\n","Morning_Doji    - Morning Doji Star",
           "\n","Piercing_Line       - Piercing Line Pattern",
           "\n","Bull_Engulfing       - Bullish Engulfing Pattern");

//Defining the pip and ratio dependencies based on the timeframe
   switch(_Period)
     {
      case PERIOD_M1:
         period="M1";
         Doji_Star_Ratio=0;
         Piercing_Line_Ratio=0.5;
         Piercing_Candle_Length=10;
         Engulfing_Length=10;
         Candle_WickBody_Percent=0.9;
         CandleLength=12;
         Pointer_Offset=9;
         High_Offset=15;
         Offset_Hammer=5;
         Offset_ShootStar=5;
         Offset_Doji = 5;
         Offset_Star = 5;
         Offset_Piercing_Line=5;
         Offset_DarkCC=5;
         Offset_Bearish_Engulfing = 5;
         Offset_Bullish_Engulfing = 5;
         Text_ShootStar=8;
         Text_Hammer=8;
         Text_Star=8;
         Text_DarkCC=8;
         Text_Piercing_Line=8;
         Text_Bearish_Engulfing = 8;
         Text_Bullish_Engulfing = 8;
         IncOffset=16;
         break;
      case PERIOD_M5:
         period="M5";
         Doji_Star_Ratio=0;
         Piercing_Line_Ratio=0.5;
         Piercing_Candle_Length=10;
         Engulfing_Length=10;
         Candle_WickBody_Percent=0.9;
         CandleLength=12;
         Pointer_Offset=9;
         High_Offset=15;
         Offset_Hammer=5;
         Offset_ShootStar=5;
         Offset_Doji = 5;
         Offset_Star = 5;
         Offset_Piercing_Line=5;
         Offset_DarkCC=5;
         Offset_Bearish_Engulfing = 5;
         Offset_Bullish_Engulfing = 5;
         Text_ShootStar=8;
         Text_Hammer=8;
         Text_Star=8;
         Text_DarkCC=8;
         Text_Piercing_Line=8;
         Text_Bearish_Engulfing = 8;
         Text_Bullish_Engulfing = 8;
         IncOffset=16;
         break;
      case PERIOD_M15:
         period="M15";
         Doji_Star_Ratio=0;
         Piercing_Line_Ratio=0.5;
         Piercing_Candle_Length=10;
         Engulfing_Length=0;
         Candle_WickBody_Percent=0.9;
         CandleLength=12;
         Pointer_Offset=9;
         High_Offset=15;
         Offset_Hammer=5;
         Offset_ShootStar=5;
         Offset_Doji = 5;
         Offset_Star = 5;
         Offset_Piercing_Line=5;
         Offset_DarkCC=5;
         Offset_Bearish_Engulfing = 5;
         Offset_Bullish_Engulfing = 5;
         Text_ShootStar=8;
         Text_Hammer=8;
         Text_Star=8;
         Text_DarkCC=8;
         Text_Piercing_Line=8;
         Text_Bearish_Engulfing = 8;
         Text_Bullish_Engulfing = 8;
         IncOffset=16;
         break;
      case PERIOD_M30:
         period="M30";
         Doji_Star_Ratio=0;
         Piercing_Line_Ratio=0.5;
         Piercing_Candle_Length=10;
         Engulfing_Length=15;
         Candle_WickBody_Percent=0.9;
         CandleLength=12;
         Pointer_Offset=9;
         High_Offset=15;
         Offset_Hammer=5;
         Offset_ShootStar=5;
         Offset_Doji = 5;
         Offset_Star = 5;
         Offset_Piercing_Line=5;
         Offset_DarkCC=5;
         Offset_Bearish_Engulfing = 5;
         Offset_Bullish_Engulfing = 5;
         Text_ShootStar=8;
         Text_Hammer=8;
         Text_Star=8;
         Text_DarkCC=8;
         Text_Piercing_Line=8;
         Text_Bearish_Engulfing = 8;
         Text_Bullish_Engulfing = 8;
         IncOffset=16;
         break;
      case PERIOD_H1:
         period="Highest1";
         Doji_Star_Ratio=0;
         Piercing_Line_Ratio=0.5;
         Piercing_Candle_Length=10;
         Engulfing_Length=25;
         Candle_WickBody_Percent=0.9;
         CandleLength=12;
         Pointer_Offset=9;
         High_Offset=20;
         Offset_Hammer=8;
         Offset_ShootStar=8;
         Offset_Doji = 8;
         Offset_Star = 8;
         Offset_Piercing_Line=8;
         Offset_DarkCC=8;
         Offset_Bearish_Engulfing = 8;
         Offset_Bullish_Engulfing = 8;
         Text_ShootStar=8;
         Text_Hammer=8;
         Text_Star=8;
         Text_DarkCC=8;
         Text_Piercing_Line=8;
         Text_Bearish_Engulfing = 8;
         Text_Bullish_Engulfing = 8;
         IncOffset=18;
         break;
      case PERIOD_H4:
         period="H4";
         Doji_Star_Ratio=0;
         Piercing_Line_Ratio=0.5;
         Piercing_Candle_Length=10;
         Engulfing_Length=20;
         Candle_WickBody_Percent=0.9;
         CandleLength=12;
         Pointer_Offset=20;
         High_Offset=40;
         Offset_Hammer=10;
         Offset_ShootStar=10;
         Offset_Doji = 10;
         Offset_Star = 10;
         Offset_Piercing_Line=10;
         Offset_DarkCC=10;
         Offset_Bearish_Engulfing = 10;
         Offset_Bullish_Engulfing = 10;
         Text_ShootStar=8;
         Text_Hammer=8;
         Text_Star=8;
         Text_DarkCC=8;
         Text_Piercing_Line=8;
         Text_Bearish_Engulfing = 8;
         Text_Bullish_Engulfing = 8;
         IncOffset=25;
         break;
      case PERIOD_D1:
         period="D1";
         Doji_Star_Ratio=0;
         Piercing_Line_Ratio=0.5;
         Piercing_Candle_Length=10;
         Engulfing_Length=30;
         Candle_WickBody_Percent=0.9;
         CandleLength=12;
         Pointer_Offset=9;
         High_Offset=80;
         Offset_Hammer=15;
         Offset_ShootStar=15;
         Offset_Doji = 15;
         Offset_Star = 15;
         Offset_Piercing_Line=15;
         Offset_DarkCC=15;
         Offset_Bearish_Engulfing = 15;
         Offset_Bullish_Engulfing = 15;
         Text_ShootStar=8;
         Text_Hammer=8;
         Text_Star=8;
         Text_DarkCC=8;
         Text_Piercing_Line=8;
         Text_Bearish_Engulfing = 8;
         Text_Bullish_Engulfing = 8;
         IncOffset=60;
         break;
      case PERIOD_W1:
         period="W1";
         Doji_Star_Ratio=0;
         Piercing_Line_Ratio=0.5;
         Piercing_Candle_Length=10;
         Engulfing_Length=40;
         Candle_WickBody_Percent=0.9;
         CandleLength=12;
         Pointer_Offset=9;
         High_Offset=35;
         Offset_Hammer=20;
         Offset_ShootStar=20;
         Offset_Doji = 20;
         Offset_Star = 20;
         Offset_Piercing_Line=20;
         Offset_DarkCC=20;
         Offset_Bearish_Engulfing = 20;
         Offset_Bullish_Engulfing = 20;
         Text_ShootStar=8;
         Text_Hammer=8;
         Text_Star=8;
         Text_DarkCC=8;
         Text_Piercing_Line=8;
         Text_Bearish_Engulfing = 8;
         Text_Bullish_Engulfing = 8;
         IncOffset=35;
         break;
      case PERIOD_MN1:
         period="MN";
         Doji_Star_Ratio=0;
         Piercing_Line_Ratio=0.5;
         Piercing_Candle_Length=10;
         Engulfing_Length=50;
         Candle_WickBody_Percent=0.9;
         CandleLength=12;
         Pointer_Offset=9;
         High_Offset=45;
         Offset_Hammer=30;
         Offset_ShootStar=30;
         Offset_Doji = 30;
         Offset_Star = 30;
         Offset_Piercing_Line=30;
         Offset_DarkCC=30;
         Offset_Bearish_Engulfing = 30;
         Offset_Bullish_Engulfing = 30;
         Text_ShootStar=8;
         Text_Hammer=8;
         Text_Star=8;
         Text_DarkCC=8;
         Text_Piercing_Line=8;
         Text_Bearish_Engulfing = 8;
         Text_Bullish_Engulfing = 8;
         IncOffset=45;
         break;
     }

   if(UseExtraDigit)
     {
      Piercing_Candle_Length*=10;
      Engulfing_Length*=10;
      Candle_WickBody_Percent*=10;
      CandleLength*=10;
      Pointer_Offset*=10;
      High_Offset*=10;
      Offset_Hammer*=10;
      Offset_ShootStar*=10;
      Offset_Doji *= 10;
      Offset_Star *= 10;
      Offset_Piercing_Line*=10;
      Offset_DarkCC=10;
      Offset_Bearish_Engulfing *= 10;
      Offset_Bullish_Engulfing *= 10;
      IncOffset*=10;
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Concatenates string and time for a name.	                        |
//+------------------------------------------------------------------+
string GetName(string aName,datetime timeshift)
  {
   return(aName + DoubleToString(timeshift, 0));
  }
  
//+------------------------------------------------------------------+
//| Returns hour and minute of event                                 |
//+------------------------------------------------------------------+  
string GetTime(datetime timeshift)
   {
   MqlDateTime stm;
   TimeToStruct(timeshift, stm);
   string eventTime;
   //--- output date components
   switch(_Period)
   {
   case PERIOD_M1:
   case PERIOD_M5:
   case PERIOD_M15:
   case PERIOD_M30:
   eventTime = "Hour: " + (string)stm.hour + "\n" + "Minute: " + (string)stm.min;
   break;
   case PERIOD_H1:
   case PERIOD_H4:
   eventTime = "Day: " +(string)stm.day + "\n" + "Hour: " + (string)stm.hour;
   break;
   case PERIOD_D1:
   eventTime = "Month: " + (string)stm.mon + "\n" +"Day: " + (string)stm.day;
   break;
   case PERIOD_W1:
   eventTime = "Year: " + (string)stm.year + "\n" + "Month: " + (string)stm.mon + "\n" +"Day: " + (string)stm.day;   
   break;
   case PERIOD_MN1:
   eventTime = "Year: " + (string)stm.year + "\n" + "Month: " + (string)stm.mon + "\n" +"Day: " + (string)stm.day;
   break;
   }
   
   return eventTime;
   }  
//+------------------------------------------------------------------+
//| Creates an object to mark the pattern on the chart.              |
//+------------------------------------------------------------------+
void MarkPattern(const string name,const datetime time,const double price,const string shortname,const int fontsize,const color patterncolor)
  {
   ObjectCreate(0,name,OBJ_TEXT,0,time,price);
   ObjectSetString(0,name,OBJPROP_TEXT,shortname);
   ObjectSetString(0,name,OBJPROP_FONT,"Times New Roman");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);
   ObjectSetInteger(0,name,OBJPROP_COLOR,patterncolor);
  }
//+------------------------------------------------------------------+  
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0,0,OBJ_TEXT);
   Comment("");
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &Time[],
                const double &Open[],
                const double &High[],
                const double &Low[],
                const double &Close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   ArraySetAsSeries(Time,true);
   ArraySetAsSeries(High,true);
   ArraySetAsSeries(Low,true);
   ArraySetAsSeries(Close,true);
   ArraySetAsSeries(Open,true);

   double Range,AvgRange;
   static datetime prevtime=0;
   int counter,setalert;
   int shift,shift1,shift2,shift3,shift4;
   string pattern;
   int setPattern=0;
   int alert=0;
   double Opening,Opening1,Opening2,Closing,Closing1,Closing2,Closing3,Lowest,Lowest1,Lowest2,Lowest3,Highest,Highest1,Highest2,Highest3;
   double CandleLow,CandleLow1,CandleLow2,BodyLow2,BodyLowABS,BLABS90,UpperShadow,LowerShadow,BodyHigh,BodyLow;
   BodyHigh= 0;
   BodyLow = 0;
   int CumOffset;

   if(prevtime==Time[0])
     {
      return(rates_total);
     }
   prevtime=Time[0];
   
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

   for(shift=0; shift<rates_total-9; shift++) //main loop
     {
      CumOffset= 0;
      setalert = 0;
      counter=shift;
      Range=0;
      AvgRange=0;

      for(counter = shift; counter <= shift + 9; counter++)
         AvgRange = AvgRange + MathAbs(High[counter] - Low[counter]);
      Range=AvgRange/10;

      shift1 = shift + 1;
      shift2 = shift + 2;
      shift3 = shift + 3;
      shift4 = shift + 4;

      Opening=Open[shift1];
      Opening1 = Open[shift2];
      Opening2 = Open[shift3];
      Highest=High[shift1];
      Highest1 = High[shift2];
      Highest2 = High[shift3];
      Highest3 = High[shift4];
      Lowest=Low[shift1];
      Lowest1 = Low[shift2];
      Lowest2 = Low[shift3];
      Lowest3 = Low[shift4];
      Closing=Close[shift1];
      Closing1 = Close[shift2];
      Closing2 = Close[shift3];
      Closing3 = Close[shift4];

      if(Opening>Closing)
        {
         BodyHigh= Opening;
         BodyLow = Closing;
        }
      else
        {
         BodyHigh= Closing;
         BodyLow = Opening;
        }

      CandleLow=High[shift1]-Low[shift1];
      CandleLow1 = High[shift2] - Low[shift2];
      CandleLow2 = High[shift3] - Low[shift3];
      BodyLow2 = Open[shift1] - Close[shift1];
      UpperShadow = High[shift1] - BodyHigh;
      LowerShadow = BodyLow - Low[shift1];
      BodyLowABS= MathAbs(BodyLow2);
      BLABS90=BodyLowABS*Candle_WickBody_Percent;
      
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

      // Bearish Patterns  
      // Check for Bearish Shooting ShootStar
      if((Highest>=Highest1) && (Highest>Highest2) && (Highest>Highest3))
        {
         if(((UpperShadow/2)>LowerShadow) && (UpperShadow>(2*BLABS90)) && (CandleLow>=(CandleLength*_Point)) && 
         (Opening!=Closing) && ((UpperShadow/3)<=LowerShadow) && ((UpperShadow/4)<=LowerShadow))
           {
            if(Display_ShootStar_2)
              {
               MarkPattern(GetName("Shooting_Star 2",Time[shift]),Time[shift1],High[shift1]+(Pointer_Offset+Offset_ShootStar+High_Offset+CumOffset)*_Point,"Shooting_Star 2",Text_ShootStar,Color_ShootStar);
               CumOffset=CumOffset+IncOffset;
               downArrow[shift1]=High[shift1]+(Pointer_Offset*_Point);
              }
            if(Show_ShootStar_Alert_2)
              {
               if((setalert==0) && (Show_Alert))
                 {
                  pattern="Shooting ShootStar 2";
                  setalert=1;
                  SendMail("Shooting ShootStar 2", "");
                  SendNotification("Shooting ShootStar 2 " + symbol + "\n" + GetTime(Time[shift]));
                 }
              }
           }
        }

      // Check for Bearish Shooting ShootStar
      if((Highest>=Highest1) && (Highest>Highest2) && (Highest>Highest3))
        {
         if(((UpperShadow/3)>LowerShadow) && (UpperShadow>(2*BLABS90)) && (CandleLow>=(CandleLength*_Point)) && (Opening!=Closing) && ((UpperShadow/4)<=LowerShadow))
           {
            if(Display_ShootStar_3)
              {
               MarkPattern(GetName("Shooting_Star 3",Time[shift]),Time[shift1],High[shift1]+(Pointer_Offset+Offset_ShootStar+High_Offset+CumOffset)*_Point,"Shooting_Star 3",Text_ShootStar,Color_ShootStar);
               CumOffset=CumOffset+IncOffset;
               downArrow[shift1]=High[shift1]+(Pointer_Offset*_Point);
              }
            if(Show_ShootStar_Alert_3)
              {
               if((setalert==0) && (Show_Alert))
                 {
                  pattern="Shooting ShootStar 3";
                  setalert=1;
                  SendMail("Shooting ShootStar 3", "");
                  SendNotification("Shooting ShootStar 3 " + symbol + "\n" + GetTime(Time[shift]));
                 }
              }
           }
        }

      // Check for Bearish Shooting ShootStar
      if((Highest>=Highest1) && (Highest>Highest2) && (Highest>Highest3))
        {
         if(((UpperShadow/4)>LowerShadow) && (UpperShadow>(2*BLABS90)) && (CandleLow>=(CandleLength*_Point)) && (Opening!=Closing))
           {
            if(Display_ShootStar_4)
              {
               MarkPattern(GetName("Shooting_Star 4",Time[shift]),Time[shift1],High[shift1]+(Pointer_Offset+Offset_ShootStar+High_Offset+CumOffset)*_Point,"Shooting_Star 4",Text_ShootStar,Color_ShootStar);
               CumOffset=CumOffset+IncOffset;
               downArrow[shift1]=High[shift1]+(Pointer_Offset*_Point);
              }
            if(Show_ShootStar_Alert_4)
              {
               if((setalert==0) && (Show_Alert))
                 {
                  pattern="Shooting ShootStar 4";
                  setalert=1;
                  SendMail("Shooting ShootStar 4", "");
                  SendNotification("Shooting ShootStar 4 " + symbol + "\n" + GetTime(Time[shift]));
                 }
              }
           }
        }

      // Check for Evening Star pattern
      if((Highest>=Highest1) && (Highest1>Highest2) && (Highest1>Highest3))
        {
         if((BodyLowABS<(Star_Body_Length*_Point)) && (Closing2>Opening2) && (!Opening==Closing) && ((Closing2-Opening2)/(Highest2-Lowest2)>Doji_Star_Ratio) && 
         (Closing1>Opening1) && (Opening>Closing) && (CandleLow>=(Star_MinLength*_Point)))
           {
            if(Display_Stars)
              {
               MarkPattern(GetName("Star",Time[shift]),Time[shift1],High[shift1]+(Pointer_Offset+Offset_Star+High_Offset+CumOffset)*_Point,"Evening_Star",Text_Star,Color_Star);
               CumOffset=CumOffset+IncOffset;
               downArrow[shift1]=High[shift1]+(Pointer_Offset*_Point);
              }
            if(Show_Stars_Alert)
              {
               if((setalert==0) && (Show_Alert))
                 {
                  pattern="Evening Star Pattern";
                  setalert=1;
                  SendMail("Evening Star Pattern", "");
                  SendNotification("Evening Star Pattern " + symbol + "\n" + GetTime(Time[shift]));
                 }
              }
           }
        }

      // Check for Evening Doji Star pattern
      if((Highest>=Highest1) && (Highest1>Highest2) && (Highest1>Highest3))
        {
         if((Opening==Closing) && ((Closing2>Opening2) && (Closing2-Opening2)/(Highest2-Lowest2)>Doji_Star_Ratio) && (Closing1>Opening1) && (CandleLow>=(Doji_MinLength*_Point)))
           {
            if(Display_Doji)
              {
               MarkPattern(GetName("Doji",Time[shift]),Time[shift1],High[shift1]+(Pointer_Offset+Offset_Doji+High_Offset+CumOffset)*_Point,"Evening_DojiS",Text_Doji,Color_Doji);
               CumOffset=CumOffset+IncOffset;
               downArrow[shift1]=High[shift1]+(Pointer_Offset*_Point);
              }
            if(Show_Doji_Alert)
              {
               if((setalert==0) && (Show_Alert))
                 {
                  pattern="Evening Doji Star Pattern";
                  setalert=1;
                  SendMail("Evening Doji Star Pattern", "");
                  SendNotification("Evening Doji Star Pattern " + symbol + "\n" + GetTime(Time[shift]));                  
                 }
              }
           }
        }

      // Check for Bearish Engulfing pattern
      if((Closing1>Opening1) && (Opening>Closing) && (Opening>=Closing1) && (Opening1>=Closing) && ((Opening-Closing)>(Closing1-Opening1)) && (CandleLow>=(Engulfing_Length*_Point)))
        {
         if(Display_Bearish_Engulfing)
           {
            MarkPattern(GetName("Bear_Engulfing",Time[shift]),Time[shift1],High[shift1]+(Pointer_Offset+Offset_Bearish_Engulfing+High_Offset+CumOffset)*_Point,"Bear_Engulfing",Text_Bearish_Engulfing,Color_Bearish_Engulfing);
            CumOffset=CumOffset+IncOffset;
            downArrow[shift1]=High[shift1]+(Pointer_Offset*_Point);
           }
         if(Show_Bearish_Engulfing_Alert)
           {
            if((setalert==0) && (Show_Alert))
              {
               pattern="Bearish Engulfing Pattern";
               setalert=1;
               SendMail("Bearish Engulfing Pattern", "");
               SendNotification("Bearish Engulfing Pattern " + symbol + "\n" + GetTime(Time[shift]));
              }
           }
        }
        
      // End of Bearish Patterns
      
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

      // Bullish Patterns
      // Check for Bullish Hammer   
      if((Lowest<=Lowest1) && (Lowest<Lowest2) && (Lowest<Lowest3))
        {
         if(((LowerShadow/2)>UpperShadow) && (LowerShadow>BLABS90) && (CandleLow>=(CandleLength*_Point)) && (Opening!=Closing) && ((LowerShadow/3)<=UpperShadow) && ((LowerShadow/4)<=UpperShadow))
           {
            if(Display_Hammer_2)
              {
               MarkPattern(GetName("Bull_Hammer 2",Time[shift]),Time[shift1],Low[shift1]-(Pointer_Offset+Offset_Hammer+CumOffset)*_Point,"Bull_Hammer 2",Text_Hammer,Color_Hammer);
               CumOffset=CumOffset+IncOffset;
               upArrow[shift1]=Low[shift1]-(Pointer_Offset*_Point);
              }
            if(Show_Hammer_Alert_2)
              {
               if((setalert==0) && (Show_Alert))
                 {
                  pattern="Bullish Hammer 2";
                  setalert=1;
                  SendMail("Bullish Hammer 2", "");
                  SendNotification("Bullish Hammer 2 " + symbol + "\n" + GetTime(Time[shift]));
                 }
              }
           }
        }

      // Check for Bullish Hammer   
      if((Lowest<=Lowest1) && (Lowest<Lowest2) && (Lowest<Lowest3))
        {
         if(((LowerShadow/3)>UpperShadow) && (LowerShadow>BLABS90) && (CandleLow>=(CandleLength*_Point)) && (Opening!=Closing) && ((LowerShadow/4)<=UpperShadow))
           {
            if(Display_Hammer_3)
              {
               MarkPattern(GetName("Bull_Hammer 3",Time[shift]),Time[shift1],Low[shift1]-(Pointer_Offset+Offset_Hammer+CumOffset)*_Point,"Bull_Hammer 3",Text_Hammer,Color_Hammer);
               CumOffset=CumOffset+IncOffset;
               upArrow[shift1]=Low[shift1]-(Pointer_Offset*_Point);
              }
            if(Show_Hammer_Alert_3)
              {
               if((setalert==0) && (Show_Alert))
                 {
                  pattern="Bullish Hammer 3";
                  setalert=1;
                  SendMail("Bullish Hammer 3", "");
                  SendNotification("Bullish Hammer 3 " + symbol + "\n" + GetTime(Time[shift]));
                 }
              }
           }
        }

      // Check for Bullish Hammer   
      if((Lowest<=Lowest1) && (Lowest<Lowest2) && (Lowest<Lowest3))
        {
         if(((LowerShadow/4)>UpperShadow) && (LowerShadow>BLABS90) && (CandleLow>=(CandleLength*_Point)) && (Opening!=Closing))
           {
            if(Display_Hammer_4)
              {
               MarkPattern(GetName("Bull_Hammer 4",Time[shift]),Time[shift1],Low[shift1]-(Pointer_Offset+Offset_Hammer+CumOffset)*_Point,"Bull_Hammer 4",Text_Hammer,Color_Hammer);
               CumOffset=CumOffset+IncOffset;
               upArrow[shift1]=Low[shift1]-(Pointer_Offset*_Point);
              }
            if(Show_Hammer_Alert_4)
              {
               if((setalert==0) && (Show_Alert))
                 {
                  pattern="Bullish Hammer 4";
                  setalert=1;
                  SendMail("Bullish Hammer 4", "");
                  SendNotification("Bullish Hammer 4 " + symbol + "\n" + GetTime(Time[shift]));
                 }
              }
           }
        }

      // Check for Morning Star
      if((Lowest<=Lowest1) && (Lowest1<Lowest2) && (Lowest1<Lowest3))
        {
         if((BodyLowABS<(Star_Body_Length*_Point)) && (!Opening==Closing) && ((Opening2>Closing2) && ((Opening2-Closing2)/(Highest2-Lowest2)>Doji_Star_Ratio)) && 
         (Opening1>Closing1) && (Closing>Opening) && (CandleLow>=(Star_MinLength*_Point)))
           {
            if(Display_Stars)
              {
               MarkPattern(GetName("Star",Time[shift]),Time[shift1],Low[shift1]-(Pointer_Offset+Offset_Star+CumOffset)*_Point,"Star",Text_Star,Color_Hammer);
               CumOffset=CumOffset+IncOffset;
               upArrow[shift1]=Low[shift1]-(Pointer_Offset*_Point);
              }
            if(Show_Stars_Alert)
              {
               if((setalert==0) && (Show_Alert))
                 {
                  pattern="Morning Star Pattern";
                  setalert=1;
                  SendMail("Morning Star Pattern", "");
                  SendNotification("Morning Star Pattern " + symbol + "\n" + GetTime(Time[shift]));
                 }
              }
           }
        }

      // Check for Morning Doji Star
      if((Lowest<=Lowest1) && (Lowest1<Lowest2) && (Lowest1<Lowest3))
        {
         if((Opening==Closing) && ((Opening2>Closing2) && ((Opening2-Closing2)/(Highest2-Lowest2)>Doji_Star_Ratio)) && (Opening1>Closing1) && (CandleLow>=(Doji_MinLength*_Point)))
           {
            if(Display_Doji)
              {
               MarkPattern(GetName("Doji",Time[shift]),Time[shift1],Low[shift1]-(Pointer_Offset+Offset_Doji+CumOffset)*_Point,"Doji",Text_Doji,Color_Doji);
               CumOffset=CumOffset+IncOffset;
               upArrow[shift1]=Low[shift1]-(Pointer_Offset*_Point);
              }
            if(Show_Doji_Alert)
              {
               if((shift==0) && (Show_Alert))
                 {
                  pattern="Morning Doji Pattern";
                  setalert=1;
                  SendMail("Morning Doji Pattern", "");
                  SendNotification("Morning Doji Pattern " + symbol + "\n" + GetTime(Time[shift]));
                 }
              }
           }
        }

      // Check for Piercing Line pattern
      if((Closing1<Opening1) && (((Opening1+Closing1)/2)<Closing) && (Opening<Closing) && ((Closing-Opening)/((Highest-Lowest))>Piercing_Line_Ratio) && (CandleLow>=(Piercing_Candle_Length*_Point)))
        {
         if(Display_Piercing_Line)
           {
            MarkPattern(GetName("Piercing_Line",Time[shift]),Time[shift1],Low[shift1]-(Pointer_Offset+Offset_Piercing_Line+CumOffset)*_Point,"Piercing_Line",Text_Piercing_Line,Color_Piercing_Line);
            CumOffset=CumOffset+IncOffset;
            upArrow[shift1]=Low[shift1]-(Pointer_Offset*_Point);
           }
         if(Show_Piercing_Line_Alert)
           {
            if((shift==0) && (Show_Alert))
              {
               pattern="Piercing Line Pattern";
               setalert=1;
               SendMail("Piercing Line Pattern", "");
               SendNotification("Piercing Line Pattern " + symbol + "\n" + GetTime(Time[shift]));                               
              }
           }
        }

      // Check for Bullish Engulfing pattern
      if((Opening1>Closing1) && (Closing>Opening) && (Closing>=Opening1) && (Closing1>=Opening) && ((Closing-Opening)>(Opening1-Closing1)) && (CandleLow>=(Engulfing_Length*_Point)))
        {
         if(Display_Bullish_Engulfing)
           {
            MarkPattern(GetName("Bull_Engulfing",Time[shift]),Time[shift1],Low[shift1]-(Pointer_Offset+Offset_Bullish_Engulfing+CumOffset)*_Point,"Bull_Engulfing",Text_Bullish_Engulfing,Color_Bullish_Engulfing);
            CumOffset=CumOffset+IncOffset;
            upArrow[shift1]=Low[shift1]-(Pointer_Offset*_Point);
           }
         if(Show_Bullish_Engulfing_Alert)
           {
            if((shift==0) && (Show_Alert))
              {
               pattern="Bullish Engulfing Pattern";
               setalert=1;
               SendMail("Bullish Engulfing Pattern", "");
               SendNotification("Bullish Engulfing Pattern " + symbol + "\n" + GetTime(Time[shift]));                  
              }
           }
        }
      // End of Bullish Patterns 
                     
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

      if((setalert==1) && (shift==0))
        {
         Alert(Symbol(),"\n",period,"\n",pattern);
         setalert=0;
        }
      CumOffset=0;
     } // End of for loop

   return(rates_total);
  }

