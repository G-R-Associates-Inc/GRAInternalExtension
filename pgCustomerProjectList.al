/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
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

                }
                field(Name; Name)
                {

                }
            }
        }
    }

}