label 10;
Var
  X, init_hide, init_xtank, init_tank, init_sound,
  Xtank_value, Ytank_value, value_sound, value_delay, loop, where_hide, satellite, where_Xtank, where_Ytank, random_note, term, plane_no, center_X, center_Y: integer;
  missile_allow, game_over, sat_move, temp_term, done: boolean;
  board_no, tank_no, sat_random, score: integer;
  ch: string[1];
  temp_hide,
  hide: array [0..31] of boolean;
  Xtank,
  Ytank: array [0..31] of integer;
  array_sound, array_delay: array [0..6] of integer;
  bomb: array [0..7] of boolean;
  Xbomb,
  Ybomb: array [0..7] of integer;
  terminated: array [0..4] of boolean;
  Xconst_plane1,
  Xconst_plane2,
  Xconst_plane3,
  Xconst_plane4,
  Yconst_plane: integer;
  missile, Ymissile: integer;
  s, c,
  plane,
  satellite,
  backtank, black_sat, key,
  protank: array [0..1000] of byte;
  tankshells, hidetank, blackplane: array[0..1000] of byte;
  bak, pro: boolean;
  Xplane, Yplane: integer;
(* procedures *)
procedure initialize;
var
  init_hide, init_Xtank, init_sound, loop: Integer;
begin
  // Initialize 'hidel' array
  for init_hide := 0 to 31 do
    hidel[init_hide] := false;

  // Initialize 'Xtank' array
  Xtank_value := 0;
  Ytank_value := 140;
  for init_Xtank := 0 to 7 do
  begin
    Xtank[init_Xtank] := Xtank_value;
  end;

  // Continue initializing 'Xtank' array
  Xtank_value := 0;
  Ytank_value := 120;
  for init_Xtank := 8 to 15 do
  begin
    Xtank[init_Xtank] := Xtank_value;
  end;

  // Continue initializing 'Xtank' and 'Ytank' arrays
  Xtank_value := 0;
  Ytank_value := 100;
  for init_Xtank := 16 to 23 do
  begin
    Xtank[init_Xtank] := Xtank_value * Xtank_value + 30;
    Ytank[init_Xtank] := Ytank_value;
    Xtank_value := Xtank_value + 30;
  end;

  // Continue initializing 'Xtank' and 'Ytank' arrays
  Xtank_value := 0;
  Ytank_value := 80;
  for init_Xtank := 24 to 31 do
  begin
    Xtank[init_Xtank] := Xtank_value;
    Ytank[init_Xtank] := Ytank_value;
    Xtank_value := Xtank_value + 30;
  end;

  // Initialize 'array_sound' and 'array_delay' arrays
  for init_sound := 0 to 7 do
  begin
    array_sound[init_sound] := value_sound;
    array_delay[init_sound] := value_delay;
    value_sound := value_sound - 500;
    value_delay := value_delay + 2;
  end;

  // Initialize missile coordinates and temp_hidel array
  Xmissile := 0;
  Ymissile := 0;
  for loop := 0 to 7 do
  begin
    temp_hidel[loop] := true;
  end;
for loop := 8 to 31 do
begin
  temp_hidel[loop] := false;
end;
temp_term := false;
center_X := 220;
center_Y := 40;
bak := false;
missile_allow := false;
game_over := false;
Xconst_planel := 100;
Xconst_plane2 := 0; // Changed Xconst_plane2 from ':=' to '='
Yconst_plane := 20;
end; { initialize }

procedure title_music;
var
  counter, count, variation: integer;
begin
  count := 500;
  counter := 10;
  for variation := 1 to 7 do
  begin
    sound(count);
    delay(variation);
    sound(100);
    delay(10);
    count := count + 100;
  end;
end; { title_music }

procedure touch_sound;
begin
  for loop := 0 to 6 do 
  begin
    sound(100);
    delay(5);
    nosound;
  end;
end; { touch_sound }

procedure forward_move;
begin
  for loop := 0 to 31 do
  begin
    if not hidel[loop] then
    begin
      putpic(protank, Xtank[loop], Ytank[loop]);
      Xtank[loop] := Xtank[loop] + 5; // Removed unnecessary space around loop index
    end; // Added missing "end" to close the "if" statement
  end; // Added missing "end" to close the "for" loop
