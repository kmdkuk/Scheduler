class button
{
  float x, y, w, h;
  float size;
  String text;
  boolean exist = false;
  color mycolor = color(0);
  color onmouse = color(0,255,0);
  button(String s, float si, float a, float b, float c, float d)//ボタンの文字,x座標,y座標,幅,高さ
  {
    text = s;
    size = si;
    x = a;
    y = b;
    w = c;
    h = d;
  }
  button(String s, float si, float a, float b, float c, float d,color my)
  {
    text = s;
    size = si;
    x = a;
    y = b;
    w = c;
    h = d;
    mycolor = my;
  }
   button(String s, float si, float a, float b, float c, float d,color my,color on)
  {
    text = s;
    size = si;
    x = a;
    y = b;
    w = c;
    h = d;
    mycolor = my;
    onmouse = on;
  }
  void update()
  {
    exist = true;
    if (Isonbutton())
    {
      fill(onmouse);
    } else
    {
      fill(255, 255, 255, 200);
    }
    stroke(0);
    rect(x, y, w, h);
    textAlign(CENTER);
    textSize(size);
    fill(mycolor);
    text(text, x+w/2, y+h/2+size/2);
    textAlign(LEFT);
  }

  boolean Isonbutton()
  {
    if (exist)
    {
      if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y + h)
      {
        return true;
      }
    }
    return false;
  }
}
