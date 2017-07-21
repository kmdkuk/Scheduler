int status = 0;//全部で4つ
Boolean open = true;
int opencount = 0;
int nextstatus = 0;
int swipe1 = 0;
int v = 0;
float px;
float dx, dy;
Boolean click = false;
int pagex = 480, pagey = 180;
float movex = 0, movey = 0;
//カレンダー
button nmonth = new button("next", 15, 300-pagex*status-movex, pagey + 350, 100, 25);
button pmonth = new button("previous", 15, 150-pagex*status-movex, pagey + 350, 100, 25);
button home = new button("HOME", 10, 275+pagex*status-movex, pagey+350, 30, 25);
button sleepstudy = new button ("SLEEP", 20, 275+pagex*status-movex, pagey+175, 200, 50);
button up = new button("↑", 20, 275+pagex*status-movex, pagey+250, 100, 50);
button down = new button("↓", 20, 275+pagex*status-movex, pagey+250, 100, 50);
int sleep[][];
int study[][];
int sl;
int st;
int showyear = year();
int showmonth = month();
int showday;
button day[] = new button[31];
int schedulepage = 0;
String timetable[][] = {
  {
    " ", " ", " ", " ", " "
  }
  , 
  {
    "線形代数学", "数学総合演習", " ", " ", " "
  }
  , 
  {
    "解析学", "情報機器概論", "コミュニケーション", " ", " "
  }
  , 
  {
    "科学技術リテラシ", " ", "余暇と健康", "ロボットの科学技術", "認知科学"
  }
  , 
  {
    " ", "コミュニケーション", "物理学入門", " ", " "
  }
  , 
  {
    "情報表現入門", "情報表現入門", "情報表現入門", " ", "人体生理学"
  }
  , 
  {
    " ", " ", " ", " ", " "
  }
  ,
};
//タイマー
int time[] = {
  00, 00
};
int count = 0;
button ss = new button("start/stop", 20, 5-pagex*(1-status)-movex, 260 + pagey, 110, 55);
button reset = new button("reset", 20, 55-pagex*(1-status)-movex, 260+ pagey, 110, 55);
button minute10 = new button("10m", 20, 5-pagex*(1-status)-movex, 325+ pagey, 73, 55);
button minute = new button("m", 20, 103-pagex*(1-status)-movex, 325+ pagey, 73, 55);
button second10 = new button("10s", 20, 186-pagex*(1-status)-movex, 325+ pagey, 73, 55);
Boolean start = false;
//バスアラーム
PFont font;
String fun_data[];
String isikai_data[];
int fun_bus[][];
int isikai_bus[][];
int departure = 0;//1:hakodate2:isikai
int nextbus = 0;
button busswitch = new button("医師会病院/はこだて未来大学", 20, 20+pagex*(1-status)-movex, 300+pagey, 440, 50);
button web = new button ("接近情報はこちら", 13, 140 +pagex*(1-status)-movex, 360+pagey, 200, 25);

