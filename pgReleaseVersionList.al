/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/

page 50102 "Release Version List"
{
    SourceTable = "Release Version";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Customer No."; "Customer No.")
                {
                    ApplicationArea = All; //GRALE02 - Add
                    Editable = false;
                }
                field("Customer Name"; "Customer Name")
                {
                    ApplicationArea = All; //GRALE02 - Add
                    Editable = false;
                }
                field("Version Tag No."; "Version Tag No.")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
                field("Release Date"; "Release Date")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
                field(Description; Description)
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
                field(Patch; Patch)
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
                field("Number of Objects"; "Number of Objects")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
            }

        }
    }
}