end;

procedure back_move;
begin
  for loop := 0 to 31 do
  begin
    if not hidel[loop] then
      putpic(backtank, Xtank[loop], Ytank[loop]); // Removed unnecessary square brackets and curly braces
      Xtank[loop] := Xtank[loop] - 5; // Corrected the decrement operator and removed unnecessary characters
  end; // Added missing "end" to close the "for" loop
end; // Added missing semicolon


procedure allowance_pro;
begin
  pro := true;
  bak := false; // Added semicolon to separate statements
end; // Removed colon after "end" and fixed the procedure declaration

procedure allowance_back;
begin
  bak := true; // Fixed syntax error
  pro := false; // Added semicolon to separate statements
end; // Removed colon after "end" and fixed the procedure declaration


procedure down;
begin
  for loop := 0 to 31 do
    Ytank[loop] := Ytank[loop] + 2;
end; // Removed colon after "end" and fixed the procedure declaration

procedure probability_pro;
begin
  if bak = true then
  begin
    if (hide[24] = true) and
       (hide[25] = true) and
       (hide[26] = true) and
       (hide[27] = true) and
       (hide[28] = true) and
       (hide[29] = true) and
       (hide[30] = true) and
       (Xtank[31] <= 0) then
      allowance_pro;
  end;

  if bak = true then
  begin
    if (hide[24] = true) and
       (hide[25] = true) and
       (hide[26] = true) and
       (hide[27] = true) and
       (hide[28] = true) and
       (hide[29] = true) and
       (Xtank[30] <= 0) then
      allowance_pro;
  end;

  if bak = true then
  begin
    if (hide[24] = true) and
       (hide[25] = true) and
       (hide[26] = true) and
       (hide[27] = true) and
       (hide[28] = true) and
       (Xtank[29] <= 0) then
      allowance_pro;
  end;

  if bak = true then
  begin
    if (hide[24] = true) and
       (hide[25] = true) and
       (hide[26] <= 0) then
      allowance_pro;
  end;

  if bak = true then
  begin
    if (hide[24] = true) and
       (Xtank[25] <= 0) then
      allowance_pro;
  end;
end; // Removed colon after "end" and fixed the procedure declaration

procedure probability_back;
begin
  if pro = true then
  begin
    if (hide[31] = true) and
       (hide[30] = true) and
       (hide[29] = true) and
       (hide[28] = true) and
       (hide[27] = true) and
       (hide[26] = true) and
       (hide[25] = true) and
       (Xtank[24] >= 290) then
    begin
      down;
      allowance_back;
    end;
  end;

  if pro = true then
  begin
    if (hide[31] = true) and
       (hide[30] = true) and
       (hide[29] = true) and
       (hide[28] = true) and
       (hide[27] = true) and
       (hide[26] = true) and
       (Xtank[25] >= 290) then
    begin
      down;
      allowance_back;
    end;
  end;

  if pro = true then
  begin
    if (hide[31] = true) and
       (hide[30] = true) and
       (hide[29] = true) and
       (hide[28] = true) and
       (hide[27] = true) and
       (Xtank[26] >= 290) then
    begin
      down;
      allowance_back;
    end;
  end;

  if pro = true then
  begin
    if (hide[31] = true) and
       (hide[30] = true) and
       (hide[29] = true) and
       (Xtank[28] >= 290) then
    begin
      down;
      allowance_back;
    end;
  end;

  if pro = true then
  begin
    if (hide[31] = true) and
       (hide[30] = true) and
       (Xtank[29] >= 290) then
    begin
      down;
      allowance_back;
    end;
  end;

  if pro = true then
  begin
    if (hide[31] = true) and
       (Xtank[30] >= 290) then
    begin
      down;
      allowance_back;
    end;
  end;
end; // Removed colon after "end" and fixed the procedure declaration


