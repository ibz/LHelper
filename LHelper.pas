program latina;

uses crt;

type
 tdesinenta =string[3];
 tcaz       =(n_s,v_s,g_s,d_s,ac_s,ab_s,n_p,v_p,g_p,d_p,ac_p,ab_p);
 tterminatie=array[tcaz] of record
                             voc_t:char;
                             des_c:tdesinenta;
                            end;
 tradical   =string[10];
 tcitit     =record
              n_sg:string[15];
              g_sg:string[15];
             end;
 tsubst     =object
              private declinare   :0..5;
                      neutru      :boolean;
                      impari      :boolean;
                      radical1    :tradical;
                      radical2    :tradical;
                      terminatie  :tterminatie;
              public  constructor init(c:tcitit);
                      function    v_t(c:tcaz):char;
                      function    d_c(c:tcaz):tdesinenta;
                      function    rad1:tradical;
                      function    rad2:tradical;
             end;

procedure cs_on; assembler;
asm
 push bp
 mov  ah,$0f
 int  $10
 mov  ah,$02
 mov  dx,windmin
 int  $10
 pop  bp
end;

procedure cs_off; assembler;
asm
 push bp
 mov  ah,$0f
 int  $10
 mov  ah,$02
 mov  dx,$1900
 int  $10
 pop  bp
end;

constructor tsubst.init(c:tcitit);
var
 ch:char;
 i :byte;
 cz:tcaz;
