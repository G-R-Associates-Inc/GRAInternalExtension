/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/

page 50106 "Customer Project List"
{

    SourceTable = "Customer";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
                field(Name; Name)
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
            }
        }
    }

}