procedure decide_toHide;
begin
  done := false;
  where_hide := 0; {used for all arrays}
  
  repeat
    if (hide[where_hide] = false) and (temp_hide[where_hide] = true) then
    begin
      if (Xmissile < Xtank[where_hide] + 23) and
         (Xmissile > Xtank[where_hide] + 8) and
         (Ymissile < Ytank[where_hide]) and
         (Ymissile > Ytank[where_hide] - 15) then
      begin
        putpic(hidetank, Xtank[where_hide], Ytank[where_hide]);
        temp_term[where_hide + 8] := true;
        hide[where_hide] := true;
        score := score + 50;
        // touch sound : clearscreen ; // Removed this line as it seems incomplete
        missile_allow := false;
        done := true;
      end;
    end;
    
    where_hide := where_hide + 1;
    
    if where_hide > 31 then
      done := true;
  until done = true;
end; { decide_toHide }

procedure bomb_declare;
var
  random_note: integer;
begin
  random_note := random(7);

  for loop := 0 to 20 do
  begin
    if random_note = loop then
      bomb[loop] := true;
  end;

  for loop := 0 to 7 do
  begin
    if bomb[loop] = false then
    begin
      Xbomb[loop] := Xtank[loop] + 24;
      Ybomb[loop] := Ytank[loop] + 8;
    end;
  end;

  for loop := 0 to 7 do
  begin
    if bomb[loop] = true then
    begin
      putpic(tankshells, Xbomb[loop], Ybomb[loop]);
      Ybomb[loop] := Ybomb[loop] + 5;

      if Ybomb[loop] >= 400 then
        bomb[loop] := false;
    end;
  end;
end; { bomb_declare }

procedure probability_toCrash;
begin
  for loop := 0 to 7 do
  begin
    if (Xbomb[loop] > xplane + 5) and
       (Xbomb[loop] + 3 < xplane + 25) and
       (Ybomb[loop] > yplane - 15) and
       (Ybomb[loop] < yplane - 5) then
    begin
      terminated[term] := true;
      bomb[loop] := false;
      term := term + 1;
      temp_term := true;
    end;
  end;
end; { probability_toCrash }


procedure after_planeCrash;
begin
  if temp_term = true then
  begin
    clearscreen;
    graphbackground(15);

    for X := 1 to 2 do
      title_music;

    putpic(blackplane, Xplane, Yplane);
    Yplane := center_Y;

    if terminated[0] = true then
      putpic(blackplane, Xconst_plane1, Yconst_plane);

    if terminated[1] = true then
      putpic(blackplane, Xconst_plane2, Yconst_plane);

    if terminated[2] = true then
      putpic(blackplane, Xconst_plane3, Yconst_plane);

    if terminated[3] = true then
      putpic(blackplane, Xconst_plane4, Yconst_plane);
  end;
end; { after_planeCrash }

procedure emptyBoard;
begin
  if (hide[24] = true) and
     (hide[25] = hide[24]) and
     (hide[26] = hide[25]) and
     (hide[27] = hide[26]) and
     (hide[28] = hide[27]) and
     (hide[29] = hide[28]) and
     (hide[30] = hide[29]) and
     (hide[31] = hide[30]) then
  begin
    initialize;
  end;
end; { emptyBoard }

procedure launch_missile;
begin
  draw(xmissile, ymissile, xmissile, intensityBane3);
  draw(missile, ymissile + 10, xmissile, ymissile + 20, 0); { dark part }
  ymissile := ymissile - 10;
  if Ymissile <= 0 - 20 then
    missile_allow := false;
end; { launch_missile }

procedure showconst_plane;
begin
  if terminated[0] = false then
    putpic(plane, const_planel, const_plane);
  
  if terminated[1] = false then
    putpic(plane, const_plane2, Yconst_plane);
  
  if terminated[2] = false then
    putpic(plane, const_plane3, Yconst_plane);
  
  if terminated[3] = false then
    putpic(plane, const_plane4, Yconst_plane);
end;


procedure main_Crash;
begin
  for loop := 0 to 31 do
  begin
    if not hide[loop] then
    begin
      if (Xplane > Xtank[loop] - 15) and (Xplane < Xtank[loop] + 15) and (Yplane < Ytank[loop] + 15) and (Yplane > Ytank[loop] - 10) then
      begin
        terminated[term] := true;
        term := term + 1;
        temp_term := true;
      end;
    end;
  end;
end;