begin
 with c do
 begin
  for i:=1 to length(n_sg) do
   if n_sg[i] in ['A'..'Z'] then
    n_sg[i]:=chr(ord(n_sg[i])+32);
  for i:=1 to length(g_sg) do
   if g_sg[i] in ['A'..'Z'] then
    g_sg[i]:=chr(ord(g_sg[i])+32);
  if (copy(n_sg,length(n_sg),1)='a') and
     (copy(g_sg,length(g_sg)-1,2)='ae') then
   declinare:=1
  else
   if ((copy(n_sg,length(n_sg)-1,2)='us') or
       (copy(n_sg,length(n_sg)-1,2)='er') or
       (copy(n_sg,length(n_sg)-1,2)='ir') or
       (copy(n_sg,length(n_sg)-1,2)='um')) and
       (copy(g_sg,length(g_sg),1)='i') then
    declinare:=2
   else
    if copy(g_sg,length(g_sg)-1,2)='is' then
     declinare:=3
    else
     if ((copy(n_sg,length(n_sg)-1,2)='us') or
         (copy(n_sg,length(n_sg),1)='u')) and
         (copy(g_sg,length(g_sg)-1,2)='us') then
      declinare:=4
     else
      if (copy(n_sg,length(n_sg)-1,2)='es') or
         (copy(g_sg,length(g_sg)-1,2)='ei') then
       declinare:=5
      else
      begin
       textbackground(red);
       textcolor(green);
       clrscr;
       write('EROARE! Substantivul "'+n_sg+'" nu exista in limba latina.');
       cs_off;
       readkey;
       cs_on;
       declinare:=0;
      end;
 end;
 case declinare of
  1:begin
     neutru:=false;
     impari:=false;
     radical1:=copy(c.n_sg,1,length(c.n_sg)-1);
     radical2:=copy(c.g_sg,1,length(c.g_sg)-2);
     for cz:=n_s to ab_p do
      with terminatie[cz] do
       case cz of
        n_s,v_s,ab_s:begin
                      voc_t:='a';
                      des_c:='';
                     end;
        g_s,d_s,n_p,v_p:begin
                         voc_t:='a';
                         des_c:='e';
                        end;
        ac_s:begin
              voc_t:='a';
              des_c:='m';
             end;
        g_p :begin
              voc_t:='a';
              des_c:='rum';
             end;
        d_p,ab_p:begin
                  voc_t:=' ';
                  des_c:='is';
                 end;
        ac_p:begin
              voc_t:='a';
              des_c:='s';
             end;
       end;
    end;
  2:begin
     if c.n_sg[length(c.n_sg)]='m' then
      neutru:=true
     else
      neutru:=false;
     impari:=false;
     radical1:=copy(c.n_sg,1,length(c.n_sg)-2);
     radical2:=copy(c.g_sg,1,length(c.g_sg)-1);
     if neutru then
      for cz:=n_s to ab_p do
       with terminatie[cz] do
        case cz of
         n_s,v_s,ac_s:begin
                       voc_t:='u';
                       des_c:='m';
                      end;
         g_s:begin
              voc_t:=' ';
              des_c:='i';
             end;
         d_s,ab_s:begin
                   voc_t:='o';
                   des_c:='';
                  end;
         n_p,v_p,ac_p:begin
                       voc_t:=' ';
                       des_c:='a';
                      end;
         g_p:begin
              voc_t:='o';
              des_c:='rum';
             end;
         d_p,ab_p:begin
                   voc_t:=' ';
                   des_c:='is';
                  end;
        end
     else
      for cz:=n_s to ab_p do
       with terminatie[cz] do
        case cz of
         n_s:begin
              if copy(c.n_sg,length(c.n_sg)-1,2)='us' then
              begin
               voc_t:='u';
               des_c:='s';
              end
              else
              begin
               voc_t:=' ';
               des_c:=copy(c.n_sg,length(c.n_sg)-1,2);
              end;
             end;
         v_s:begin
              if c.n_sg[length(c.n_sg)-1]<>'u' then
              begin
               voc_t:=' ';
               des_c:=copy(c.n_sg,length(c.n_sg)-1,2);
              end
              else
              begin
               voc_t:=' ';
               des_c:='e';
              end;
             end;
         g_s,n_p,v_p:begin
                      voc_t:=' ';
                      des_c:='i';
                     end;
         d_s,ab_s:begin
                   voc_t:='o';
                   des_c:='';
                  end;
         ac_s:begin
               voc_t:='u';
               des_c:='m';
              end;
         g_p:begin
              voc_t:='o';
              des_c:='rum';
             end;
         d_p,ab_p:begin
                   voc_t:=' ';
                   des_c:='is';
                  end;
         ac_p:begin
               voc_t:='o';
               des_c:='s';
              end;
        end;
    end;
  3:begin
     if c.n_sg[length(c.n_sg)]='e' then
      radical1:=copy(c.n_sg,1,length(c.n_sg)-1)
     else
      radical1:=copy(c.n_sg,1,length(c.n_sg)-2);
     radical2:=copy(c.g_sg,1,length(c.g_sg)-2);
     if radical1<>radical2 then
     begin
      impari:=true;
      radical1:=c.n_sg;
     end
     else
      impari:=false;
     if impari then
     begin
      repeat
       clrscr;
       gotoxy(1,10);
       writeln('Substantivul dat de dv. este de declinarea a III-a imparisilabica,');
       writeln('     asa ca nu pot sa determin daca este sau nu neutru.');
       write('               Daca este,apasati ''D'',altfel''N''');
       cs_off;
       ch:=upcase(readkey);
       cs_on;
      until ch in ['D','N'];
      if ch='D' then
       neutru:=true
      else
       neutru:=false;
      if neutru then
       for cz:=n_s to ab_p do
        with terminatie[cz] do
         case cz of
          n_s,v_s,ac_s:begin
                        voc_t:=' ';
                        des_c:='';
                       end;
          g_s:begin
               voc_t:='i';
               des_c:='s';
              end;
          d_s:begin
               voc_t:='i';
               des_c:='';
              end;
          ab_s:begin
                voc_t:='e';
                des_c:='';
               end;
          n_p,v_p,ac_p:begin
                        voc_t:=' ';
                        des_c:='a';
                       end;
          g_p:begin
               voc_t:=' ';
               des_c:='um';
              end;
          d_p,ab_p:begin
                    voc_t:='i';
                    des_c:='bus';
                   end;
         end
      else
       for cz:=n_s to ab_p do
        with terminatie[cz] do
         case cz of
          n_s,v_s:begin
                   voc_t:=' ';
                   des_c:='';
                  end;
          g_s:begin
               voc_t:='i';
               des_c:='s';
              end;
          d_s:begin
               voc_t:='i';
               des_c:='';
              end;
          ac_s:begin
                voc_t:='e';
                des_c:='m';
               end;
          ab_s:begin
                voc_t:='e';
                des_c:='';
               end;
          n_p,v_p,ac_p:begin
                        voc_t:='e';
                        des_c:='s';
                       end;
          g_p:begin
                voc_t:=' ';
                des_c:='um';
               end;
          d_p,ab_p:begin
                    voc_t:='i';
                    des_c:='bus';
                   end;
         end;
     end
     else
     begin
      if c.n_sg[length(c.n_sg)]='e' then
       neutru:=true
      else
       neutru:=false;
      if neutru then
       for cz:=n_s to ab_p do
         with terminatie[cz] do
          case cz of
           n_s,v_s,ac_s:begin
                         voc_t:='e';
                         des_c:='';
                        end;
           g_s:begin
                voc_t:='i';
                des_c:='s';
               end;
           d_s,ab_s:begin
                     voc_t:='i';
                     des_c:='';
                    end;
           n_p,v_p,ac_p:begin
                         voc_t:='i';
                         des_c:='a';
                        end;
           g_p:begin
                voc_t:='i';
                des_c:='um';
               end;
           d_p,ab_p:begin
                     voc_t:='i';
                     des_c:='bus';
                    end;
          end
      else
       for cz:=n_s to ab_p do
        with terminatie[cz] do
         case cz of
          n_s,v_s,g_s:begin
                       voc_t:='i';
                       des_c:='s';
                      end;
          d_s:begin
               voc_t:='i';
               des_c:='';
              end;
          ac_s:begin
                voc_t:='e';
                des_c:='m';
               end;
          ab_s:begin
                voc_t:='e';
                des_c:='';
               end;
          n_p,v_p,ac_p:begin
                        voc_t:='e';
                        des_c:='s';
                       end;
          g_p:begin
                voc_t:='i';
                des_c:='um';
               end;
          d_p,ab_p:begin
                    voc_t:='i';
                    des_c:='bus';
                   end;
         end;
     end;
    end;
  4:begin
     if c.n_sg[length(c.n_sg)]<>'s' then
      neutru:=true
     else
      neutru:=false;
     impari:=false;
     radical2:=copy(c.g_sg,1,length(c.g_sg)-2);
     if neutru then
     begin
      radical1:=copy(c.n_sg,1,length(c.n_sg)-1);
      for cz:=n_s to ab_p do
        with terminatie[cz] do
         case cz of
          n_s,v_s,ac_s,ab_s:begin
                             voc_t:='u';
                             des_c:='';
                            end;
          g_s:begin
               voc_t:='u';
               des_c:='s';
              end;
          d_s:begin
                    voc_t:='u';
                    des_c:='i';
                   end;
          n_p,v_p,ac_p:begin
                        voc_t:='u';
                        des_c:='a';
                       end;
          g_p:begin
               voc_t:='u';
               des_c:='um';
              end;
          d_p,ab_p:begin
                    voc_t:='i';
                    des_c:='bus';
                   end;
         end;
     end
     else
     begin
      radical1:=copy(c.n_sg,1,length(c.n_sg)-2);
      for cz:=n_s to ab_p do
       with terminatie[cz] do
        case cz of
         n_s,v_s,g_s,n_p,v_p,ac_p:begin
                                   voc_t:='u';
                                   des_c:='s';
                                  end;
         d_s:begin
              voc_t:='u';
              des_c:='i';
             end;
         ac_s:begin
               voc_t:='u';
               des_c:='m';
              end;
         ab_s:begin
               voc_t:='u';
               des_c:='';
              end;
         g_p:begin
              voc_t:='u';
              des_c:='um';
             end;
         d_p,ab_p:begin
                   voc_t:='i';
                   des_c:='bus';
                  end;
        end;
     end;
    end;
  5:begin
     neutru:=false;
     impari:=false;
     radical1:=copy(c.n_sg,1,length(c.n_sg)-2);
     radical2:=copy(c.g_sg,1,length(c.g_sg)-2);
     for cz:=n_s to ab_p do
      with terminatie[cz] do
       case cz of
        n_s,v_s,n_p,v_p,ac_p:begin
                              voc_t:='e';
                              des_c:='s';
                             end;
        g_s,d_s:begin
                 voc_t:='e';
                 des_c:='i';
                end;
        ac_s:begin
              voc_t:='e';
              des_c:='m';
             end;
        ab_s:begin
              voc_t:='e';
              des_c:='';
             end;
        g_p:begin
             voc_t:='e';
             des_c:='rum';
            end;
        d_p,ab_p:begin
                  voc_t:='e';
                  des_c:='bus';
                 end;
       end;
    end;
 end;
