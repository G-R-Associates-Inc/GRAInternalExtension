/**
* This codeunit is meant to call any trigger related to Transfer Custom Fields Codeunit in NAV 2009
* Note: The triggers have been moved to the tables, so we're subsribing to the related tables
*   Documentation Section
*       GRALE01 - 12/24/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created codeunit.
*/
codeunit 50105 CutXJobLedgerEntry
{
    /*[EventSubscriber(ObjectType::Table, Database::"Job Ledger Entry", '', '', false, false)]
    local procedure OnAfterCopyFromResJnlLine(var ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line");
    begin
        ResLedgerEntry.Chargeable := ResJournalLine.Chargeable;
        ResLedgerEntry.Modify();
    end;*/
}