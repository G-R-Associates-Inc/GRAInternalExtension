/**
*   Documentation Section
*       GRALE01 - 01/09/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension to add newly added fields in tableextension
*/

pageextension 50109 pXJobJournalTemplates extends "Job Journal Templates"
{
    layout
    {
        addafter("Posting No. Series")
        {
            field("Timesheet Page ID"; "Timesheet Page ID")
            {

            }
        }
    }

}