begin
  graphcolormode;
  palette(3);
  draw(90, 80, 70, 80, 3);
  draw(70, 80, 65, 85, 3);
  draw(65, 110, 70, 115, 3);
  draw(70, 115, 90, 115, 3);
  draw(90, 110, 70, 110, 3);
  draw(70, 110, 70, 85, 3);
  draw(90, 85, 90, 80, 3);
  draw(65, 85, 65, 110, 3);
  draw(90, 115, 90, 110, 3);
  draw(70, 85, 90, 85, 3);
  fillshape(80, 82, 3, 3);
  draw(100, 80, 95, 85, 3);
  draw(95, 85, 95, 110, 3);
  draw(95, 110, 100, 115, 3);
  draw(100, 115, 120, 115, 3);
  draw(120, 115, 125, 110, 3);
  draw(125, 110, 125, 85, 3);
  draw(125, 85, 120, 80, 3);
  draw(120, 80, 100, 80, 3);
  draw(100, 85, 100, 110, 3);
  draw(100, 110, 120, 110, 3);
  draw(120, 110, 120, 85, 3);
  draw(120, 85, 100, 85, 3);
  fillshape(110, 82, 3, 3);
  draw(130, 115, 130, 85, 3);
  draw(140, 80, 145, 85, 3);
  draw(155, 80, 160, 85, 3);
  draw(155, 115, 155, 85, 3);
  draw(148, 115, 142, 115, 3);
  draw(135, 85, 135, 115, 3);
  draw(130, 85, 135, 80, 3);
  draw(135, 80, 140, 80, 3);
  draw(145, 85, 150, 80, 3);
  draw(150, 80, 155, 80, 3);
  draw(160, 85, 160, 115, 3);
  draw(160, 115, 155, 115, 3);
  draw(155, 85, 148, 85, 3);
  draw(148, 85, 140, 115, 3);
  draw(142, 115, 142, 85, 3);
  draw(142, 85, 135, 85, 3);
  draw(135, 115, 130, 115, 3);
  fillshape(145, 95, 3, 3);
  draw(165, 80, 190, 80, 3);
  draw(190, 80, 195, 85, 3);
  draw(195, 85, 195, 90, 3);
  draw(195, 90, 190, 93, 3);
  draw(190, 93, 195, 96, 3);
  draw(195, 96, 195, 110, 3);
  draw(195, 110, 190, 115, 3);
  draw(190, 115, 165, 115, 3);
  draw(165, 115, 165, 80, 3);
  draw(170, 85, 170, 90, 3);
  draw(170, 90, 190, 90, 3);
  draw(190, 90, 190, 85, 3);
  draw(190, 85, 170, 85, 3);
  draw(170, 110, 190, 110, 3);
  draw(190, 110, 190, 95, 3);
  draw(190, 95, 170, 95, 3);
  fillshape(180, 93, 3, 3);
  draw(240, 80, 260, 80, 3);
  draw(260, 80, 265, 85, 3);
  draw(265, 85, 253, 85, 3);
  draw(253, 85, 253, 115, 3);
  draw(253, 115, 247, 115, 3);
  draw(247, 115, 247, 85, 3);
  draw(247, 85, 235, 85, 3);
  draw(235, 85, 240, 80, 3);
  fillshape(250, 95, 3, 3);
  draw(130, 115, 130, 85, 3);
  draw(140, 80, 145, 85, 3);
  draw(155, 80, 160, 85, 3);
  draw(155, 115, 155, 85, 3);
  draw(148, 115, 142, 115, 3);
  draw(135, 85, 135, 115, 3);
  draw(130, 85, 135, 80, 3);
  draw(135, 80, 140, 80, 3);
  draw(145, 85, 150, 80, 3);
  draw(150, 80, 155, 80, 3);
  draw(160, 85, 160, 115, 3);
  draw(160, 115, 155, 115, 3);
  draw(155, 85, 148, 85, 3);
  draw(148, 85, 140, 115, 3);
  draw(142, 115, 142, 85, 3);
  draw(142, 85, 135, 85, 3);
  draw(135, 115, 130, 115, 3);
  fillshape(145, 95, 3, 3);
  draw(165, 80, 190, 80, 3);
  draw(190, 80, 195, 85, 3);
  draw(195, 85, 195, 90, 3);
  draw(195, 90, 190, 93, 3);
  draw(190, 93, 195, 96, 3);
  draw(195, 96, 195, 110, 3);
  draw(195, 110, 190, 115, 3);
  draw(190, 115, 165, 115, 3);
  draw(165, 115, 165, 80, 3);
  draw(170, 85, 170, 90, 3);
  draw(170, 90, 190, 90, 3);
  draw(190, 90, 190, 85, 3);
  draw(190, 85, 170, 85, 3);
  draw(170, 110, 190, 110, 3);
  draw(190, 110, 190, 95, 3);
  draw(190, 95, 170, 95, 3);
  fillshape(180, 93, 3, 3);
  draw(240, 80, 260, 80, 3);
  draw(260, 80, 265, 85, 3);
  draw(265, 85, 253, 85, 3);
  draw(253, 85, 253, 115, 3);
  draw(253, 115, 247, 115, 3);
  draw(247, 115, 247, 85, 3);
  draw(247, 85, 235, 85, 3);
  draw(235, 85, 240, 80, 3);
  fillshape(250, 95, 3, 3);
  draw(120, 40, 290, 40, 3);
  draw(290, 40, 290, 150, 3);
  draw(290, 150, 120, 150, 3);
  draw(120, 150, 120, 40, 3);
  draw(210, 40, 210, 150, 3);
  draw(50, 40, 120, 40, 3);
  draw(50, 40, 50, 150, 3);
 {** Plane **}

 draw(50, 150, 120, 150, 3);
  draw(140, 50, 139, 53, 3);
  draw(139, 53, 139, 55, 3);
  draw(139, 55, 131, 60, 3);
  draw(131, 60, 131, 61, 3);
  draw(131, 61, 138, 61, 3);
  draw(138, 61, 135, 64, 3);
  draw(135, 64, 135, 65, 3);
  draw(135, 65, 140, 53, 3);
  draw(140, 63, 145, 65, 3);
  draw(145, 65, 145, 64, 3);
  draw(145, 64, 142, 61, 3);
  draw(142, 61, 149, 61, 3);
  draw(149, 61, 149, 60, 3);
  draw(149, 60, 141, 55, 3);
  draw(141, 55, 141, 53, 3);
  draw(141, 53, 140, 50, 3);
  fillshape(140, 57, 3, 3);
  draw(135, 56, 135, 58, 1);
  draw(145, 56, 145, 58, 1);
  fillpattern(1, 5, 3, 7, 3);
  draw(2, 5, 2, 9, 1);
  getpic(plane, 125, 45, 155, 70);
  getpic(tankshells, 1, 0, 3, 9);

