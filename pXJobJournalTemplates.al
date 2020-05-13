/**
*   Documentation Section
*       GRALE01 - 01/09/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension to add newly added fields in tableextension
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*                - Added ApplicationArea to Timesheet Page ID, because it was not showing on the page
*/

pageextension 50109 pXJobJournalTemplates extends "Job Journal Templates"
{
    layout
    {
        addafter("Posting No. Series")
        {
            field("Timesheet Page ID"; "Timesheet Page ID")
            {
                ApplicationArea = Jobs; //GRALE02 - Add
            }
        }
    }

}