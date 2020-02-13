/**
* This codeunit is meant to call any trigger related to Job Create-Invoice Codeunit in Base NAV
*
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created codeunit.
*/
codeunit 50101 CuXJobCreateInvoice
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", 'OnAfterCreateSalesLine', '', false, false)]
    local procedure OnAfterCreateSalesLine(var SalesLine: Record "Sales Line"; JobPlanningLine: Record "Job Planning Line");
    begin
        SalesLine."Work Date" := JobPlanningLine."Planning Date";
        //SalesLine.Modify();
    end;
}