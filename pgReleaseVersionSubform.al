/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created page according to definition from NAV 2009.
*/

page 50103 "Release Version Subform"
{
    Caption = 'Release Version';
    SourceTable = "Release Version";
    PageType = ListPart;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Version Tag No."; "Version Tag No.")
                {

                }
                field("Release Date"; "Release Date")
                {

                }
                field(Description; Description)
                {
                    Editable = false;
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