{* Forward directed Tank}
draw(130, 79, 130, 81, 3);
  draw(130, 81, 132, 81, 3);
  draw(132, 81, 132, 83, 3);
  draw(132, 83, 148, 83, 3);
  draw(148, 83, 148, 81, 3);
  draw(148, 81, 150, 81, 3);
  draw(150, 81, 148, 79, 3);
  draw(148, 79, 130, 79, 3);
  fillshape(140, 81, 3, 3);
  draw(130, 81, 130, 83, 1);
  draw(130, 83, 132, 85, 1);
  draw(132, 85, 148, 85, 1);
  draw(141, 85, 150, 69, 1);
  draw(150, 69, 150, 61, 1);
  draw(131, 76, 131, 79, 2);
  draw(135, 75, 135, 75, 1);
  draw(135, 75, 138, 75, 1);
  draw(136, 75, 138, 71, 1);
  draw(138, 77, 140, 79, 1);
  draw(140, 79, 135, 79, 1);
  draw(138, 76, 150, 76, 1);
  fillshape(136, 77, 1, 1);
  draw(138, 77, 150, 77, 1);
  getpic(protank, 125, 70, 155, 90);


  {** Backward directed tank}
  draw(142, 100, 145, 100, 1);
  draw(145, 100, 145, 104, 1);
  draw(145, 104, 140, 104, 1);
  draw(142, 102, 142, 100, 1);
  draw(140, 104, 142, 102, 1);
  fillshape(143, 102, 1, 1);
  draw(130, 102, 142, 102, 1);
  draw(130, 101, 142, 101, 1);
  draw(149, 101, 149, 104, 1);
  draw(150, 104, 132, 104, 3);
  draw(132, 104, 130, 106, 3);
  draw(130, 106, 132, 106, 3);
  draw(132, 106, 132, 108, 3);
  draw(132, 108, 148, 108, 3);
  draw(148, 108, 148, 106, 3);
  draw(148, 106, 150, 106, 3);
  draw(150, 106, 150, 104, 3);
  fillshape(140, 106, 3, 3);
  draw(130, 106, 130, 108, 1);
  draw(130, 108, 132, 110, 1);
  draw(132, 110, 148, 110, 1);
  draw(148, 110, 150, 108, 1);
  draw(150, 108, 150, 106, 1);
  getpic(backtank, 125, 95, 155, 115);


  {** Satellite **}
  raw(137, 125, 143, 125, 1);
  draw(143, 125, 145, 127, 1);
  draw(145, 127, 147, 125, 1);
  draw(147, 125, 149, 125, 1);
  draw(149, 125, 151, 127, 1);
  draw(151, 127, 151, 133, 1);
  draw(151, 133, 149, 135, 1);
  draw(149, 135, 147, 135, 1);
  draw(147, 135, 145, 133, 1);
  draw(145, 133, 143, 135, 1);
  draw(143, 135, 137, 135, 1);
  draw(137, 135, 135, 132, 1);
  draw(135, 132, 135, 128, 1);
  draw(135, 128, 137, 125, 1);
  fillshape(140, 130, 1, 1);
  draw(137, 129, 138, 131, 0);
  draw(136, 130, 139, 130, 0);
  draw(138, 125, 140, 128, 0);
  draw(140, 128, 140, 132, 0);
  draw(140, 132, 133, 135, 0);
  draw(147, 125, 148, 127, 0);
  draw(147, 135, 148, 133, 0);
  draw(129, 127, 135, 127, 3);
  draw(135, 127, 135, 133, 3);
  draw(135, 133, 129, 133, 3);
  draw(129, 133, 131, 130, 3);
  draw(131, 130, 127, 130, 3);
  draw(127, 130, 129, 127, 3);
  fillshape(133, 130, 3, 3);
  draw(145, 127, 151, 127, 3);
  draw(151, 127, 151, 133, 3);
  draw(151, 133, 142, 133, 3);
  draw(142, 133, 145, 127, 3);
  fillshape(147, 130, 3, 3);
  draw(151, 127, 151, 133, 3);
  draw(151, 133, 152, 133, 3);
  draw(152, 133, 155, 127, 3);
  draw(155, 127, 151, 127, 3);
  fillshape(151, 130, 3, 3);
  fillpattern(140, 123, 142, 125, 3);
  draw(140, 136, 136, 139, 1);
  draw(136, 139, 144, 139, 1);
  draw(144, 139, 140, 136, 1);
  getpic(satellite, 122, 120, 160, 140);


