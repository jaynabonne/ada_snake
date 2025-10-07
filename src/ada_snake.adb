with Snake;
with Snake.Game;
with Curses_Session;

procedure Ada_Snake is
   Session : Curses_Session.Session;
   pragma Unreferenced (Session);
begin
   Snake.Game.Run_Game;
end Ada_Snake;
