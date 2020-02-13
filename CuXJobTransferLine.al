codeunit 50107 CuXJobTransferLine
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Transfer Line", 'OnAfterFromJnlLineToLedgEntry', '', false, false)]
    local procedure OnAfterFromJnlLineToLedgEntry(JobJournalLine: Record "Job Journal Line"; var JobLedgerEntry: Record "Job Ledger Entry");
    begin
        JobLedgerEntry.Chargeable := JobJournalLine.Chargeable;
    end;
}