end;

function tsubst.v_t(c:tcaz):char;
begin
 v_t:=terminatie[c].voc_t;
end;

function tsubst.d_c(c:tcaz):tdesinenta;
begin
 d_c:=terminatie[c].des_c;
end;

function tsubst.rad1:tradical;
begin
 rad1:=radical1;
end;

function tsubst.rad2:tradical;
begin
 rad2:=radical2;
end;

procedure intro;
var
 i:byte;
begin
 cs_off;
 for i:=1 to 100 do
 begin
  sound(50+5*i);
  delay(10);
  nosound;
 end;
 textbackground(black);
 clrscr;
 textcolor(magenta);
 gotoxy(10,7);
 writeln('Acest program incearca(si sper ca si reuseste) sa fie de folos');
 gotoxy(10,8);
 writeln('celor care cu(sau mai ales fara) voia lor sunt nevoiti sa faca');
 gotoxy(10,9);
 writeln('latina la scoala. Aceasta prima versiune poate doar sa decline');
 gotoxy(10,10);
 writeln('un substantiv dat la toate cazurile,la singular si plural.');
 gotoxy(10,11);
 writeln('Totusi sper ca va va fi destul de util(de ex. primiti la');
 gotoxy(10,12);
 writeln('latina(evident) o tema de genul:');
 gotoxy(10,13);
 writeln(' -"Declinati substantivul x la toate cazurile cunoscute!" ');
 gotoxy(10,14);
 writeln(' -??!!!?!');
 gotoxy(10,15);
 writeln(' -Foarte simplu.Dati doar forma de nominativ singular si cea de');
 gotoxy(10,16);
 writeln('  genitiv singular si obtineti fara nici un efort toate formele');
 gotoxy(10,17);
 writeln('  dorite. Le copiati in caiet, si gata...)');
 gotoxy(10,18);
 writeln('Acesta a fost doar un exemplu de situatie');
 gotoxy(10,19);
 writeln('     in care LHelper este util...');
 textcolor(green);
 gotoxy(40,22);
 writeln('Acest program a fost scris in');
 gotoxy(40,23);
 writeln('     Borland Pascal 7.0');
 gotoxy(40,24);
 writeln('          de catre');
 gotoxy(40,25);
 writeln('        IONUT BIZAU');
 textcolor(yellow);
 gotoxy(5,22);
 writeln('   LHelper ver.1.0,');
 gotoxy(5,23);
 writeln(' 08.03.2000');
 cs_off;
 readkey;
 cs_on;