void setup()
{
  font = createFont("MS Gothic", 10);
  size(480, 640);
  frameRate(60);
  //status = 1;//debug
  fun_data = loadStrings("bus/fun.txt");
  isikai_data = loadStrings("bus/isikai.txt");
  fun_bus = new int[fun_data.length][2];
  isikai_bus = new int[isikai_data.length][2];
  for (int i = 0; i<fun_data.length; i++)
  {
    fun_bus[i] = int(fun_data[i].split(","));
  }
  for (int i = 0; i<isikai_data.length; i++)
  {
    isikai_bus[i] = int(isikai_data[i].split(","));
  }
  for (int i = 0; i<31; i++)
  {
    day[i] = new button("", 20, 1, 1, 1, 1);
  }
  String data[] = loadStrings("sleep.txt");
  sleep = new int[data.length+100][4];
  for (int i = 0; i<data.length; i++)
  {
    sleep[i] = int(data[i].split(","));
  }
  data = loadStrings("study.txt");
  study = new int[data.length+100][4];
  for (int i = 0; i<data.length; i++)
  {
    study[i] = int(data[i].split(","));
  }
}
void mousePressed()
{
  if (!(pmonth.Isonbutton()||nmonth.Isonbutton()||ss.Isonbutton()||reset.Isonbutton()||minute10.Isonbutton()||minute.Isonbutton()||second10.Isonbutton()||busswitch.Isonbutton()))
  {
    px = mouseX;
    dx = mouseX;
    dy = mouseY;
    click = true;
  }
}
void mouseReleased()
{
  //クリックした時のmousex(px)と現在のpxを比べる
  swipe1 = 0;
  if (click)
  {
    if ( px+100 < mouseX)
    {
      v = 2;//右に移動
      swipe1 = 2;
    } else if (px-100 > mouseX)
    {
      v =  1;//左に移動
      swipe1 = 1;
    } else
    {
      v =  0;
      swipe1 = -1;
    }
  }
  click = false;
}
void mouseClicked()
{
  if (pmonth.Isonbutton())
  {
    if (schedulepage == 0)
    {
      if (showmonth != 1)
      {
        showmonth--;
      } else
      {
        showmonth = 12;
        showyear--;
      }
    } else
    {
      if (showday != 1)
      {
        showday--;
      } else
      {
        if (showmonth == 1)
        {
          showmonth = 12;
          showyear--;
        } else
        {
          showmonth--;
        }
        showday = daysOfMonth[showmonth-1];
      }
    }
  }
  if (nmonth.Isonbutton())
  {
    if (schedulepage == 0)
    {
      if (showmonth != 12)
      {
        showmonth++;
      } else
      {
        showmonth = 1;
        showyear ++;
      }
    } else
    {
      if (showday != daysOfMonth[showmonth-1])
      {
        showday++;
      } else
      {
        if (showmonth == 12)
        {
          showmonth = 1;
          showyear++;
        } else
        {
          showmonth++;
        }
        showday = 1;
      }
    }
  }
  if (home.Isonbutton())
  {
    showmonth = month();
    showyear = year();
    schedulepage = 0;
  }
  if (ss.Isonbutton())
  {
    if (start)
    {
      start = false;
    } else
    {
      start =true;
    }
  }
  if (reset.Isonbutton())
  {
    time[0] = 0;
    time[1] = 0;
  }
  if (!(start))
  {
    if (minute10.Isonbutton())
    {
      time[0] += 10;
    }
    if (minute.Isonbutton())
    {
      time[0] ++;
    }
    if (second10.Isonbutton())
    {
      time[1] += 10;
      if (time[1] >= 60)
      {
        time[0]++;
        time[1] -= 60;
      }
    }
    if (time[0] >= 100)
    {
      time[0] = 99;
      time[1] = 59;
    }
  }
  if (busswitch.Isonbutton())
  {
    departure = (departure + 1)%2;
  }
  if (web.Isonbutton())
  {
    link("http://hakobus.jp/m/index.php");
  }
  for (int i = 0; i<day.length; i++)
  {
    if (day[i].Isonbutton())
    {
      schedulepage = 1;
      showday = i+1;
    }
  }
  if (sleepstudy.Isonbutton())
  {
    if (sleepstudy.text.equals("SLEEP"))
    {
      sleepstudy.text = "STUDY";
    } else
    {
      sleepstudy.text = "SLEEP";
    }
  }
  if (up.Isonbutton())
  {
    if (sleepstudy.text.equals("SLEEP"))
    {
      sl++;
    } else
    {
      st++;
    }
  }
  if (down.Isonbutton())
  {
    if (sleepstudy.text.equals("SLEEP"))
    {
      sl--;
    } else
    {
      st--;
    }
  }
}
void swipemove(int c)
{
  switch(c)
  {
  case 0 : 
    return; 
  case 1 : //right
    if (status != 3)
    {
      nextstatus += 1;
    }
    break; 
  case 2 : //left
    if (status != 0)
    {
      nextstatus = (status+2)%3;
    }
    break;
  }
  v = 0;
}

void draw()
{ 
  textFont(font); 
  background(0); 
  clock(width/2-523/2*0.5, height/3-150, 0.5); 
  swipemove(v); 
  movepage(click);
  swipedraw(); 
  drawpage();
  //grid(10);
  //stroke(255);
  //line(width/2,0,width/2,height);
  opencount++;
  fill(0, 0, 0, 255*2-opencount*3);
  rect(0, 0, width, height);
  fill(255, 255, 255, 255-opencount*2);
  textAlign(CENTER);
  textSize(60);
  text("Scheduler", width/2, height/2);
  textAlign(LEFT);
}

