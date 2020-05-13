/**
*   Documentation Section
*       GRALE01 - 1/13/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/

pageextension 50112 pXJobTaskCard extends "Job Task Card"
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