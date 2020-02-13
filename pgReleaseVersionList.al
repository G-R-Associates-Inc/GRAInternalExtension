/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
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
                    Editable = false;
                }
                field("Customer Name"; "Customer Name")
                {
                    Editable = false;
                }
                field("Version Tag No."; "Version Tag No.")
                {

                }
                field("Release Date"; "Release Date")
                {

                }
                field(Description; Description)
                {

                }
                field(Patch; Patch)
                {

                }
                field("Number of Objects"; "Number of Objects")
                {

                }
            }

        }
    }
}