{** Key Shape }
draw(220, 50, 230, 50, 3);
  draw(230, 50, 232, 52, 3);
  draw(232, 52, 232, 58, 3);
  draw(232, 58, 230, 60, 3);
  draw(230, 60, 220, 60, 3);
  draw(220, 60, 218, 58, 3);
  draw(218, 58, 218, 52, 3);
  draw(218, 52, 220, 50, 3);
  fillshape(225, 55, 1, 3);
  getpic(key, 215, 50, 235, 60);
  
  putpic(key, 215, 75);
  putpic(key, 215, 90);
  putpic(key, 215, 105);
  putpic(key, 215, 120);
  putpic(key, 215, 135);
  
  draw(225, 52, 225, 58, 0);
  draw(223, 55, 225, 52, 0);
  draw(225, 52, 227, 55, 0); { (Up) }
  draw(222, 70, 228, 70, 0);
  draw(224, 68, 222, 70, 0);
  draw(222, 70, 224, 72, 0);
  draw(222, 85, 228, 85, 0);
  draw(226, 83, 228, 85, 0);
  draw(228, 85, 226, 87, 0);
  draw(225, 97, 225, 103, 0);
  draw(223, 101, 225, 103, 0);
  draw(225, 103, 227, 101, 0);
  draw(220, 113, 220, 117, 0);
  draw(220, 117, 222, 117, 0);
  draw(220, 115, 222, 115, 0);
  draw(220, 113, 222, 113, 0);
  draw(224, 113, 224, 115, 0);
  draw(224, 115, 226, 115, 0);
  draw(226, 113, 224, 113, 0);
  draw(226, 113, 224, 115, 0);
  draw(224, 115, 226, 115, 0);
  draw(226, 115, 226, 117, 0);
  draw(226, 117, 224, 117, 0);
  getpic(5, 224, 113, 226, 117);
  draw(230, 113, 228, 113, 0);
  draw(228, 113, 228, 117, 0);
  draw(228, 117, 230, 117, 0);
  getpic(c, 228, 113, 230, 117);
  putpic(5, 220, 132);
  putpic(c, 228, 132);
  draw(224, 132, 224, 128, 0);
  draw(224, 128, 226, 128, 0);
  draw(226, 128, 226, 130, 0);
  draw(226, 130, 224, 130, 0);
  
  gotoXY(21, 8);
  write('Plane');
  gotoXY(21, 11);
  write('FdTank');
  gotoXY(21, 14);
  write('BkTank');
  gotoXY(21, 17);
  write('Sat');
  gotoXY(1, 5);
  write('Scores and images. Keys used');
  gotoXY(31, 15);
  write('Quits');
  gotoXY(31, 17);
  write('Fires');
  
  repeat
  until keypressed;
  
  clearscreen;

