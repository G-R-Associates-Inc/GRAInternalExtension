/**
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added fields "Default Type", "Default No.", and "No. of Entries" according to definition from NAV 2009
*/
tableextension 50109 tXJobJournalBatch extends "Job Journal Batch"
{
    fields
    {
        field(50000; "Default Type"; Option)
        {
            Caption = 'Default Type';
            FieldClass = Normal;
            OptionMembers = Resource,Item,"G/L Account";
            OptionCaption = 'Resource,Item,G/L Account';
        }

        field(50001; "Default No."; Code[20])
        {
            Caption = 'Default No.';
            FieldClass = Normal;
            TableRelation = If ("Default Type" = const(Resource)) Resource else
            if ("Default Type" = const(Item)) Item else
            if ("Default Type" = const("G/L Account")) "G/L Account";

        }

        field(50002; "No. of Entries"; Integer)
        {
            Caption = 'No. of Entries';
            FieldClass = Normal;
        }
    }
}