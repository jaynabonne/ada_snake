with Ada.Containers.Doubly_Linked_Lists;
with Terminal_Interface.Curses;

package Snake is

   Snake_Body_Char : constant Character := '#';

   type Position is record
      Line : Integer;
      Col : Integer;
   end record;

   type Velocity is record
      X : Integer;
      Y : Integer;
   end record;

   package Snake_Body_Package is new Ada.Containers.Doubly_Linked_Lists (Element_Type => Position);

   subtype Snake_Body is Snake_Body_Package.List;

   Snake_Color_Pair : constant Terminal_Interface.Curses.Color_Pair := 0;

end Snake;
