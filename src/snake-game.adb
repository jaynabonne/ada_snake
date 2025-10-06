with Terminal_Interface.Curses;  use Terminal_Interface.Curses;
with Ada.Real_Time; use Ada.Real_Time;

package body Snake.Game is

   procedure Run_Game is
      Snake_Body : Snake.Snake_Body;

      procedure Add_Snake_Segment (Segment : Snake.Position) is
      begin
         Snake_Body.Prepend (Segment);
         Add (
            Ch => Snake.Snake_Body_Char,
            Column => Column_Position (Segment.Col),
            Line => Line_Position (Segment.Line)
         );
      end Add_Snake_Segment;

      procedure Remove_Snake_Segment is
         Segment : constant Snake.Position :=
            Snake.Snake_Body_Package.Element (Snake_Body.Last);
      begin
         Snake_Body.Delete_Last;
         Add (
            Ch => ' ',
            Column => Column_Position (Segment.Col),
            Line => Line_Position (Segment.Line)
         );
      end Remove_Snake_Segment;

      function Update_And_Clip (
         Pos : Integer;
         Inc : Integer;
         Stride : Integer
      ) return Integer is
         New_Pos : Integer := Pos + Inc;
      begin
         if New_Pos < 0 then
            New_Pos := New_Pos + Stride;
         elsif New_Pos >= Stride then
            New_Pos := New_Pos - Stride;
         end if;
         return New_Pos;
      end Update_And_Clip;

      procedure Create_Initial_Snake (Col : Integer; Line : Integer) is
      begin
         Add_Snake_Segment ((Line => Line, Col => Col));
         Add_Snake_Segment ((Line => Line, Col => Col + 1));
         Add_Snake_Segment ((Line => Line, Col => Col + 2));
         Add_Snake_Segment ((Line => Line, Col => Col + 3));
      end Create_Initial_Snake;

      --  helper for milliseconds
      function MS (N : Natural) return Time_Span is
      (To_Time_Span (Duration (N) / 1000.0));

      Period       : constant Time_Span := MS (125);
      Next_Release : Time := Clock;

      Velocity : Snake.Velocity := (X => 1, Y => 0);

   begin
      --  Set_Character_Attributes (Attr => (others => False), Color => 3);
      --  center the message
      Set_Character_Attributes
                  (Attr  => (others => False),  -- no bold/underline/etc.
                  Color => Snake_Color_Pair);
      Set_Background (
         Standard_Window,
         (
            Ch => ' ',
            Attr => (others => False),
            Color => Snake_Color_Pair
         )
      );
      Erase;

      Create_Initial_Snake (Integer (Columns / 2), Integer (Lines / 2));
      Refresh;  -- ensure it’s on-screen

      --  wait until user presses 'q'
      loop
         declare
            C : Key_Code;
            Current_Head : constant Snake.Position :=
               Snake.Snake_Body_Package.Element (Snake_Body.First);
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

            New_Col := Update_And_Clip (
               Current_Head.Col, Velocity.X, IntColumns
            );
            New_Line := Update_And_Clip (
               Current_Head.Line, Velocity.Y, IntLines
            );

            Add_Snake_Segment ((Col => New_Col, Line => New_Line));
            Remove_Snake_Segment;
            Refresh;
            Next_Release := Next_Release + Period;
            delay until Next_Release;      -- slips if we overran
         end;
      end loop;
   end Run_Game;

end Snake.Game;
