/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/

page 50105 "Customer Logins Subform"
{
    Caption = 'Customer Logins';
    SourceTable = "Customer Login";
    AutoSplitKey = true;
    PageType = ListPart;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Login Type"; "Login Type")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
                field(Username; Username)
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
                field(Password; Password)
                {
                    ApplicationArea = All; //GRALE02 - Add
                }

                field("Website/URL"; "Website/URL")
                {
                    ApplicationArea = All; //GRALE02 - Add
                }

                field(Comments; Comments)
                {
                    ApplicationArea = All; //GRALE02 - Add
                }
            }
        }
    }

}