end;

function menu:boolean;
var
 c:char;
begin
 repeat
  textbackground(black);
  textcolor(white);
  clrscr;
  writeln;
  writeln;
  writeln;
  writeln('   [1] Declina un substantiv');
  writeln('   [2] Iesire');
  cs_off;
  c:=readkey;
  cs_on;
 until c in ['1','2'];
 case c of
  '1':menu:=true;
  '2':menu:=false;
 end;
end;

procedure run;
var
 citit:tcitit;
 subst:tsubst;
 caz  :tcaz;
begin
 intro;
 while menu do
 begin
  textbackground(black);
  textcolor(white);
  clrscr;
  writeln;
  writeln;
  writeln;
  write('Dati forma de nominativ singular(de ex."casa"):');
  readln(citit.n_sg);
  write('Dati forma de genitiv singular(de ex."casae") :');
  readln(citit.g_sg);
  with subst do
  begin
   init(citit);
   clrscr;
   for caz:=n_s to ab_p do
   begin
    textcolor(magenta);
    case caz of
     n_s      :begin
                writeln;
                textcolor(green);
                writeln('       Singular');
                textcolor(magenta);
                writeln;
                write(' Nominativ  ':12);
               end;
     n_p      :begin
                writeln;
                textcolor(green);
                writeln('       Plural');
                textcolor(magenta);
                writeln;
                write(' Nominativ  ':12);
               end;
     v_s,v_p  :write(' Vocativ  ':12);
     g_s,g_p  :write(' Genitiv  ':12);
     d_s,d_p  :write(' Dativ  ':12);
     ac_s,ac_p:write(' Acuzativ  ':12);
     ab_s,ab_p:write(' Ablativ  ':12);
    end;
    textcolor(red);
    if (caz=n_s) or (caz=v_s) or (neutru and (caz=ac_s)) then
     write(rad1)
    else
     write(rad2);
    textcolor(yellow);
    if v_t(caz)<>' ' then
     write(v_t(caz));
    textcolor(blue);
    writeln(d_c(caz));
   end;
   textcolor(yellow);
   gotoxy(30,5);
   write('Substantivul: ',rad1);
   if v_t(n_s)<>' ' then
    write(v_t(n_s));
   write(d_c(n_s));
   gotoxy(30,6);
   write('Declinarea:   ');
   case declinare of
    1:write('I');
    2:write('a II-a');
    3:begin
       write('a III-a ');
       if impari then
        write('im');
       write('parisilabica');
      end;
    4:write('a IV-a');
    5:write('a V-a');
   end;
   gotoxy(30,7);
   write('Genul:        ');
   if neutru then
    write('neutru')
   else
    if declinare=5 then
     if (rad1='di') and (rad2='di') then
      write('ambigen')
     else
      write('feminin')
    else
     if (declinare=2) and ((d_c(n_s)='er') or (d_c(n_s)='ir')) then
      write('masculin')
     else
      write('masculin sau feminin');
  end;
  textcolor(green);
  gotoxy(37,19);
  write('Legenda:');
  textbackground(red);
  gotoxy(35,20);
  write(' ');
  textbackground(yellow);
  gotoxy(35,21);
  write(' ');
  textbackground(blue);
  gotoxy(35,22);
  write(' ');
  textbackground(black);
  textcolor(white);
  gotoxy(36,20);
  write('=radicalul');
  gotoxy(36,21);
  write('=vocala temei');
  gotoxy(36,22);
  write('=desinenta cazuala');
  cs_off;
  if subst.declinare<>0 then
   readkey;
  cs_on;
 end;
 clrscr;
 textcolor(red);
 gotoxy(10,18);
 writeln('Daca v-a placut acest program, dati-l si prietenilor vostri!');
 gotoxy(10,19);
 writeln('Daca nu, puteti sa-l stergeti, pt. ca inseamna ca ati');
 gotoxy(10,20);
 writeln('       invatat terminatiile! (oare?)');
 cs_off;
 readkey;
 cs_on;
end;

begin
 run;
end.