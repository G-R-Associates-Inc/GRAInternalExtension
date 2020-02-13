/**
*   Documentation Section
*       GRALE01 - 12/23/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created tableextension.
*               - Added fields "Submitted", and "Approved" according to definition from NAV 2009
*/

tableextension 50108 tXJobJournalLine extends "Job Journal Line"
{
    fields
    {
        field(50000; "Submitted"; Boolean)
        {
            Caption = 'Submitted';
            FieldClass = Normal;
        }

        field(50001; "Approved"; Boolean)
        {
            Caption = 'Approved';
            FieldClass = Normal;
        }

        modify("Job Task No.")
        {
            trigger OnAfterValidate();
            var
                JobJnlBatch_lRec: Record "Job Journal Batch";
                JobTask: Record "Job Task";
            begin
                JobJnlBatch_lRec.Get("Journal Template Name", "Journal Batch Name");
                Type := JobJnlBatch_lRec."Default Type";
                Validate("No.", JobJnlBatch_lRec."Default No.");

                if ("Job Task No." = '') or (("Job Task No." <> xRec."Job Task No.") and (xRec."Job Task No." <> '')) then begin
                    Validate("No.", '');
                    exit;
                end;
                JobTask.Get("Job No.", "Job Task No.");
                JobTask.TestField("Job Task Type", JobTask."Job Task Type"::Posting);
                CurrFieldNo := FieldNo("Job Task No.");
                Validate(rec.Chargeable, JobTask.Chargeable);
                Rec.Description := JobTask.Description;
            end;
        }
    }
}