void drawpage()
{
  strokeWeight(4); 
  for (int i = 0; i<3; i++)
  {
    fill(0); 
    if (status == i)fill(255); 
    ellipse(width/6*(i+2), 600, 15, 15);
  }
  strokeWeight(1); 
  fill(255); 
  //y座標に+pagey
  //0ページ目 x座標に「-pagex*status-movex」
  rect(10-pagex*status-movex, 10+pagey, 460, 380); 
  textSize(20); 
  if (schedulepage == 0)
  {
    drawCalender(showyear, showmonth, day());
  } else
  {
    drawschedule(showyear, showmonth, showday);
  }
  nmonth.x = 265-pagex*status-movex; 
  pmonth.x = 115-pagex*status-movex; 
  home.x = 225+pagex*status-movex;
  home.update();
  nmonth.update(); 
  pmonth.update(); 
  fill(255); 
  //1ページ目 x座標に「+pagex*(1-status)-movex」
  rect(10+pagex*(1-status)-movex, 10+pagey, 460, 380); 
  showbustime(); 
  stroke(0); 
  busswitch.x = 20+pagex*(1-status)-movex; 
  web.x = 140 +pagex*(1-status)-movex;
  //2ページ目 x座標に「-pagex*(2-status)-movex」
  stroke(255); 
  rect(10+pagex*(2-status)-movex, 10+pagey, 460, 380); 
  count++; 
  if (start)
  {
    if (count % 60 == 0)
    {
      time = timeupdate(time); 
      count = 0;
    }
    timer(70+pagex*(2-status)-movex, 50+pagey, time[0], time[1], 1, ((255/60)*count)%255);
  } else
  {
    timer(70+pagex*(2-status)-movex, 50+pagey, time[0], time[1], 1, 255);
  }
  if (time[0] == 0 && time[1] == 0)
  {
    textSize(30); 
    fill(255, 0, 0, ((255/60)*count)%255); 
    text("TimeUp", 310+pagex*(2-status)-movex, 230+pagey); 
    start = false;
  }
  ss.x = 120+pagex*(2-status)-movex; 
  reset.x = 250+pagex*(2-status)-movex; 
  minute10.x = 120+pagex*(2-status)-movex; 
  minute.x = 203+pagex*(2-status)-movex; 
  second10.x = 286+pagex*(2-status)-movex; 

  //3ページ目 x座標に「+pagex*(3-status)-movex」
  /*fill(255); 
   rect(10+pagex*(3-status)-movex, 10+pagey, 460, 380); */
  buttonupdate();
}

void movepage(boolean flag)
{
  if (flag)
  {
    movex = dx - mouseX;
  } /*else {
   movex = 0;
   }*/
}




void grid(int interbal)
{
  stroke(0); 
  for (int i = 0; i<height; i+=interbal)
  {
    if (i%100 ==0)
    {
      strokeWeight(5);
    } else
    {
      strokeWeight(1);
    }
    line(0, i, width, i);
  }
  for (int i = 0; i<width; i+=interbal)
  {
    if (i%100 ==0)
    {
      strokeWeight(5);
    } else
    {
      strokeWeight(1);
    }
    line(i, 0, i, height);
  }
}

//カレンダーに関する
// 一ヶ月の日数
final int daysOfMonth[]= {
  31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
};
final String weekday[] = {
  "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"
};

// ツェラーの公式による曜日の算出
// 日曜=0 ... 土曜=6
int zeller(int y, int m, int d) {
  int h; 
  if (m<3) {
    m+=12; 
    y--;
  }
  h=(d+(m+1)*26/10+(y%100)+(y%100)/4+y/400-2*y/100)%7; 
  h-=1; 
  if (h<0) h+=7; 
  return h;
}

// うるう年の判別
boolean isLeapYear(int y) {
  if (y%400==0) {
    return true;
  } else if (y%100==0) {
    return false;
  } else if (y%4==0) {
    return true;
  }
  return false;
}