repeat
    graphBackGround(0);
    
    if not terminated[0] then
        plane_no := 1;
    
    if terminated[0] then
        plane_no := 2;
    
    if terminated[1] then
        plane_no := 3;
    
    if terminated[2] then
        plane_no := 4;
    
    if terminated[3] then
        plane_no := 5;
    
    gotoXY(1, 1);
    write('Score: ', score);
    gotoXY(73, 1);
    write('Plane: ', plane_no);
    
    putpic(plane, Xplane, Yplane);
    
    if not missile_allow then
    begin
        Xmissile := Xplane + 15;
        Ymissile := Yplane + 20;
    end;
    
    if missile_allow then
        launch_missile;
    
    decide_toHide;
    
    showconst_plane;
    
    probability_toCrash;
    
    after_planetrash;
    
    randomize;
    
    sat_random := random(20);
    
    if sat_random = 5 then
        sat_move := true;
    
    if sat_move then
    begin
        if satellite > 320 then
            Xsatellite := Xsatellite - 50;
        
        satellite := satellite + 3;
        
        if (Xmissile < Xsatellite + 35) and (Ymissile < 35) then
        begin
            score := score + 1000;
            putpic(black_sat, Xsatellite, 40);
            for loop := 0 to 2 do
                title_music;
            sat_move := false;
        end;
    end;
    
    if (not hide[24]) and (Xtank[24] <= 0) then
    begin
        pro := true;
        bak := false;
    end;
    
    if hide[24] then
        probability(pro);
    
    if (not hide[31]) and (Xtank[31] >= 290) then
    begin
        bak := true;
        pro := false;
        down;
    end;
    
    if hide[31] then
        probability(bak);
    
    if pro then
        forward_move;
    
    if bak then
        back_move;
    
    if Ytank[1] > 200 then
    begin
        clearscreen;
        goto 10;
    end;
    
    bomb_declare;
    
    if terminated[0] and terminated[1] and terminated[2] and terminated[3] and terminated[4] then
    begin
        clearscreen;
        gotoXY(13, 12);
        write('GAME OVER');
        gotoXY(13, 14);
        write('Score: ', score);
        repeat
        until keypressed;
        clearscreen;
        goto 10;
    end;
    
    if keypressed then
    begin
        read(kBd, ch);
        
        if ch = #72 then
        begin
            if Yplane > 40 then
                Yplane := Yplane - 5;
        end;
        
        if ch = #77 then
        begin
            if Xplane < 290 then
                Xplane := Xplane + 5;
        end;
        
        if ch = #80 then
        begin
            if Yplane < 200 then
                Yplane := Yplane + 5;
        end;
        
        if (ch = 'q') or (ch = 'Q') then
            game_over := true;
        
        if ch = #32 then
            missile_allow := true;
        
        main_Crash;
    end;
    
until game_over;

clearscreen;
textColor(0);
gotoXY(13, 12);
write('GAME OVER');
gotoXY(13, 14);
write('Score: ', score);
repeat
until keypressed;
end.



  

  
  

  


  

  












  
