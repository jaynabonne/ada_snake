with Terminal_Interface.Curses; use Terminal_Interface.Curses;

package body Curses_Session is
   overriding procedure Initialize (S : in out Session) is
      pragma Unreferenced (S);
      Visibility : Cursor_Visibility := Invisible;
   begin
      Init_Screen;
      Set_Echo_Mode (False);
      Set_KeyPad_Mode (Standard_Window, True);
      Set_Timeout_Mode (Standard_Window, Non_Blocking, 0);
      Set_Cursor_Visibility (Visibility);
      if Has_Colors then
         Start_Color;
      end if;
   --     if Can_Change_Color then
   --        Init_Color (Black, 0, 0, 0);         -- 0..1000 scale
   --        Init_Color (Blue, 0, 0, 250);
   --     end if;
   --     Init_Pair (1, Yellow, Blue);
   end Initialize;

   overriding procedure Finalize (S : in out Session) is
      pragma Unreferenced (S);
   begin
      Set_Echo_Mode (True);
      End_Windows;
   end Finalize;
end Curses_Session;