// うるう年を考慮して「今月」の日数を求める
int getDaysOfMonth( int y, int m) {
  int days=daysOfMonth[m-1]; 
  if (m==2 && isLeapYear(y)) {
    days++;
  }
  return days;
}
// 「今月」のカレンダーを描画する
void drawCalender(int y, int m, int d) {
  sleepstudy.exist = false;
  up.exist = false;
  down.exist = false;
  int week=zeller(y, m, 1); // 「今月」1日の曜日を求める
  int days=getDaysOfMonth(y, m); // 「今月」の日数を求める
  int row = (days+week-1)/7+2; 
  fill(0, 0, 0); // 年/月を緑で表示
  textAlign(LEFT); 
  text(y+"/"+m, 30-pagex*status-movex, (400-120)/6+pagey); 
  textAlign(CENTER); 
  for (int i = 0; i< 7; i++)
  {
    if (i==0) { // 日曜は赤字
      fill(255, 0, 0);
    } else
    {
      fill(0);
    }
    text(weekday[i], i*((480-45)/7)+55+pagex*status-movex, 2*((400-120)/row)+pagey);
  }
  for (int i=1; i<=days; i++) {
    if (i==d && m == month()) {// 「今日」なら青字
      day[i-1].mycolor = color(0, 0, 255);
    } else {// 「今日」でないなら黒字
      day[i-1].mycolor = color(0, 0, 0); 
      if ((i+week-1)%7==0) { // 日曜は赤字
        day[i-1].mycolor = color(255, 0, 0);
      }
    }
    String dd=(""+i); 
    if (i > 0 && i < 10)
    {
      dd = ("0"+i);
    }
    //dd=dd.substring(dd.length()-2);//文字列を右寄せっぽくする
    day[i-1].text = dd; 
    day[i-1].x = (i+week-1)%7*((480-50)/7)+30+pagex*status-movex; 
    day[i-1].y = ((i+week-1)/7+2)*((400-120)/row)+pagey+10; 
    day[i-1].w = (480-50)/7; 
    day[i-1].h = (400-120)/row; 
    day[i-1].update(); 
    //text(dd, (i+week-1)%7*((480-40)/7)+60-pagex*status-movex, ((i+week-1)/7+3)*((400-120)/row)+pagey);
  }
  for (int i = 0; i<8; i++)//縦線
  {
    stroke(0); 
    line(i*((480-50)/7)+30-pagex*status-movex, ((400-120)/row)+pagey+10, i*((480-50)/7)+30-pagex*status-movex, ((days+week-1)/7+3)*((400-120)/row)+pagey+10);
  }
  for (int i = 0; i< row+1; i++)
  {
    line(30-pagex*status-movex, (i+1)*((400-120)/row)+pagey+10, 7*((480-50)/7)+30-pagex*status-movex, (i+1)*((400-120)/row)+pagey+10);
  }
}
Boolean read = false;
void drawschedule(int y, int m, int d)
{
  Boolean sldataexist = false;
  Boolean stdataexist = false;
  for (int i = 0; i<31; i++)
  {
    day[i].exist = false;
  }
  fill(0);
  text(y+"/"+m+"/"+d+"("+weekday[zeller(y, m, d)]+")", 35+pagex*status-movex, 35+pagey);
  int count = 0;
  textFont(font, 20);
  for (int i = 0; i<5; i++)
  {
    if (timetable[zeller(y, m, d)][i].equals(" ") == false)
    {
      //text((i+1)+"限  "+timetable[zeller(y, m, d)][i], 50+pagex*status-movex, 100+count*30+pagey);
      text((i+1)+"限  "+timetable[zeller(y, m, d)][i], 250+pagex*status-movex, 35+count*30+pagey);
      count++;
    }
  }
  if (!(read))
  {
    for (int i = 0; i<study.length; i++)
    {
      if (study[i][0] == y &&  study[i][1] == m && study[i][2] == d)
      {
        st = i;
        stdataexist = true;
      }
    }
    for (int i = 0; i<sleep.length; i++)
    {
      if (sleep[i][0] == y &&  sleep[i][1] == m && sleep[i][2] == d)
      {
        sl = i;
        sldataexist = true;
      }
    }
    if (sldataexist == false)
    {
      for (int i = 0; i<sleep.length; i++)
      {
        if (sleep[i][0] == 0)
        {
          sl = i;
          sleep[i][0] = y;
          sleep[i][1] = m;
          sleep[i][2] = d;
          sleep[i][3] = 0;
        }
      }
    }
    if (stdataexist == false)
    {
      for (int i = 0; i<sleep.length; i++)
      {
        if (study[i][0] == 0)
        {
          st = i;
          study[i][0] = y;
          study[i][1] = m;
          study[i][2] = d;
          study[i][3] = 0;
        }
      }
    }
    read = true;
  }
  sleepstudy.x = 250 +pagex*status-movex;
  up.x = 250+pagex*status-movex;
  down.x = 350+pagex*status-movex;
  sleepstudy.update();
  up.update();
  down.update();
  noFill();
  stroke(0);
  textSize(20);
  text("睡眠時間:"+sl, 20+pagex*status-movex, 70+pagey );
  text("勉強時間:"+st, 20+pagex*status-movex, 100+pagey );
  rect(240+pagex*status-movex, 9+pagey, 240, count*30);
  rect(240 +pagex*status-movex, pagey, 240, 340);
}



