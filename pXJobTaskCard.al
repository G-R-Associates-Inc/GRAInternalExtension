/**
*   Documentation Section
*       GRALE01 - 1/13/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*/

pageextension 50112 pXJobTaskCard extends "Job Task Card"
{
    layout
    {
        addafter("Job Posting Group")
        {
            field(Chargeable; Chargeable)
            {

            }
        }
    }
}