with Ada.Text_IO;
with Terminal_Interface.Curses;  use Terminal_Interface.Curses;
with Snake;
with Snake.Game;

procedure Ada_Snake is
   Visibility : Cursor_Visibility := Invisible;
begin
   Init_Screen;
   --  if Has_Colors then
   --     Start_Color;
   --     if Can_Change_Color then
   --        Init_Color (Black, 0, 0, 0);         -- 0..1000 scale
   --        Init_Color (Blue, 0, 0, 250);
   --     end if;
   --     Init_Pair (1, Yellow, Blue);
   --  end if;

   --  roughly like noecho() + keypad(stdscr, TRUE) in C:
   Set_Echo_Mode (False);
   Set_KeyPad_Mode (Standard_Window, True);
   Set_Timeout_Mode (Standard_Window, Non_Blocking, 0);
   Set_Cursor_Visibility (Visibility);

   Snake.Game.Run_Game;

   End_Windows;
end Ada_Snake;
