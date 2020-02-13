/**
*   Documentation Section
*       GRALE01 - 12/23/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added field "Timesheet Page ID" according to definition from NAV 2009
*/

tableextension 50107 tXJobJournalTemplate extends "Job Journal Template"
{
    fields
    {
        field(50000; "Timesheet Page ID"; Integer)
        {
            Caption = 'Timesheet Page ID';
            FieldClass = Normal;
            //TableRelation = Object.ID where(Type = const(Page)); //GRALE02 - This doesnt work, so simply remove it
        }
    }

}