//時計に関する関数
//w=400+43+80=523
void clock(float x, float y, float scl)
{
  fill(0, 255, 0); 
  stroke(0, 255, 0); 
  int h10 = hour()/10; 
  int h = hour() % 10; 
  int m10 = minute()/10; 
  int m = minute()%10; 
  int s10 = second() /10; 
  int s = second() % 10; 
  drawnum(x, y, h10, scl); 
  drawnum(x+80*scl+3*scl, y, h, scl); 
  ellipse(x+160*scl+15*scl, y+45*scl, 8*scl, 8*scl); 
  ellipse(x+160*scl+15*scl, y+100*scl, 8*scl, 8*scl); 
  drawnum(x+160*scl+20*scl, y, m10, scl); 
  drawnum(x+240*scl+23*scl, y, m, scl); 
  ellipse(x+320*scl+35*scl, y+45*scl, 8*scl, 8*scl); 
  ellipse(x+320*scl+35*scl, y+100*scl, 8*scl, 8*scl); 
  drawnum(x+320*scl+40*scl, y, s10, scl); 
  drawnum(x+400*scl+43*scl, y, s, scl); 
  stroke(255);
}
//scl = 1の時
//幅約80高さ約150
void drawnum(float x, float y, int num, float scl)//x座標,y座標,出力する数字,文字の大きさ
{
  if (num>9)//10以上の時は1の位を取り出す
  {
    num=num%10;
  }
  //数字表示処理
  for (int i = 0; i<3; i++)//1,4,7
  {
    switch(i)
    {
    case 0 : 
      if (num==1||num==4)continue; 
      break; 
    case 1 : 
      if (num==0||num==1||num==7)continue; 
      break; 
    case 2 : 
      if (num==1||num==4||num==7)continue; 
      break;
    }
    triangle(x + 11*scl, y+(8+66*i)*scl, x+16*scl, y+(3+66*i)*scl, x+16*scl, y+(13+66*i)*scl); 
    rect(x+16*scl, y+(2+66*i)*scl, 50*scl, 12*scl); 
    triangle(x+66*scl, y+(3+66*i)*scl, x+71*scl, y+(8+66*i)*scl, x+66*scl, y+(13+66*i)*scl);
  }
  for (int i = 0; i<2; i++)//2,3,5,6
  {
    for (int j = 0; j<2; j++)
    {
      if (j==0)
      {
        if (i==0&&(num==1||num==2||num==3||num==7))continue; //2
        if (i==1&&(num==5||num==6))continue; //3
      } else
      {
        if (i==0&&(num==1||num==3||num==4||num==5||num==7||num==9))continue; //5
        if (i==1&&num==2)continue; //6
      }
      triangle(x+(8+66*i)*scl, y+(11+66*j)*scl, x+(3+66*i)*scl, y+(16+66*j)*scl, x+(13+66*i)*scl, y+(16+66*j)*scl); 
      rect(x+(2+66*i)*scl, y+(16+66*j)*scl, 12*scl, 50*scl); 
      triangle(x+(3+66*i)*scl, y+(66+66*j)*scl, x+(13+66*i)*scl, y+(66+66*j)*scl, x+(8+66*i)*scl, y+(71+66*j)*scl);
    }
  }
}

void timer(float x, float y, int m, int s, float scl, int flash)
{
  fill(0, 255, 0, flash); 
  stroke(0, 255, 0, flash); 
  int m2 = m/10; 
  int m1 = m%10; 
  int s2 = s /10; 
  int s1 = s % 10; 
  drawnum(x, y, m2, scl); 
  drawnum(x+80*scl+3*scl, y, m1, scl); 
  ellipse(x+160*scl+15*scl, y+45*scl, 8*scl, 8*scl); 
  ellipse(x+160*scl+15*scl, y+100*scl, 8*scl, 8*scl); 
  drawnum(x+160*scl+20*scl, y, s2, scl); 
  drawnum(x+240*scl+23*scl, y, s1, scl); 
  stroke(255);
}
int[] timeupdate(int[] time)
{
  if (time[1] == 0)//secondが0のとき
  {
    if (time[0] == 0)
    {
      time[0] = 0; 
      time[1] = 0;
    } else
    {
      time[0]--; 
      time[1] = 59;
    }
  } else
  {
    time[1]--;
  }
  return time;
}

