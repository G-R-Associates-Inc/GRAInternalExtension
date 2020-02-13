/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
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

                }
                field(Username; Username)
                {

                }
                field(Password; Password)
                {

                }

                field("Website/URL"; "Website/URL")
                {

                }

                field(Comments; Comments)
                {

                }
            }
        }
    }

}