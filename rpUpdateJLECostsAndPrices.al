/**
*   Documentation Section
*       GRALE01 - 1/7/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created report according to definition from NAV 2009 (ID 50000).
*/

report 50102 "Update JLE Costs and Prices"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = Where(Type = const(Resource));
            RequestFilterFields = "Entry No.", "Job No.", "No.";

            trigger OnAfterGetRecord();
            begin
                "Unit Price (LCY)" := "Unit Price";
                "Total Price" := "Unit Price" * Quantity;
                "Total Price (LCY)" := "Unit Price" * Quantity;
                "Line Amount" := "Unit Price" * Quantity;
                "Line Amount (LCY)" := "Unit Price" * Quantity;

                Modify;

                if "Total Price" <> 0 then begin
                    Chargeable := true;
                    Modify;
                end;
            end;
        }
    }

    VAR
        Resource: Record Resource;

}