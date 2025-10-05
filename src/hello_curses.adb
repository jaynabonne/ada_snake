with Ada.Text_IO;
with Terminal_Interface.Curses;  use Terminal_Interface.Curses;
with Ada.Real_Time; use Ada.Real_Time;
with Snake;

procedure Hello_Curses is
   function Get_Message return String is
      Message   : constant String := "Hello from AdaCurses!";
      Full_Message : constant String := Message & " " & Natural'Image (Number_Of_Colors) & " " & Natural'Image (Number_Of_Color_Pairs);
   begin
      return Full_Message;
   end Get_Message;

   Visibility : Cursor_Visibility := Invisible;
   C : Key_Code;
   Snake_Body : Snake.Snake_Body;
   Velocity: Snake.Velocity := (X => 1, Y => 0);
   Initial_Snake_Col: Integer;
   Initial_Snake_Line: Integer;

   procedure Add_Snake_Segment(Segment: Snake.Position) is
   begin
      Snake_Body.Prepend (Segment);
      Add (Ch => Snake.Snake_Body_Char, Column => Column_Position (Segment.Col), Line => Line_Position (Segment.Line));
   end Add_Snake_Segment;

   procedure Remove_Snake_Segment is
      Segment: constant Snake.Position := Snake.Snake_Body_Package.Element (Snake_Body.Last);
   begin
      Snake_Body.Delete_Last;
      Add (Ch => ' ', Column => Column_Position (Segment.Col), Line => Line_Position (Segment.Line));
   end Remove_Snake_Segment;

   -- helper for milliseconds
   function MS (N : Natural) return Time_Span is
     (To_Time_Span (Duration (N) / 1000.0));

   Period       : constant Time_Span := MS (125);  -- ~60 Hz
   Next_Release : Time := Clock;

begin
   Init_Screen;
   if Has_Colors then
      Start_Color;
      if Can_Change_Color then
         Ada.Text_IO.Put_Line ("Can change color...");
         Init_Color (Black, 0, 0, 0);         -- 0..1000 scale
         Init_Color (Blue, 0, 0, 250);
      end if;
      Init_Pair (1, Yellow, Blue);
   end if;

   --  roughly like noecho() + keypad(stdscr, TRUE) in C:
   Set_Echo_Mode (False);
   Set_KeyPad_Mode (Standard_Window, True);
   Set_Timeout_Mode (Standard_Window, Non_Blocking, 0);
   Set_Cursor_Visibility (Visibility);

   --  Set_Character_Attributes (Attr => (others => False), Color => 3);
   --  center the message
   Set_Character_Attributes
               (Attr  => (others => False),  -- no bold/underline/etc.
               Color => 1);
   Set_Background (Standard_Window,
               (Ch => ' ', Attr => (others => False), Color => 1));
   Erase;
   Initial_Snake_Col := Integer (Columns / 2);
   Initial_Snake_Line := Integer (Lines / 2);
   Add_Snake_Segment ((Line => Initial_Snake_Line, Col => Initial_Snake_Col));
   Add_Snake_Segment ((Line => Initial_Snake_Line, Col => Initial_Snake_Col + 1));
   Add_Snake_Segment ((Line => Initial_Snake_Line, Col => Initial_Snake_Col + 2));
   Add_Snake_Segment ((Line => Initial_Snake_Line, Col => Initial_Snake_Col + 3));
   Refresh;  -- ensure it’s on-screen

   --  wait until user presses 'q'
   loop
      declare
         Current_Head: constant Snake.Position := Snake.Snake_Body_Package.Element (Snake_Body.First);
         New_Line : Integer;
         New_Col : Integer;
         IntColumns : constant Integer := Integer (Columns);
         IntLines : constant Integer := Integer (Lines);
      begin
         C := Get_Keystroke (Standard_Window);
         exit when C = Character'Pos ('q');
         if C = Character'Pos ('w') then 
            Velocity := (X => 0, Y => -1);
         elsif C = Character'Pos ('s') then 
            Velocity := (X => 0, Y => 1);
         elsif C = Character'Pos ('a') then 
            Velocity := (X => -1, Y => 0);
         elsif C = Character'Pos ('d') then 
            Velocity := (X => 1, Y => 0);
         end if;
         -- ... update & render one frame ...
         New_Col := Integer (Current_Head.Col) + Velocity.X;
         if New_Col < 0 then
            New_Col := New_Col + IntColumns;
         elsif New_Col >= IntColumns then
            New_Col := New_Col - IntColumns;
         end if;

         New_Line := Integer (Current_Head.Line) + Velocity.Y;
         if New_Line < 0 then
            New_Line := New_Line + IntLines;
         elsif New_Line >= IntLines then
            New_Line := New_Line - IntLines;
         end if;

         Add_Snake_Segment ((Col => New_Col, Line => New_Line));
         Remove_Snake_Segment;
         Refresh;
         Next_Release := Next_Release + Period;
         delay until Next_Release;      -- slips if we overran
      end;
   end loop;

   End_Windows;
end Hello_Curses;
