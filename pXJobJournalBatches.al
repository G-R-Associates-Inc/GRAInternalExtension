/**
*   Documentation Section
*       GRALE01 - 12/27/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*               - Added field "Default Type", and "Default No." according to definition from NAV 2009
*/

pageextension 50106 pXJobJournalBatches extends "Job Journal Batches"
{
    layout
    {
        addafter("Posting No. Series")
        {
            field("Default Type"; "Default Type")
            {

            }

            field("Default No."; "Default No.")
            {


            }
        }
    }
}