void buttonupdate()
{
  ss.update(); 
  reset.update(); 
  minute10.update(); 
  minute.update(); 
  second10.update(); 
  busswitch.update();
  web.update();
}

int checkbustime(int[][] bustime)
{
  int today = zeller(year(), month(), day()); 
  if (today == 0 || today == 6)
  {
    return-2; //土日
  }
  for (int i = 0; i< bustime.length; i++)
  {
    if (bustime[i][0] *100 + bustime[i][1] > hour()*100+minute())
    {
      return i;
    }
  }

  return -1; //本日のバスはありません
}

void showbustime()
{
  String d; 
  int bustime[][]; 
  if (departure == 0)
  {
    d = "はこだて未来大学前"; 
    bustime = fun_bus;
  } else
  {
    d = "医師会病院前"; 
    bustime = isikai_bus;
  }
  fill(0); 
  nextbus = checkbustime(bustime); 
  switch(nextbus)
  {
  case -1 : 
    text("「"+d+"」 本日のバスはありません", 20+pagex*(1-status)-movex, 30+pagey); 
    break; 
  case -2 : 
    text("土日は家で寝てましょう", 20+pagex*(1-status)-movex, 30+pagey); 
    break; 
  default : 
    int dhour = ((bustime[nextbus][0]*60+bustime[nextbus][1])-(hour()*60+minute()))/60;
    int dminute = (bustime[nextbus][0]*60+bustime[nextbus][1])-(hour()*60+minute())-60*dhour;
    text("次に「"+d+"」へ来るバスは", 40+pagex*(1-status)-movex, 30+pagey); 
    text(bustime[nextbus][0]+":"+bustime[nextbus][1]+"("+dhour+"時間"+dminute+"分後)の便です。", 240+pagex*(1-status)-movex, 50+pagey);
    break;
  }
  text("バス時刻表", 20+pagex*(1-status)-movex, 70+pagey); 
  for (int i = 0; i<bustime.length; i++)
  {
    if (nextbus == i)
    {
      fill(0, 0, 255);
    } else
    {
      fill(255);
    }
    rect(100+(i/10)*150+pagex*(1-status)-movex, 55+24*(i%10)+pagey, 150, 24); 
    textAlign(CENTER); 
    fill(0); 
    int a = bustime[i][0]/10; 
    int b = bustime[i][0]%10; 
    int c = bustime[i][1]/10; 
    int e = bustime[i][1]%10; 
    text(str(a)+str(b)+":"+str(c)+str(e), 100+(i/10)*150+pagex*(1-status)-movex+75, 50+24*(i%10+1)+pagey); 
    //line(100+pagex*(1-status)-movex,25+30*(i+1)+pagey,300+pagex*(1-status)-movex,25+30*(i+1)+pagey);
  }
}
void swipedraw()
{
  switch(swipe1)
  {
  case 2://右
    if (status != 0)
    {
      movex -= 10;
      if (movex <= -width)
      {
        swipe1 = 0;
        status = nextstatus;
        movex = 0;
      }
    } else
    {
      swipe1 = 3;
    }
    break;
  case 3:
    movex += 20;
    if (movex >=0)
    {
      swipe1 = 0;
      movex = 0;
    }
    break;
  case 1://左
    if (status != 2)
    {
      movex += 10;
      if (movex >= width)
      {
        swipe1 = 0;
        status = nextstatus;
        movex = 0;
      }
    } else
    {
      swipe1 = 4;
    }
    break;
  case 4:
    movex -= 20;
    if (movex <=0)
    {
      swipe1 = 0;
      movex = 0;
    }
    break;
  case -1:
    if (movex > 0)
    {
      movex -= 20;
      if (movex <=0)
      {
        swipe1 = 0;
        movex = 0;
      }
    } else
    {
      movex += 20;
      if (movex >=0)
      {
        swipe1 = 0;
        movex = 0;
      }
      break;
    }
  }
}
void removescheduler()
{
  read = false;
  saveStrings("sleep.txt", str(sleep[1]));
}