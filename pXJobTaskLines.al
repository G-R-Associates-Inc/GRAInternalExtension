/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*               - Added field "Default Type", and "Default No." according to definition from NAV 2009
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/

pageextension 50107 pXJobTaskLines extends "Job Task Lines"
{
    layout
    {
        addafter("Job Posting Group")
        {
            field(Chargeable; Chargeable)
            {
                ApplicationArea = All; //GRALE02 - Add
            }
        }
    }
}