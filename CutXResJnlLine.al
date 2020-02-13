/**
* This codeunit is meant to call any trigger related to Transfer Custom Fields Codeunit in NAV 2009
* Note: The triggers have been moved to the tables, so we're subsribing to the related tables
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created codeunit.
*/
codeunit 50103 CutXResJnlLine
{
    [EventSubscriber(ObjectType::Table, Database::"Res. Journal Line", 'OnAfterCopyResJnlLineFromJobJnlLine', '', false, false)]
    local procedure OnAfterCopyResJnlLineFromJobJnlLine(var ResJnlLine: Record "Res. Journal Line"; var JobJnlLine: Record "Job Journal Line");
    begin
        ResJnlLine.Chargeable := JobJnlLine.Chargeable;
    end;
}