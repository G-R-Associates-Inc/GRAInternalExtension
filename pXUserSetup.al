/**
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*               - Added fields "Jobs Manager", and "Linked Resource No." according to definition from NAV 2009
*/
pageextension 50102 pXUserSetup extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("Linked Resource No."; "Linked Resource No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Linked Resource No.';
            }
        }

        addafter("Service Resp. Ctr. Filter")
        {
            field("Jobs Manager"; "Jobs Manager")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Jobs Manager';
            }
        }
    }
}