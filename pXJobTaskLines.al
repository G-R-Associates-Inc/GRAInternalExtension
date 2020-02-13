/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*               - Added field "Default Type", and "Default No." according to definition from NAV 2009
*/

pageextension 50107 pXJobTaskLines extends "Job Task Lines"
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