/**
*   Documentation Section
*       GRALE01 - 01/09/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created pageextension.
*/

pageextension 50110 pXJobTaskLinesSubform extends "Job Task Lines Subform"
{
    layout
    {
        addafter("Contract (Invoiced Price)")
        {
            field(Chargeable; Chargeable)
            {

            }
        }
    }
}