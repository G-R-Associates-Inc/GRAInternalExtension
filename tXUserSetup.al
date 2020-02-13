/**
*   Documentation Section
*       GRALE01 - 12/23/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added fields "Job Manager", and "Linked Resource No." according to definition from NAV 2009
*/

tableextension 50102 tXUserSetup extends "User Setup"
{
    fields
    {
        field(50000; "Jobs Manager"; Boolean)
        {
            Caption = 'Jobs Manager';
            FieldClass = Normal;
        }

        field(50001; "Linked Resource No."; Code[20])
        {
            Caption = 'Linked Resource No.';
            FieldClass = Normal;
            TableRelation = Resource;

        }
    }

}