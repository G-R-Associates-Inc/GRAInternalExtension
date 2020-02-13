/**
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added field "Chargeable". It was removed sometime after Nav 2009
*/
tableextension 50111 tXResJournalLine extends "Res. Journal Line"
{
    fields
    {
        field(50000; "Chargeable"; Boolean)
        {
            Caption = 'Chargeable';
            FieldClass = Normal;
        }
    }
}