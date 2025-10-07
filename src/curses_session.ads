with Ada.Finalization;

package Curses_Session is
   type Session is new Ada.Finalization.Limited_Controlled with private;

   -- Optional knobs you want to set on enter:
   overriding procedure Initialize (S : in out Session);
   overriding procedure Finalize   (S : in out Session);

private
   type Session is new Ada.Finalization.Limited_Controlled with null record;
end Curses_Session;
