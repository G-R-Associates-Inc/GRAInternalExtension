/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*               - Added field "Default Type", and "Default No." according to definition from NAV 2009
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/

pageextension 50106 pXJobJournalBatches extends "Job Journal Batches"
{
    layout
    {
        addafter("Posting No. Series")
        {
            field("Default Type"; "Default Type")
            {
                ApplicationArea = All; //GRALE02 - Add
            }

            field("Default No."; "Default No.")
            {
                ApplicationArea = All; //GRALE02 - Add
            }
        }
    }
}