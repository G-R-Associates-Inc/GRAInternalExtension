/**
*   Documentation Section
*       GRALE01 - 01/09/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*
*       GRALE02 - 05/13/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Added ApplicationArea property to fields and actions
*/

pageextension 50110 pXJobTaskLinesSubform extends "Job Task Lines Subform"
{
    layout
    {
        addafter("Contract (Invoiced Price)")
        {
            field(Chargeable; Chargeable)
            {
                ApplicationArea = All; //GRALE02 - Add
            }
        }
    }
}