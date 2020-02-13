/**
* This codeunit is meant to call any trigger related to Job Journal Line table extensions (tXJobJournalLine.al)
*
*   Documentation Section
*       GRALE01 - 12/23/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created codeunit.
*/
codeunit 50100 CutXJobJournalLine
{
    [EventSubscriber(ObjectType::Table, Database::"Job Journal Line", 'OnBeforeUpdateAllAmounts', '', false, false)]
    local procedure OnBeforeUpdateAllAmounts(var JobJournalLine: Record "Job Journal Line");
    begin
        if JobJournalLine.Chargeable = false then begin
            JobJournalLine."Unit Price" := 0;
            JobJournalLine.InitRoundingPrecisions();
            JobJournalLine.UpdateUnitCost();
            JobJournalLine.UpdateTotalCost();
        end;

    end;

    //[EventSubscriber(ObjectType::Table, Database::"Job Journal Line", 'OnAfterSetUpNewLine', '', false, false)]
    [EventSubscriber(ObjectType::Table, Database::"Job Journal Line", 'OnAfterSetUpNewLine', '', false, false)]
    local procedure OnAfterSetUpNewLine(var JobJournalLine: Record "Job Journal Line"; LastJobJournalLine: Record "Job Journal Line"; JobJournalTemplate: Record "Job Journal Template"; JobJournalBatch: Record "Job Journal Batch");
    var
        JobJnlLine_lRec: Record "Job Journal Line";
    begin
        JobJnlLine_lRec.SETRANGE("Journal Template Name", JobJournalBatch."Journal Template Name");
        JobJnlLine_lRec.SETRANGE("Journal Batch Name", JobJournalBatch."Name");
        if JobJnlLine_lRec.FindFirst then begin
            JobJournalLine."Document Date" := LastJobJournalLine."Document Date";
        end else
            JobJournalLine."Document Date" := WorkDate;

        JobJournalLine.Type := JobJournalBatch."Default Type";
        JobJournalLine."No." := JobJournalBatch."Default No.";
    end;
    /*local procedure OnAfterSetUpNewLine(var JobJournalLine: Record "Job Journal Line"; LastJobJournalLine: Record "Job Journal Line");
    var
        JobJnlTemplate_lRec: Record "Job Journal Template";
        JobJnlBatch_lRec: Record "Job Journal Batch";
        JobJnlLine_lRec: Record "Job Journal Line";
    begin
        JobJnlTemplate_lRec.GET(LastJobJournalLine."Journal Template Name");
        JobJnlBatch_lRec.GET(LastJobJournalLine."Journal Template Name", LastJobJournalLine."Journal Batch Name");
        JobJnlLine_lRec.SETRANGE("Journal Template Name", LastJobJournalLine."Journal Template Name");
        JobJnlLine_lRec.SETRANGE("Journal Batch Name", LastJobJournalLine."Journal Batch Name");
        if JobJnlLine_lRec.FindFirst then begin
            JobJournalLine."Document Date" := LastJobJournalLine."Document Date";
        end;

        JobJournalLine.Type := JobJnlBatch_lRec."Default Type";
        JobJournalLine."No." := JobJnlBatch_lRec."Default No.";

    end;*/

}