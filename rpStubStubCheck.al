/**
*   Documentation Section
*       GRALE01 - 1/6/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created report according to definition from NAV 2009 (ID 10411).
*       TODO: Fix error on DimensionManagement 
*/

report 50105 "Check (Stub/Stub/Check) Custom"
{
    Permissions = tabledata "Bank Account" = m;
    CaptionML = ENU = 'Check (Stub/Stub/Check)',
               ESM = 'Cheque (Serie/Serie/Cheque)',
               FRC = 'ChŠque (Talon/Talon/ChŠque)',
               ENC = 'Cheque (Stub/Stub/Cheque)';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportsLayout/StubStubCheck.rdl';

    dataset
    {
        dataitem(VoidGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";

            trigger OnPreDataItem();
            begin
                if CurrReport.PREVIEW then
                    Error(Text000);

                if UseCheckNo = '' then
                    Error(Text001);

                if INCSTR(UseCheckNo) = '' then
                    Error(USText004);

                if TestPrint then
                    CurrReport.Break;

                if not ReprintChecks then
                    CurrReport.Break;

                if (GETFILTER("Line No.") <> '') or (GETFILTER("Document No.") <> '') then
                    Error(Text002, FIELDCAPTION("Line No."), FIELDCAPTION("Document No."));
                SetRange("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SetRange("Check Printed", true);
            end;

            trigger OnAfterGetRecord();
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;


        }

        dataitem(TestGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");

            trigger OnPreDataItem();
            begin
                if TestPrint then begin
                    CompanyInfo.Get;
                    BankAcc2.Get(BankAcc2."No.");
                    BankCurrencyCode := BankAcc2."Currency Code";
                end;

                if TestPrint then
                    CurrReport.Break;
                CompanyInfo.Get;
                BankAcc2.Get(BankAcc2."No.");
                BankCurrencyCode := BankAcc2."Currency Code";

                if BankAcc2."Country/Region Code" <> 'CA' then
                    CurrReport.Break;
                BankAcc2.TestField(Blocked, false);
                COPY(VoidGenJnlLine);
                BankAcc2.Get(BankAcc2."No.");
                BankAcc2.TestField(Blocked, false);
                SetRange("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SetRange("Check Printed", false);
            end;

            trigger OnAfterGetRecord();
            begin
                if Amount = 0 then
                    CurrReport.SKIP;

                TestField("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                if "Bal. Account No." <> BankAcc2."No." then
                    CurrReport.SKIP;
                case "Account Type" of
                    "Account Type"::"G/L Account":
                        begin
                            if BankAcc2."Check Date Format" = BankAcc2."Check Date Format"::" " then
                                Error(USText006, BankAcc2.FIELDCAPTION("Check Date Format"), BankAcc2.TABLECAPTION, BankAcc2."No.");
                            if BankAcc2."Bank Communication" = BankAcc2."Bank Communication"::"S Spanish" then
                                Error(USText007, BankAcc2.FIELDCAPTION("Bank Communication"), BankAcc2.TABLECAPTION, BankAcc2."No.");
                        end;
                    "Account Type"::Customer:
                        begin
                            Cust.Get("Account No.");
                            if Cust."Check Date Format" = Cust."Check Date Format"::" " then
                                Error(USText006, Cust.FIELDCAPTION("Check Date Format"), Cust.TABLECAPTION, "Account No.");
                            if Cust."Bank Communication" = Cust."Bank Communication"::"S Spanish" then
                                Error(USText007, Cust.FIELDCAPTION("Bank Communication"), Cust.TABLECAPTION, "Account No.");
                        end;
                    "Account Type"::Vendor:
                        begin
                            Vend.Get("Account No.");
                            if Vend."Check Date Format" = Vend."Check Date Format"::" " then
                                Error(USText006, Vend.FIELDCAPTION("Check Date Format"), Vend.TABLECAPTION, "Account No.");
                            if Vend."Bank Communication" = Vend."Bank Communication"::"S Spanish" then
                                Error(USText007, Vend.FIELDCAPTION("Bank Communication"), Vend.TABLECAPTION, "Account No.");
                        end;
                    "Account Type"::"Bank Account":
                        begin
                            BankAcc.Get("Account No.");
                            if BankAcc."Check Date Format" = BankAcc."Check Date Format"::" " then
                                Error(USText006, BankAcc.FIELDCAPTION("Check Date Format"), BankAcc.TABLECAPTION, "Account No.");
                            if BankAcc."Bank Communication" = BankAcc."Bank Communication"::"S Spanish" then
                                Error(USText007, BankAcc.FIELDCAPTION("Bank Communication"), BankAcc.TABLECAPTION, "Account No.");
                        end;
                end;
            end;
        }

        dataitem(GenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");

            column(GenJnlLine_Journal_Template_Name; "Journal Template Name")
            {

            }

            column(GenJnlLine_Journal_Batch_Name; "Journal Batch Name")
            {

            }

            column(GenJnlLine_Line_No_; "Line No.")
            {

            }

            dataitem(CheckPages; Integer)
            {
                DataItemTableView = sorting(Number);

                column(CheckToAddr_1_; CheckToAddr[1])
                {

                }

                column(CheckDateText; CheckDateText)
                {

                }

                column(CheckNoText; CheckNoText)
                {

                }

                column(PageNo; PageNo)
                {

                }

                column(CheckPages_Number; Number)
                {

                }

                column(CheckNoTextCaption; CheckNoTextCaptionLbl)
                {

                }
                dataitem(PrintSettledLoop; Integer)
                {
                    DataItemTableView = sorting(Number);
                    column(PreprintedStub; PreprintedStub)
                    {

                    }

                    column(LineAmount; LineAmount)
                    {

                    }

                    column(LineDiscount; LineDiscount)
                    {

                    }

                    column(LineAmount___LineDiscount; LineAmount + LineDiscount)
                    {

                    }

                    column(DocNo; DocNo)
                    {

                    }

                    column(DocDate; DocDate)
                    {

                    }

                    column(PostingDesc; PostingDesc)
                    {

                    }

                    column(PrintSettledLoop_Number; Number)
                    {

                    }

                    column(LineAmountCaption; LineAmountCaptionLbl)
                    {

                    }
                    column(LineDiscountCaption; LineDiscountCaptionLbl)
                    {

                    }

                    column(DocNoCaption; DocNoCaptionLbl)
                    {

                    }

                    column(DocDateCaption; DocDateCaptionLbl)
                    {

                    }
                    column(Posting_DescriptionCaption; Posting_DescriptionCaptionLbl)
                    {

                    }

                    column(AmountCaption; AmountCaptionLbl)
                    {

                    }

                    trigger OnPreDataItem();
                    begin
                        if not TestPrint then
                            if FirstPage then begin
                                FoundLast := true;
                                case ApplyMethod of
                                    ApplyMethod::OneLineOneEntry:
                                        FoundLast := false;
                                    ApplyMethod::OneLineID:
                                        case BalancingType of
                                            BalancingType::Customer:
                                                begin
                                                    CustLedgEntry.Reset;
                                                    CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                                                    CustLedgEntry.SetRange("Customer No.", BalancingNo);
                                                    CustLedgEntry.SetRange(Open, true);
                                                    CustLedgEntry.SetRange(Positive, true);
                                                    CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := not CustLedgEntry.Find('-');
                                                    if FoundLast then begin
                                                        CustLedgEntry.SetRange(Positive, false);
                                                        FoundLast := not CustLedgEntry.Find('-');
                                                        FoundNegative := true;
                                                    end else
                                                        FoundNegative := false;
                                                end;
                                            BalancingType::Vendor:
                                                begin
                                                    VendLedgEntry.Reset;
                                                    VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                                                    VendLedgEntry.SetRange("Vendor No.", BalancingNo);
                                                    VendLedgEntry.SetRange(Open, true);
                                                    VendLedgEntry.SetRange(Positive, true);
                                                    VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := not VendLedgEntry.Find('-');
                                                    if FoundLast then begin
                                                        VendLedgEntry.SetRange(Positive, false);
                                                        FoundLast := not VendLedgEntry.Find('-');
                                                        FoundNegative := true;
                                                    end else
                                                        FoundNegative := false;
                                                end;
                                        end;
                                    ApplyMethod::MoreLinesOneEntry:
                                        FoundLast := false;
                                end;
                            end
                            else
                                FoundLast := false;


                        if PreprintedStub then begin
                            TotalText := '';
                        end else begin
                            TotalText := Text019;
                            Stub2DocNoHeader := USText011;
                            Stub2DocDateHeader := USText012;
                            Stub2AmountHeader := USText013;
                            Stub2DiscountHeader := USText014;
                            Stub2NetAmountHeader := USText015;
                            Stub2PostingDescHeader := USText017;
                        end;
                        if GenJnlLine."Currency Code" <> '' then
                            NetAmount := STRSUBSTNO(Text063, GenJnlLine."Currency Code")
                        else begin
                            GLSetup.Get;
                            NetAmount := STRSUBSTNO(Text063, GLSetup."LCY Code");
                        end;

                        PageNo := PageNo + 1;
                    end;

                    trigger OnAfterGetRecord();
                    begin
                        if not TestPrint then begin
                            if FoundLast then begin
                                if RemainingAmount <> 0 then begin
                                    DocType := Text015;
                                    DocNo := '';
                                    ExtDocNo := '';
                                    LineAmount := RemainingAmount;
                                    LineAmount2 := RemainingAmount;
                                    CurrentLineAmount := LineAmount2;
                                    LineDiscount := 0;
                                    RemainingAmount := 0;

                                    PostingDesc := CheckToAddr[1];

                                end else
                                    CurrReport.Break;
                            end else begin
                                case ApplyMethod of
                                    ApplyMethod::OneLineOneEntry:
                                        begin
                                            case BalancingType of
                                                BalancingType::Customer:
                                                    begin
                                                        CustLedgEntry.Reset;
                                                        CustLedgEntry.SetCurrentKey("Document No.");
                                                        CustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        CustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        CustLedgEntry.SetRange("Customer No.", BalancingNo);
                                                        CustLedgEntry.Find('-');
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                    end;
                                                BalancingType::Vendor:
                                                    begin
                                                        VendLedgEntry.Reset;
                                                        VendLedgEntry.SetCurrentKey("Document No.");
                                                        VendLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        VendLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        VendLedgEntry.SetRange("Vendor No.", BalancingNo);
                                                        VendLedgEntry.Find('-');
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                    end;
                                            end;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                            FoundLast := true;
                                        end;
                                    ApplyMethod::OneLineID:
                                        begin
                                            case BalancingType of
                                                BalancingType::Customer:
                                                    begin
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                        FoundLast := (CustLedgEntry.Next = 0) or (RemainingAmount <= 0);
                                                        if FoundLast and not FoundNegative then begin
                                                            CustLedgEntry.SetRange(Positive, false);
                                                            FoundLast := not CustLedgEntry.Find('-');
                                                            FoundNegative := true;
                                                        end;
                                                    end;
                                                BalancingType::Vendor:
                                                    begin
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                        FoundLast := (VendLedgEntry.Next = 0) or (RemainingAmount <= 0);
                                                        if FoundLast and not FoundNegative then begin
                                                            VendLedgEntry.SetRange(Positive, false);
                                                            FoundLast := not VendLedgEntry.Find('-');
                                                            FoundNegative := true;
                                                        end;
                                                    end;
                                            end;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2
                                        end;
                                    ApplyMethod::MoreLinesOneEntry:
                                        begin
                                            CurrentLineAmount := GenJnlLine2.Amount;
                                            LineAmount2 := CurrentLineAmount;
                                            if GenJnlLine2."Applies-to ID" <> '' then
                                                Error(Text016 + Text017);
                                            GenJnlLine2.TestField("Check Printed", false);
                                            GenJnlLine2.TestField("Bank Payment Type", GenJnlLine2."Bank Payment Type"::"Computer Check");

                                            if GenJnlLine2."Applies-to Doc. No." = '' then begin
                                                DocType := Text015;
                                                DocNo := '';
                                                ExtDocNo := '';
                                                LineAmount := CurrentLineAmount;
                                                LineDiscount := 0;
                                                PostingDesc := GenJnlLine2.Description;
                                            end else begin
                                                case BalancingType of
                                                    BalancingType::"G/L Account":
                                                        begin
                                                            DocType := Format(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                            PostingDesc := GenJnlLine2.Description;
                                                        end;
                                                    BalancingType::Customer:
                                                        begin
                                                            CustLedgEntry.Reset;
                                                            CustLedgEntry.SetCurrentKey("Document No.");
                                                            CustLedgEntry.SetRange("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            CustLedgEntry.SetRange("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            CustLedgEntry.SetRange("Customer No.", BalancingNo);
                                                            CustLedgEntry.Find('-');
                                                            CustUpdateAmounts(CustLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        end;
                                                    BalancingType::Vendor:
                                                        begin
                                                            VendLedgEntry.Reset;
                                                            VendLedgEntry.SetCurrentKey("Document No.");
                                                            VendLedgEntry.SetRange("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            VendLedgEntry.SetRange("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            VendLedgEntry.SetRange("Vendor No.", BalancingNo);
                                                            VendLedgEntry.Find('-');
                                                            VendUpdateAmounts(VendLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        end;
                                                    BalancingType::"Bank Account":
                                                        begin
                                                            DocType := Format(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                            PostingDesc := GenJnlLine2.Description;
                                                        end;
                                                end;
                                            end;
                                            FoundLast := GenJnlLine2.Next = 0;
                                        end;
                                end;
                            end;

                            TotalLineAmount := TotalLineAmount + CurrentLineAmount;
                            TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        end else begin
                            if FoundLast then
                                CurrReport.Break;
                            FoundLast := true;
                            DocType := Text018;
                            DocNo := Text010;
                            ExtDocNo := Text010;
                            LineAmount := 0;
                            LineDiscount := 0;
                            PostingDesc := '';

                        end;

                        if DocNo = '' then
                            CurrencyCode2 := GenJnlLine."Currency Code";

                        Stub2LineNo := Stub2LineNo + 1;
                        Stub2DocNo[Stub2LineNo] := DocNo;
                        Stub2DocDate[Stub2LineNo] := DocDate;
                        Stub2LineAmount[Stub2LineNo] := LineAmount;
                        Stub2LineDiscount[Stub2LineNo] := LineDiscount;
                        Stub2PostingDescription[Stub2LineNo] := PostingDesc;
                    end;
                }

                dataitem(PrintCheck; Integer)
                {
                    DataItemTableView = sorting(Number);

                    Column(PrnChkCheckToAddr_CheckStyle__CA_5_; PrnChkCheckToAddr[CheckStyle::CA, 5])
                    {

                    }

                    Column(PrnChkCheckToAddr_CheckStyle__CA_4_; PrnChkCheckToAddr[CheckStyle::CA, 4])
                    {

                    }


                    Column(PrnChkCheckToAddr_CheckStyle__CA_3_; PrnChkCheckToAddr[CheckStyle::CA, 3])
                    {

                    }


                    Column(PrnChkCheckToAddr_CheckStyle__CA_2_; PrnChkCheckToAddr[CheckStyle::CA, 2])
                    {

                    }


                    Column(PrnChkCheckToAddr_CheckStyle__CA_1_; PrnChkCheckToAddr[CheckStyle::CA, 1])
                    {

                    }


                    Column(PrnChkCheckAmountText_CheckStyle__US_; PrnChkCheckAmountText[CheckStyle::US])
                    {

                    }


                    Column(PrnChkCheckDateText_CheckStyle__US_; PrnChkCheckDateText[CheckStyle::US])
                    {

                    }


                    Column(PrnChkDescriptionLine_CheckStyle__US_2_; PrnChkDescriptionLine[CheckStyle::US, 2])
                    {

                    }


                    Column(PrnChkDescriptionLine_CheckStyle__US_1_; PrnChkDescriptionLine[CheckStyle::US, 1])
                    {

                    }


                    Column(PrnChkCheckToAddr_CheckStyle__US_1_; PrnChkCheckToAddr[CheckStyle::US, 1])
                    {

                    }


                    Column(PrnChkCheckToAddr_CheckStyle__US_2_; PrnChkCheckToAddr[CheckStyle::US, 2])
                    {

                    }


                    Column(PrnChkCheckToAddr_CheckStyle__US_4_; PrnChkCheckToAddr[CheckStyle::US, 4])
                    {

                    }


                    Column(PrnChkCheckToAddr_CheckStyle__US_3_; PrnChkCheckToAddr[CheckStyle::US, 3])
                    {

                    }


                    Column(PrnChkCheckToAddr_CheckStyle__US_5_; PrnChkCheckToAddr[CheckStyle::US, 5])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__US_4_; PrnChkCompanyAddr[CheckStyle::US, 4])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__US_6_; PrnChkCompanyAddr[CheckStyle::US, 6])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__US_5_; PrnChkCompanyAddr[CheckStyle::US, 5])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__US_3_; PrnChkCompanyAddr[CheckStyle::US, 3])
                    {

                    }


                    Column(PrnChkCheckNoText_CheckStyle__US_; PrnChkCheckNoText[CheckStyle::US])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__US_2_; PrnChkCompanyAddr[CheckStyle::US, 2])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__US_1_; PrnChkCompanyAddr[CheckStyle::US, 1])
                    {

                    }


                    Column(TotalLineAmount; TotalLineAmount)
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(TotalText; TotalText)
                    {

                    }


                    Column(PrnChkVoidText_CheckStyle__US_; PrnChkVoidText[CheckStyle::US])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__CA_1_; PrnChkCompanyAddr[CheckStyle::CA, 1])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__CA_2_; PrnChkCompanyAddr[CheckStyle::CA, 2])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__CA_3_; PrnChkCompanyAddr[CheckStyle::CA, 3])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__CA_4_; PrnChkCompanyAddr[CheckStyle::CA, 4])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__CA_5_; PrnChkCompanyAddr[CheckStyle::CA, 5])
                    {

                    }


                    Column(PrnChkCompanyAddr_CheckStyle__CA_6_; PrnChkCompanyAddr[CheckStyle::CA, 6])
                    {

                    }


                    Column(PrnChkDescriptionLine_CheckStyle__CA_1_; PrnChkDescriptionLine[CheckStyle::CA, 1])
                    {

                    }


                    Column(PrnChkDescriptionLine_CheckStyle__CA_2_; PrnChkDescriptionLine[CheckStyle::CA, 2])
                    {

                    }


                    Column(PrnChkCheckDateText_CheckStyle__CA_; PrnChkCheckDateText[CheckStyle::CA])
                    {

                    }


                    Column(PrnChkDateIndicator_CheckStyle__CA_; PrnChkDateIndicator[CheckStyle::CA])
                    {

                    }


                    Column(PrnChkCheckAmountText_CheckStyle__CA_; PrnChkCheckAmountText[CheckStyle::CA])
                    {

                    }


                    Column(PrnChkVoidText_CheckStyle__CA_; PrnChkVoidText[CheckStyle::CA])
                    {

                    }


                    Column(PrnChkCurrencyCode_CheckStyle__CA_; PrnChkCurrencyCode[CheckStyle::CA])
                    {

                    }


                    Column(PrnChkCurrencyCode_CheckStyle__US_; PrnChkCurrencyCode[CheckStyle::US])
                    {

                    }


                    Column(CheckNoText_Control1480000; CheckNoText)
                    {

                    }


                    Column(CheckDateText_Control1480021; CheckDateText)
                    {

                    }


                    Column(CheckToAddr_1__Control1480022; CheckToAddr[1])
                    {

                    }


                    Column(Stub2DocNoHeader; Stub2DocNoHeader)
                    {

                    }


                    Column(Stub2DocDateHeader; Stub2DocDateHeader)
                    {

                    }


                    Column(Stub2AmountHeader; Stub2AmountHeader)
                    {

                    }


                    Column(Stub2DiscountHeader; Stub2DiscountHeader)
                    {

                    }


                    Column(Stub2NetAmountHeader; Stub2NetAmountHeader)
                    {

                    }


                    Column(Stub2LineAmount_1_; Stub2LineAmount[1])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_1_; Stub2LineDiscount[1])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_1____Stub2LineDiscount_1_; Stub2LineAmount[1] + Stub2LineDiscount[1])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_1_; Stub2DocDate[1])
                    {

                    }


                    Column(Stub2DocNo_1_; Stub2DocNo[1])
                    {

                    }


                    Column(Stub2LineAmount_2_; Stub2LineAmount[2])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_2_; Stub2LineDiscount[2])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_2____Stub2LineDiscount_2_; Stub2LineAmount[2] + Stub2LineDiscount[2])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_2_; Stub2DocDate[2])
                    {

                    }


                    Column(Stub2DocNo_2_; Stub2DocNo[2])
                    {

                    }


                    Column(Stub2LineAmount_3_; Stub2LineAmount[3])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_3_; Stub2LineDiscount[3])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_3____Stub2LineDiscount_3_; Stub2LineAmount[3] + Stub2LineDiscount[3])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_3_; Stub2DocDate[3])
                    {

                    }


                    Column(Stub2DocNo_3_; Stub2DocNo[3])
                    {

                    }


                    Column(Stub2LineAmount_4_; Stub2LineAmount[4])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_4_; Stub2LineDiscount[4])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_4____Stub2LineDiscount_4_; Stub2LineAmount[4] + Stub2LineDiscount[4])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_4_; Stub2DocDate[4])
                    {

                    }


                    Column(Stub2DocNo_4_; Stub2DocNo[4])
                    {

                    }


                    Column(Stub2LineAmount_5_; Stub2LineAmount[5])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_5_; Stub2LineDiscount[5])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_5____Stub2LineDiscount_5_; Stub2LineAmount[5] + Stub2LineDiscount[5])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_5_; Stub2DocDate[5])
                    {

                    }


                    Column(Stub2DocNo_5_; Stub2DocNo[5])
                    {

                    }


                    Column(Stub2LineAmount_6_; Stub2LineAmount[6])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_6_; Stub2LineDiscount[6])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_6____Stub2LineDiscount_6_; Stub2LineAmount[6] + Stub2LineDiscount[6])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_6_; Stub2DocDate[6])
                    {

                    }


                    Column(Stub2DocNo_6_; Stub2DocNo[6])
                    {

                    }


                    Column(Stub2LineAmount_7_; Stub2LineAmount[7])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_7_; Stub2LineDiscount[7])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_7____Stub2LineDiscount_7_; Stub2LineAmount[7] + Stub2LineDiscount[7])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_7_; Stub2DocDate[7])
                    {

                    }


                    Column(Stub2DocNo_7_; Stub2DocNo[7])
                    {

                    }


                    Column(Stub2LineAmount_8_; Stub2LineAmount[8])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_8_; Stub2LineDiscount[8])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_8____Stub2LineDiscount_8_; Stub2LineAmount[8] + Stub2LineDiscount[8])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_8_; Stub2DocDate[8])
                    {

                    }


                    Column(Stub2DocNo_8_; Stub2DocNo[8])
                    {

                    }


                    Column(Stub2LineAmount_9_; Stub2LineAmount[9])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_9_; Stub2LineDiscount[9])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_9____Stub2LineDiscount_9_; Stub2LineAmount[9] + Stub2LineDiscount[9])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_9_; Stub2DocDate[9])
                    {

                    }


                    Column(Stub2DocNo_9_; Stub2DocNo[9])
                    {

                    }


                    Column(Stub2LineAmount_10_; Stub2LineAmount[10])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineDiscount_10_; Stub2LineDiscount[10])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2LineAmount_10____Stub2LineDiscount_10_; Stub2LineAmount[10] + Stub2LineDiscount[10])
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(Stub2DocDate_10_; Stub2DocDate[10])
                    {

                    }


                    Column(Stub2DocNo_10_; Stub2DocNo[10])
                    {

                    }


                    Column(TotalLineAmount_Control1480082; TotalLineAmount)
                    {
                        AutoFormatType = 1;
                        AutoFormatExpression = GenJnlLine."Currency Code";
                    }


                    Column(TotalText_Control1480083; TotalText)
                    {

                    }


                    Column(Stub2PostingDescHeader; Stub2PostingDescHeader)
                    {

                    }


                    Column(Stub2PostingDesc_1_; Stub2PostingDescription[1])
                    {

                    }


                    Column(Stub2PostingDesc_2_; Stub2PostingDescription[2])
                    {

                    }


                    Column(Stub2PostingDesc_4_; Stub2PostingDescription[4])
                    {

                    }


                    Column(Stub2PostingDesc_3_; Stub2PostingDescription[3])
                    {

                    }


                    Column(Stub2PostingDesc_8_; Stub2PostingDescription[8])
                    {

                    }


                    Column(Stub2PostingDesc_7_; Stub2PostingDescription[7])
                    {

                    }


                    Column(Stub2PostingDesc_6_; Stub2PostingDescription[6])
                    {

                    }


                    Column(Stub2PostingDesc_5_; Stub2PostingDescription[5])
                    {

                    }


                    Column(Stub2PostingDesc_10_; Stub2PostingDescription[10])
                    {

                    }


                    Column(Stub2PostingDesc_9_; Stub2PostingDescription[9])
                    {

                    }


                    Column(CheckToAddr_5_; CheckToAddr[5])
                    {

                    }


                    Column(CheckToAddr_4_; CheckToAddr[4])
                    {

                    }


                    Column(CheckToAddr_3_; CheckToAddr[3])
                    {

                    }


                    Column(CheckToAddr_2_; CheckToAddr[2])
                    {

                    }


                    Column(CheckToAddr_01_; CheckToAddr[1])
                    {

                    }


                    Column(VoidText; VoidText)
                    {

                    }


                    Column(BankCurrencyCode; BankCurrencyCode)
                    {

                    }


                    Column(DollarSignBefore_CheckAmountText_DollarSignAfter; DollarSignBefore + CheckAmountText + DollarSignAfter)
                    {

                    }


                    Column(DescriptionLine_1__; DescriptionLine[1])
                    {

                    }


                    Column(DescriptionLine_2__; DescriptionLine[2])
                    {

                    }


                    Column(DateIndicator; DateIndicator)
                    {

                    }


                    Column(CheckDateText_Control1020013; CheckDateText)
                    {

                    }


                    Column(CheckNoText_Control1020014; CheckNoText)
                    {

                    }


                    Column(CompanyAddr_6_; CompanyAddr[6])
                    {

                    }


                    Column(CompanyAddr_5_; CompanyAddr[5])
                    {

                    }


                    Column(CompanyAddr_4_; CompanyAddr[4])
                    {

                    }


                    Column(CompanyAddr_3_; CompanyAddr[3])
                    {

                    }


                    Column(CompanyAddr_2_; CompanyAddr[2])
                    {

                    }


                    Column(CompanyAddr_1_; CompanyAddr[1])
                    {

                    }


                    Column(CheckStyleIndex; CheckStyleIndex)
                    {

                    }


                    Column(CompanyAddr_7_; CompanyAddr[7])
                    {

                    }


                    Column(PrintCheck_Number; Number)
                    {

                    }


                    Column(CheckNoText_Control1480000Caption; CheckNoText_Control1480000CaptionLbl)
                    {

                    }


                    trigger OnAfterGetRecord();
                    var
                        Decimals: Decimal;
                    begin
                        if not TestPrint then begin
                            With GenJnlLine do begin
                                CheckLedgEntry.Init;
                                CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                                CheckLedgEntry."Posting Date" := "Posting Date";
                                CheckLedgEntry."Document Type" := "Document Type";
                                CheckLedgEntry."Document No." := UseCheckNo;
                                CheckLedgEntry.Description := CheckToAddr[1];
                                CheckLedgEntry."Bank Payment Type" := "Bank Payment Type";
                                CheckLedgEntry."Bal. Account Type" := BalancingType;
                                CheckLedgEntry."Bal. Account No." := BalancingNo;
                                if FoundLast then begin
                                    if TotalLineAmount < 0 then
                                        Error(Text020, UseCheckNo, TotalLineAmount);
                                    CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Printed;
                                    CheckLedgEntry.Amount := TotalLineAmount;
                                end else begin
                                    CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Voided;
                                    CheckLedgEntry.Amount := 0;
                                end;

                                CheckLedgEntry."Check Date" := "Posting Date";
                                CheckLedgEntry."Check No." := UseCheckNo;
                                CheckManagement.InsertCheck(CheckLedgEntry, RecordId);

                                if FoundLast then begin
                                    if BankAcc2."Currency Code" <> '' then
                                        Currency.Get(BankAcc2."Currency Code")
                                    else
                                        Currency.InitRoundingPrecision;
                                    Decimals := CheckLedgEntry.Amount - Round(CheckLedgEntry.Amount, 1, '<');
                                    if strlen(Format(Decimals)) < strlen(Format(Currency."Amount Rounding Precision")) then
                                        if Decimals = 0 then
                                            CheckAmountText := Format(CheckLedgEntry.Amount, 0, 0) + COPYSTR(Format(0.01), 2, 1) + PADSTR('', strlen(Format(Currency."Amount Rounding Precision")) - 2, '0')
                                        else
                                            CheckAmountText := Format(CheckLedgEntry.Amount, 0, 0) + PADSTR('', strlen(Format(Currency."Amount Rounding Precision")) - strlen(Format(Decimals)), '0')
                                    else
                                        CheckAmountText := Format(CheckLedgEntry.Amount, 0, 0);
                                    if CheckLanguage = 3084 then begin   // French
                                        DollarSignBefore := '';
                                        DollarSignAfter := Currency.Symbol;
                                    end else begin
                                        DollarSignBefore := Currency.Symbol;
                                        DollarSignAfter := ' ';
                                    end;

                                    if not ChkTransMgt.FormatNoText(DescriptionLine, CheckLedgEntry.Amount, CheckLanguage, BankAcc2."Currency Code") then
                                        Error(DescriptionLine[1]);
                                    VoidText := '';
                                end else begin
                                    Clear(CheckAmountText);
                                    Clear(DescriptionLine);
                                    DescriptionLine[1] := Text021;
                                    DescriptionLine[2] := DescriptionLine[1];
                                    VoidText := Text022;
                                end;
                            end;
                        end else begin
                            With GenJnlLine do begin
                                CheckLedgEntry.Init;
                                CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                                CheckLedgEntry."Posting Date" := "Posting Date";
                                CheckLedgEntry."Document No." := UseCheckNo;
                                CheckLedgEntry.Description := Text023;
                                CheckLedgEntry."Bank Payment Type" := "Bank Payment Type"::"Computer Check";
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::"Test Print";
                                CheckLedgEntry."Check Date" := "Posting Date";
                                CheckLedgEntry."Check No." := UseCheckNo;
                                CheckManagement.InsertCheck(CheckLedgEntry, RecordId);

                                CheckAmountText := Text024;
                                DescriptionLine[1] := Text025;
                                DescriptionLine[2] := DescriptionLine[1];
                                VoidText := Text022;
                            end;
                        end;

                        ChecksPrinted := ChecksPrinted + 1;
                        FirstPage := false;

                        Clear(PrnChkCompanyAddr);
                        Clear(PrnChkCheckToAddr);
                        Clear(PrnChkCheckNoText);
                        Clear(PrnChkCheckDateText);
                        Clear(PrnChkDescriptionLine);
                        Clear(PrnChkVoidText);
                        Clear(PrnChkDateIndicator);
                        Clear(PrnChkCurrencyCode);
                        Clear(PrnChkCheckAmountText);
                        COPYARRAY(PrnChkCompanyAddr[CheckStyle], CompanyAddr, 1);
                        COPYARRAY(PrnChkCheckToAddr[CheckStyle], CheckToAddr, 1);
                        PrnChkCheckNoText[CheckStyle] := CheckNoText;
                        PrnChkCheckDateText[CheckStyle] := CheckDateText;
                        COPYARRAY(PrnChkDescriptionLine[CheckStyle], DescriptionLine, 1);
                        PrnChkVoidText[CheckStyle] := VoidText;
                        PrnChkDateIndicator[CheckStyle] := DateIndicator;
                        PrnChkCurrencyCode[CheckStyle] := BankAcc2."Currency Code";
                        StartingLen := strlen(CheckAmountText);
                        if CheckStyle = CheckStyle::US then
                            ControlLen := 27
                        else
                            ControlLen := 29;
                        CheckAmountText := CheckAmountText + DollarSignBefore + DollarSignAfter;
                        Index := 0;
                        if CheckAmountText = Text024 then begin
                            if strlen(CheckAmountText) < (ControlLen - 12) then begin
                                Repeat
                                    Index := Index + 1;
                                    CheckAmountText := INSSTR(CheckAmountText, '*', strlen(CheckAmountText) + 1);
                                Until (Index = ControlLen) or (strlen(CheckAmountText) >= (ControlLen - 12))
                            end;
                        end else begin
                            if strlen(CheckAmountText) < (ControlLen - 11) then begin
                                Repeat
                                    Index := Index + 1;
                                    CheckAmountText := INSSTR(CheckAmountText, '*', strlen(CheckAmountText) + 1);
                                Until (Index = ControlLen) or (strlen(CheckAmountText) >= (ControlLen - 11))
                            end;
                        end;

                        CheckAmountText := DELSTR(CheckAmountText, StartingLen + 1, strlen(DollarSignBefore + DollarSignAfter));
                        NewLen := strlen(CheckAmountText);
                        if NewLen <> StartingLen then
                            CheckAmountText := COPYSTR(CheckAmountText, StartingLen + 1) + COPYSTR(CheckAmountText, 1, StartingLen);
                        PrnChkCheckAmountText[CheckStyle] := DollarSignBefore + CheckAmountText + DollarSignAfter;

                        if CheckStyle = CheckStyle::CA then
                            CheckStyleIndex := 0
                        else
                            CheckStyleIndex := 1;
                    end;
                }

                trigger OnPreDataItem();
                begin
                    FirstPage := true;
                    FoundLast := false;
                    TotalLineAmount := 0;
                    TotalLineDiscount := 0;
                end;

                trigger OnAfterGetRecord();
                begin
                    if FoundLast then
                        CurrReport.Break;

                    UseCheckNo := INCSTR(UseCheckNo);
                    if not TestPrint then
                        CheckNoText := UseCheckNo
                    else
                        CheckNoText := Text011;

                    Stub2LineNo := 0;
                    Clear(Stub2DocNo);
                    Clear(Stub2DocDate);
                    Clear(Stub2LineAmount);
                    Clear(Stub2LineDiscount);
                    Clear(Stub2PostingDescription);
                    Stub2DocNoHeader := '';
                    Stub2DocDateHeader := '';
                    Stub2AmountHeader := '';
                    Stub2DiscountHeader := '';
                    Stub2NetAmountHeader := '';
                    Stub2PostingDescHeader := '';
                end;

                trigger OnPostDataItem();
                var
                    RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
                begin
                    if not TestPrint then begin
                        if UseCheckNo <> GenJnlLine."Document No." then begin
                            GenJnlLine3.Reset;
                            GenJnlLine3.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine3.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3.SetRange("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3.SetRange("Document No.", UseCheckNo);
                            if GenJnlLine3.Find('-') then
                                GenJnlLine3.FieldError("Document No.", STRSUBSTNO(Text013, UseCheckNo));
                        end;

                        if ApplyMethod <> ApplyMethod::MoreLinesOneEntry then begin
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.TestField("Posting No. Series", '');
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Check Printed" := true;
                            GenJnlLine3.Modify;
                        end else begin
                            "TotalLineAmount$" := 0;
                            if GenJnlLine2.Find('-') then begin
                                HighestLineNo := GenJnlLine2."Line No.";
                                Repeat
                                    if GenJnlLine2."Line No." > HighestLineNo then
                                        HighestLineNo := GenJnlLine2."Line No.";
                                    GenJnlLine3 := GenJnlLine2;
                                    GenJnlLine3.TestField("Posting No. Series", '');
                                    GenJnlLine3."Bal. Account No." := '';
                                    GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::" ";
                                    GenJnlLine3."Document No." := UseCheckNo;
                                    GenJnlLine3."Check Printed" := true;
                                    GenJnlLine3.Validate(Amount);
                                    "TotalLineAmount$" := "TotalLineAmount$" + GenJnlLine3."Amount (LCY)";
                                    GenJnlLine3.Modify;
                                Until GenJnlLine2.Next = 0;
                            end;

                            GenJnlLine3.Reset;
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3."Line No." := HighestLineNo;
                            if GenJnlLine3.Next = 0 then
                                GenJnlLine3."Line No." := HighestLineNo + 10000
                            else begin
                                While GenJnlLine3."Line No." = HighestLineNo + 1 do begin
                                    HighestLineNo := GenJnlLine3."Line No.";
                                    if GenJnlLine3.Next = 0 then
                                        GenJnlLine3."Line No." := HighestLineNo + 20000;
                                end;
                                GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) div 2;
                            end;
                            GenJnlLine3.Init;
                            GenJnlLine3.Validate("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::"Bank Account";
                            GenJnlLine3.Validate("Account No.", BankAcc2."No.");
                            if BalancingType <> BalancingType::"G/L Account" then
                                GenJnlLine3.Description := STRSUBSTNO(Text014, SELECTSTR(BalancingType + 1, Text062), BalancingNo);
                            GenJnlLine3.Validate(Amount, -TotalLineAmount);
                            if TotalLineAmount <> "TotalLineAmount$" then
                                GenJnlLine3.Validate("Amount (LCY)", -"TotalLineAmount$");
                            GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::"Computer Check";
                            GenJnlLine3."Check Printed" := true;
                            GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                            GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                            GenJnlLine3."Allow Zero-Amount Posting" := true;
                            GenJnlLine3."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                            GenJnlLine3."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                            GenJnlLine3.Insert;
                            if CheckGenJournalBatchAndLineIsApproved(GenJnlLine) then
                                RecordRestrictionMgt.AllowRecordUsage(GenJnlLine3);

                        end;
                    end;

                    BankAcc2."Last Check No." := UseCheckNo;
                    BankAcc2.Modify;
                    if CommitEachCheck then begin
                        Commit;
                        Clear(CheckManagement);
                    end;
                end;
            }

            trigger OnPreDataItem();
            var
                CompanyInfo: Record "Company Information";
            begin
                COPY(VoidGenJnlLine);
                CompanyInfo.Get;
                if NOT TestPrint then begin
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                    BankAcc2.Get(BankAcc2."No.");
                    BankAcc2.TestField(Blocked, false);
                    COPY(VoidGenJnlLine);
                    SetRange("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                    SetRange("Check Printed", false);
                end else begin
                    Clear(CompanyAddr);
                    for i := 1 to 5 do
                        CompanyAddr[i] := Text003;
                end;
                ChecksPrinted := 0;

                SetRange("Account Type", "Account Type"::"Fixed Asset");
                if Find('-') then
                    FieldError("Account Type");
                SetRange("Account Type");
            end;

            trigger OnAfterGetRecord();
            begin
                if OneCheckPrVendor and ("Currency Code" <> '') and
                    ("Currency Code" <> Currency.Code)
                then begin
                    Currency.Get("Currency Code");
                    Currency.TestField("Conv. LCY Rndg. Debit Acc.");
                    Currency.TestField("Conv. LCY Rndg. Credit Acc.");
                end;

                if NOT TestPrint then begin
                    if Amount = 0 then
                        CurrReport.SKIP;

                    TestField("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                    if "Bal. Account No." <> BankAcc2."No." then
                        CurrReport.SKIP;

                    if ("Account No." <> '') and ("Bal. Account No." <> '') then begin
                        BalancingType := "Account Type";
                        BalancingNo := "Account No.";
                        RemainingAmount := Amount;
                        if OneCheckPrVendor then begin
                            ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                            GenJnlLine2.Reset;
                            GenJnlLine2.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine2.SetRange("Journal Template Name", "Journal Template Name");
                            GenJnlLine2.SetRange("Journal Batch Name", "Journal Batch Name");
                            GenJnlLine2.SetRange("Posting Date", "Posting Date");
                            GenJnlLine2.SetRange("Document No.", "Document No.");
                            GenJnlLine2.SetRange("Account Type", "Account Type");
                            GenJnlLine2.SetRange("Account No.", "Account No.");
                            GenJnlLine2.SetRange("Bal. Account Type", "Bal. Account Type");
                            GenJnlLine2.SetRange("Bal. Account No.", "Bal. Account No.");
                            GenJnlLine2.SetRange("Bank Payment Type", "Bank Payment Type");
                            GenJnlLine2.Find('-');
                            RemainingAmount := 0;
                        end else
                            if "Applies-to Doc. No." <> '' then
                                ApplyMethod := ApplyMethod::OneLineOneEntry
                            else
                                if "Applies-to ID" <> '' then
                                    ApplyMethod := ApplyMethod::OneLineID
                                else
                                    ApplyMethod := ApplyMethod::Payment;
                    end else
                        if "Account No." = '' then
                            FieldError("Account No.", Text004)
                        else
                            FieldError("Bal. Account No.", Text004);

                    Clear(CheckToAddr);
                    Clear(SalesPurchPerson);
                    case BalancingType of
                        BalancingType::"G/L Account":
                            begin
                                CheckToAddr[1] := Description;
                                ChkTransMgt.SetCheckPrintParams(
                                BankAcc2."Check Date Format",
                                BankAcc2."Check Date Separator",
                                BankAcc2."Country/Region Code",
                                BankAcc2."Bank Communication",
                                CheckToAddr[1],
                                CheckDateFormat,
                                DateSeparator,
                                CheckLanguage,
                                CheckStyle);
                            end;
                        BalancingType::Customer:
                            begin
                                Cust.Get(BalancingNo);
                                if Cust."Privacy Blocked" then
                                    Error(PrivacyBlockedErr, Cust.TABLECAPTION, Cust."No.");
                                if Cust.Blocked in [Cust.Blocked::All] then
                                    Error(Text064, Cust.FIELDCAPTION(Blocked), Cust.Blocked, Cust.TABLECAPTION, Cust."No.");
                                Cust.Contact := '';
                                FormatAddr.Customer(CheckToAddr, Cust);
                                if BankAcc2."Currency Code" <> "Currency Code" then
                                    Error(Text005);
                                if Cust."Salesperson Code" <> '' then
                                    SalesPurchPerson.Get(Cust."Salesperson Code");
                                ChkTransMgt.SetCheckPrintParams(
                                Cust."Check Date Format",
                                Cust."Check Date Separator",
                                BankAcc2."Country/Region Code",
                                Cust."Bank Communication",
                                CheckToAddr[1],
                                CheckDateFormat,
                                DateSeparator,
                                CheckLanguage,
                                CheckStyle);
                            end;
                        BalancingType::Vendor:
                            begin
                                Vend.Get(BalancingNo);
                                if Vend."Privacy Blocked" then
                                    Error(PrivacyBlockedErr, Vend.TABLECAPTION, Vend."No.");
                                if Vend.Blocked in [Vend.Blocked::All, Vend.Blocked::Payment] then
                                    Error(Text064, Vend.FIELDCAPTION(Blocked), Vend.Blocked, Vend.TABLECAPTION, Vend."No.");
                                Vend.Contact := '';
                                FormatAddr.Vendor(CheckToAddr, Vend);
                                if BankAcc2."Currency Code" <> "Currency Code" then
                                    Error(Text005);
                                if Vend."Purchaser Code" <> '' then
                                    SalesPurchPerson.Get(Vend."Purchaser Code");
                                ChkTransMgt.SetCheckPrintParams(
                                Vend."Check Date Format",
                                Vend."Check Date Separator",
                                BankAcc2."Country/Region Code",
                                Vend."Bank Communication",
                                CheckToAddr[1],
                                CheckDateFormat,
                                DateSeparator,
                                CheckLanguage,
                                CheckStyle);
                            end;
                        BalancingType::"Bank Account":
                            begin
                                BankAcc.Get(BalancingNo);
                                BankAcc.TestField(Blocked, false);
                                BankAcc.Contact := '';
                                FormatAddr.BankAcc(CheckToAddr, BankAcc);
                                if BankAcc2."Currency Code" <> BankAcc."Currency Code" then
                                    Error(Text008);
                                if BankAcc."Our Contact Code" <> '' then
                                    SalesPurchPerson.Get(BankAcc."Our Contact Code");
                                ChkTransMgt.SetCheckPrintParams(
                                BankAcc."Check Date Format",
                                BankAcc."Check Date Separator",
                                BankAcc2."Country/Region Code",
                                BankAcc."Bank Communication",
                                CheckToAddr[1],
                                CheckDateFormat,
                                DateSeparator,
                                CheckLanguage,
                                CheckStyle);
                            end;
                    end;

                    CheckDateText :=
                        ChkTransMgt.FormatDate("Posting Date", CheckDateFormat, DateSeparator, CheckLanguage, DateIndicator);
                end else begin
                    if ChecksPrinted > 0 then
                        CurrReport.Break;
                    ChkTransMgt.SetCheckPrintParams(
                        BankAcc2."Check Date Format",
                        BankAcc2."Check Date Separator",
                        BankAcc2."Country/Region Code",
                        BankAcc2."Bank Communication",
                        CheckToAddr[1],
                        CheckDateFormat,
                        DateSeparator,
                        CheckLanguage,
                        CheckStyle);
                    BalancingType := BalancingType::Vendor;
                    BalancingNo := Text010;
                    Clear(CheckToAddr);
                    for i := 1 to 5 do
                        CheckToAddr[i] := Text003;
                    Clear(SalesPurchPerson);
                    CheckNoText := Text011;
                    if CheckStyle = CheckStyle::CA then
                        CheckDateText := DateIndicator
                    else
                        CheckDateText := Text010;
                end;
            end;
        }

    }

    requestpage
    {
        trigger OnOpenPage();
        begin
            if BankAcc2."No." <> '' then begin
                if BankAcc2.Get(BankAcc2."No.") then
                    UseCheckNo := BankAcc2."Last Check No."
                else begin
                    BankAcc2."No." := '';
                    UseCheckNo := '';
                end;
            end;
        end;
    }

    trigger OnPreReport();
    begin
        GenJnlTemplate.Get(VoidGenJnlLine.GetFilter("Journal Template Name"));
        if not GenJnlTemplate."Force Doc. Balance" then
            if not Confirm(USText001, true) then
                Error(USText002);

        PageNo := 0;
    end;

    var
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        GenJnlTemplate: Record "Gen. Journal Template";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        ChkTransMgt: Report "Check Translation Management";
        BalancingNo: Code[20];
        UseCheckNo: Code[20];
        CurrencyCode2: Code[10];
        DollarSignBefore: Code[5];
        DollarSignAfter: Code[5];
        PrnChkCurrencyCode: array[2] of Code[10];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        "TotalLineAmount$": Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        LineAmount2: Decimal;
        Stub2LineAmount: array[50] of Decimal;
        Stub2LineDiscount: array[50] of Decimal;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        i: Integer;
        CheckLanguage: Integer;
        Stub2LineNo: Integer;
        StartingLen: Integer;
        ControlLen: Integer;
        NewLen: Integer;
        CheckStyleIndex: Integer;
        Index: Integer;
        PageNo: Integer;
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        CommitEachCheck: Boolean;
        PreprintedStub: Boolean;
        DocDate: Date;
        Stub2DocDate: array[50] of Date;
        BalancingType: Option "G/L Account",Customer,Vendor,"Bank Account";
        CheckDateFormat: Option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD";
        CheckStyle: Option " ",US,CA;
        DateSeparator: Option " ","-",".","/";
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DocType: Text[30];
        DocNo: Text[30];
        ExtDocNo: Text[30];
        VoidText: Text[30];
        TotalText: Text[10];
        NetAmount: Text[30];
        DateIndicator: Text[10];
        Stub2DocNoHeader: Text[30];
        Stub2DocDateHeader: Text[30];
        Stub2AmountHeader: Text[30];
        Stub2DiscountHeader: Text[30];
        Stub2NetAmountHeader: Text[30];
        Stub2PostingDescHeader: Text[50];
        PostingDesc: Text[50];
        BankCurrencyCode: Text[30];
        CompanyAddr: array[8] of Text[50];
        CheckToAddr: array[8] of Text[50];
        DescriptionLine: array[2] of Text[80];
        PrnChkCompanyAddr: array[2, 8] of Text[50];
        PrnChkCheckToAddr: array[2, 8] of Text[50];
        PrnChkCheckNoText: array[2] of Text[30];
        PrnChkCheckDateText: array[2] of Text[30];
        PrnChkCheckAmountText: array[2] of Text[30];
        PrnChkDescriptionLine: array[2, 2] of Text[80];
        PrnChkVoidText: array[2] of Text[30];
        PrnChkDateIndicator: array[2] of Text[10];
        Stub2DocNo: array[50] of Text[30];
        Stub2PostingDescription: array[50] of Text[50];
        Text000: TextConst ENU = 'Preview is not allowed.', ESM = 'No est  permitida la vista preliminar.', FRC = 'Impossible d''afficher … l''‚cran.', ENC = 'Preview is not allowed.';
        Text001: TextConst ENU = 'Last Check No. must be filled in.', ESM = 'Debe rellenar el £lt. n§ cheque.', FRC = 'Le num‚ro du dernier chŠque doit ˆtre renseign‚.', ENC = 'Last Cheque No. must be filled in.';
        Text002: TextConst ENU = 'Filters on %1 and %2 are not allowed.', ESM = 'No est n permitidos filtros en %1 y %2.', FRC = 'Les filtres sur %1 et %2 ne sont pas permis.', ENC = 'Filters on %1 and %2 are not allowed.';
        Text003: TextConst ENU = 'XXXXXXXXXXXXXXXX', ESM = 'XXXXXXXXXXXXXXXX', FRC = 'XXXXXXXXXXXXXXXX', ENC = 'XXXXXXXXXXXXXXXX';
        Text004: TextConst ENU = 'must be entered.', ESM = 'se debe introducir.', FRC = 'doit ˆtre entr‚', ENC = 'must be entered.';
        Text005: TextConst ENU = 'The Bank Account and the General Journal Line must have the same currency.', ESM = 'El banco y el registro l¡nea deben tener la misma divisa.', FRC = 'Le compte bancaire et la ligne du journal g‚n‚ral doivent avoir la mˆme devise.', ENC = 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: TextConst ENU = 'Salesperson', ESM = 'Vendedor', FRC = 'Repr‚sentant', ENC = 'Salesperson';
        Text007: TextConst ENU = 'Purchaser', ESM = 'Comprador', FRC = 'Acheteur', ENC = 'Purchaser';
        Text008: TextConst ENU = 'Both Bank Accounts must have the same currency.', ESM = 'Ambos bancos deben tener la misma divisa.', FRC = 'Les deux comptes bancaires doivent avoir la mˆme devise.', ENC = 'Both Bank Accounts must have the same currency.';
        Text009: TextConst ENU = 'Our Contact', ESM = 'Ntro. contacto', FRC = 'Notre contact', ENC = 'Our Contact';
        Text010: TextConst ENU = 'XXXXXXXXXX', ESM = 'XXXXXXXXXX', FRC = 'XXXXXXXXXX', ENC = 'XXXXXXXXXX';
        Text011: TextConst ENU = 'XXXX', ESM = 'XXXX', FRC = 'XXXX', ENC = 'XXXX';
        Text012: TextConst ENU = 'XX.XXXXXXXXXX.XXXX', ESM = 'XX.XXXXXXXXXX.XXXX', FRC = 'XX.XXXXXXXXXX.XXXX', ENC = 'XX.XXXXXXXXXX.XXXX';
        Text013: TextConst ENU = '%1 already exists.', ESM = 'Ya existe %1.', FRC = '%1 existe d‚j….', ENC = '%1 already exists.';
        Text014: TextConst ENU = 'Check for %1 %2', ESM = 'Cheque para %1 %2', FRC = 'V‚rifiez pour %1 %2', ENC = 'Check for %1 %2';
        Text015: TextConst ENU = 'Payment', ESM = 'Pago', FRC = 'Paiement', ENC = 'Payment';
        Text016: TextConst ENU = 'In the Check report, One Check per Vendor and Document No.\', ESM = 'En informe de cheques, Un cheque por proveedor y n§ documento\', FRC = 'Dans l''‚tat ChŠque, un chŠque par fournisseur et par nø document\', ENC = 'In the Cheque report, One Cheque per Vendor and Document No.\';
        Text017: TextConst ENU = 'must not be activated when Applies-to ID is specified in the journal lines.', ESM = 'no se debe activar cuando se ha usado Liq. por id. en las l¡neas de diario.', FRC = 'ne doit pas ˆtre activ‚ lorsque Code affect‚ … est sp‚cifi‚ dans les lignes du journal.', ENC = 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: TextConst ENU = 'XXX', ESM = 'XXX', FRC = 'XXX', ENC = 'XXX';
        Text019: TextConst ENU = 'Total', ESM = 'Total', FRC = 'Total', ENC = 'Total';
        Text020: TextConst ENU = 'The total amount of check %1 is %2. The amount must be positive.', ESM = 'El importe total del cheque %1 es %2. El importe debe ser positivo.', FRC = 'Le montant total du chŠque %1 est de %2. Le montant doit ˆtre positif.', ENC = 'The total amount of cheque %1 is %2. The amount must be positive.';
        Text021: TextConst ENU = 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID', ESM = 'ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO ANULADO', FRC = 'ANNUL ANNUL ANNUL ANNUL ANNUL ANNUL ANNUL ANNUL ANNUL ANNUL ANNUL', ENC = 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: TextConst ENU = 'NON-NEGOTIABLE', ESM = 'NO NEGOCIABLE', FRC = 'NON NGOCIABLE', ENC = 'NON-NEGOTIABLE';
        Text023: TextConst ENU = 'Test print', ESM = 'Test impresi¢n', FRC = 'preuve', ENC = 'Test print';
        Text024: TextConst ENU = 'XXXX.XX', ESM = 'XXXX.XX', FRC = 'XXXX.XX', ENC = 'XXXX.XX';
        Text025: TextConst ENU = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', ESM = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', FRC = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', ENC = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text030: TextConst ENU = '" is already applied to %1 %2 for customer %3."', ESM = '" ya se aplic¢ a %1 %2 para el cliente %3."', FRC = '" est d‚j… appliqu‚ … %1 %2 pour le client %3."', ENC = '" is already applied to %1 %2 for customer %3."';
        Text031: TextConst ENU = '" is already applied to %1 %2 for vendor %3."', ESM = '" ya se aplic¢ a %1 %2 para el proveedor %3."', FRC = '" est d‚j… appliqu‚ … %1 %2 pour le fournisseur %3."', ENC = '" is already applied to %1 %2 for vendor %3."';
        Text062: TextConst ENU = 'G/L Account,Customer,Vendor,Bank Account', ESM = 'Cuenta,Cliente,Proveedor,Banco', FRC = 'Compte du grand livre,Client,Fournisseur,Compte bancaire', ENC = 'G/L Account,Customer,Vendor,Bank Account';
        Text063: TextConst ENU = 'Net Amount %1', ESM = 'Importe neto %1', FRC = 'Montant net %1', ENC = 'Net Amount %1';
        Text064: TextConst ENU = '%1 must not be %2 for %3 %4.', ESM = '%1 no debe ser %2 para %3 %4.', FRC = '%1 ne doit pas ˆtre %2 lorsque %3 %4.', ENC = '%1 must not be %2 for %3 %4.';
        USText001: TextConst ENU = 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?', ESM = 'Aviso:  los cheques no podr n anularse si Forzar saldo por n§ documento est  establecido en No en el Libro diario. ¨Desea continuar?', FRC = 'Avertissement : impossible d''annuler financiŠrement un chŠque lorsque le paramŠtre Forcer ‚quilibre doc. est d‚fini … Non dans le modŠle de journal. Souhaitez-vous poursuivre quand mˆme?', ENC = 'Warning:  Cheques cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?';
        USText002: TextConst ENU = 'Process canceled at user request.', ESM = 'Proceso cancelado a petici¢n del usuario.', FRC = 'Processus annul‚ … la demande de l''utilisateur.', ENC = 'Process cancelled at user request.';
        USText003: TextConst ENU = '%1 must not be %2 on %3 %4.', ESM = '%1 no debe ser %2 en %3 %4.', FRC = '%1 ne doit pas ˆtre %2 sur %3 %4.', ENC = '%1 must not be %2 on %3 %4.';
        USText004: TextConst ENU = 'Last Check No. must include at least one digit, so that it can be incremented.', ESM = 'El £ltimo Nø de cheque debe incluir al menos un d¡gito, de modo que pueda ser incrementado.', FRC = 'Le nø du dernier chŠque doit comprendre au moins un chiffre afin de pouvoir ˆtre incr‚ment‚.', ENC = 'Last Cheque No. must include at least one digit, so that it can be incremented.';
        USText005: TextConst ENU = '%1 language is not enabled. %2 is set up for checks in %1.', ESM = 'Idioma %1 no est  activado. %2 se ha configurado para cheques en %1.', FRC = 'La langue %1 n''est pas activ‚e. %2 est configur‚ pour des chŠques en %1.', ENC = '%1 language is not enabled. %2 is set up for cheques in %1.';
        USText006: TextConst ENU = 'You cannot use the <blank> %1 option with a Canadian style check. Please check %2 %3.', ESM = 'No puede usar la opci¢n %1 <blank> con un corrector de estilo canadiense. Compruebe %2 %3.', FRC = 'Vous ne pouvez pas utiliser l''option %1 <vide> avec un chŠque canadien. Veuillez v‚rifier %2 %3', ENC = 'You cannot use the <blank> %1 option with a Canadian style cheque. Please check %2 %3.';
        USText007: TextConst ENU = 'You cannot use the Spanish %1 option with a Canadian style check. Please check %2 %3.', ESM = 'No puede usar la opci¢n %1 Espa¤ol con un corrector de estilo canadiense. Compruebe %2 %3.', FRC = 'Vous ne pouvez pas utiliser l''option %1 Espagnol avec un chŠque canadien. Veuillez v‚rifier %2 %3', ENC = 'You cannot use the Spanish %1 option with a Canadian style cheque. Please check %2 %3.';
        USText011: TextConst ENU = 'Document No.', ESM = 'N§ documento', FRC = 'Nø de document', ENC = 'Document No.';
        USText012: TextConst ENU = 'Document Date', ESM = 'Fecha emisi¢n documento', FRC = 'Date document', ENC = 'Document Date';
        USText013: TextConst ENU = 'Amount', ESM = 'Importe', FRC = 'Montant', ENC = 'Amount';
        USText014: TextConst ENU = 'Discount', ESM = 'Descuento', FRC = 'Escompte', ENC = 'Discount';
        USText015: TextConst ENU = 'Net Amount', ESM = 'Imp. neto', FRC = 'Montant net', ENC = 'Net Amount';
        USText017: TextConst ENU = 'Posting Description', ESM = 'Texto de registro', FRC = 'Description du report', ENC = 'Posting Description';
        PrivacyBlockedErr: TextConst ENU = '%1 %2 must not be blocked for privacy.', ESM = '%1 %2 no debe bloquearse por motivos de privacidad.', FRC = '%1 %2 ne doit pas ˆtre bloqu‚ … des fins de confidentialit‚.', ENC = '%1 %2 must not be blocked for privacy.';
        CheckNoTextCaptionLbl: TextConst ENU = 'Check No.', ESM = 'N§ cheque', FRC = 'Nø de chŠque', ENC = 'Cheque No.';
        LineAmountCaptionLbl: TextConst ENU = 'Net Amount', ESM = 'Imp. neto', FRC = 'Montant net', ENC = 'Net Amount';
        LineDiscountCaptionLbl: TextConst ENU = 'Discount', ESM = 'Descuento', FRC = 'Escompte', ENC = 'Discount';
        DocNoCaptionLbl: TextConst ENU = 'Document No.', ESM = 'N§ documento', FRC = 'Nø de document', ENC = 'Document No.';
        DocDateCaptionLbl: TextConst ENU = 'Document Date', ESM = 'Fecha emisi¢n documento', FRC = 'Date de document', ENC = 'Document Date';
        Posting_DescriptionCaptionLbl: TextConst ENU = 'Posting Description', ESM = 'Texto de registro', FRC = 'Description du report', ENC = 'Posting Description';
        AmountCaptionLbl: TextConst ENU = 'Amount', ESM = 'Importe', FRC = 'Montant', ENC = 'Amount';
        CheckNoText_Control1480000CaptionLbl: TextConst ENU = 'Check No.', ESM = 'N§ cheque', FRC = 'Nø de chŠque', ENC = 'Cheque No.';

    local procedure CustUpdateAmounts(var CustLedgEntry2: Record 21; RemainingAmount2: Decimal);
    begin
        if (ApplyMethod = ApplyMethod::OneLineOneEntry) or (ApplyMethod = ApplyMethod::MoreLinesOneEntry) then begin
            GenJnlLine3.Reset;
            GenJnlLine3.SetCurrentKey("Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SetRange("Account Type", GenJnlLine3."Account Type"::Customer);
            GenJnlLine3.SetRange("Account No.", CustLedgEntry2."Customer No.");
            GenJnlLine3.SetRange("Applies-to Doc. Type", CustLedgEntry2."Document Type");
            GenJnlLine3.SetRange("Applies-to Doc. No.", CustLedgEntry2."Document No.");
            if ApplyMethod = ApplyMethod::OneLineOneEntry then
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine."Line No.")
            else
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine2."Line No.");
            if CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " then
                if GenJnlLine3.Find('-') then
                    GenJnlLine3.FieldError("Applies-to Doc. No.", StrSubstNo(Text030, CustLedgEntry2."Document Type", CustLedgEntry2."Document No.", CustLedgEntry2."Customer No."));
        end;

        DocType := Format(CustLedgEntry2."Document Type");
        DocNo := CustLedgEntry2."Document No.";
        ExtDocNo := CustLedgEntry2."External Document No.";
        DocDate := CustLedgEntry2."Document Date";

        CurrencyCode2 := CustLedgEntry2."Currency Code";
        CustLedgEntry2.CalcFields("Remaining Amount");
        PostingDesc := CustLedgEntry2.Description;

        LineAmount := -(CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible" - CustLedgEntry2."Accepted Payment Tolerance");
        LineAmount2 := Round(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount), Currency."Amount Rounding Precision");
        if ((((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) and (LineAmount2 >= RemainingAmount2)) or
            ((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::"Credit Memo") and (LineAmount2 <= RemainingAmount2))) and
            (GenJnlLine."Posting Date" <= CustLedgEntry2."Pmt. Discount Date")) or CustLedgEntry2."Accepted Pmt. Disc. Tolerance" then begin
            LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
            if CustLedgEntry2."Accepted Payment Tolerance" <> 0 then
                LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        end else begin
            if RemainingAmount2 >= Round(-(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision") then
                LineAmount2 := Round(-(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision")
            else begin
                LineAmount2 := RemainingAmount2;
                LineAmount := Round(ExchangeAmt(CustLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code", LineAmount2), Currency."Amount Rounding Precision");
            end;
            LineDiscount := 0;
        end;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record 25; RemainingAmount2: Decimal);
    begin
        if (ApplyMethod = ApplyMethod::OneLineOneEntry) or (ApplyMethod = ApplyMethod::MoreLinesOneEntry) then begin
            GenJnlLine3.Reset;
            GenJnlLine3.SetCurrentKey("Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SetRange("Account Type", GenJnlLine3."Account Type"::Vendor);
            GenJnlLine3.SetRange("Account No.", VendLedgEntry2."Vendor No.");
            GenJnlLine3.SetRange("Applies-to Doc. Type", VendLedgEntry2."Document Type");
            GenJnlLine3.SetRange("Applies-to Doc. No.", VendLedgEntry2."Document No.");
            if ApplyMethod = ApplyMethod::OneLineOneEntry then
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine."Line No.")
            else
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine2."Line No.");
            if VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " then
                if GenJnlLine3.Find('-') then
                    GenJnlLine3.FieldError("Applies-to Doc. No.", StrSubstNo(Text031, VendLedgEntry2."Document Type", VendLedgEntry2."Document No.", VendLedgEntry2."Vendor No."));
        end;

        DocType := Format(VendLedgEntry2."Document Type");
        DocNo := VendLedgEntry2."Document No.";
        ExtDocNo := VendLedgEntry2."External Document No.";
        DocNo := ExtDocNo;
        DocDate := VendLedgEntry2."Document Date";
        CurrencyCode2 := VendLedgEntry2."Currency Code";
        VendLedgEntry2.CalcFields("Remaining Amount");
        PostingDesc := VendLedgEntry2.Description;

        LineAmount := -(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible" - VendLedgEntry2."Accepted Payment Tolerance");

        LineAmount2 := Round(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount), Currency."Amount Rounding Precision");

        if ((((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::Invoice) and (LineAmount2 <= RemainingAmount2)) or
            ((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::"Credit Memo") and (LineAmount2 >= RemainingAmount2))) and
            (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date")) or VendLedgEntry2."Accepted Pmt. Disc. Tolerance" then begin
            LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
            if VendLedgEntry2."Accepted Payment Tolerance" <> 0 then
                LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        end else begin
            if RemainingAmount2 >= Round(-(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision") then begin
                LineAmount2 := Round(-(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision");
                LineAmount := Round(ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code", LineAmount2), Currency."Amount Rounding Precision");
            end else begin
                LineAmount2 := RemainingAmount2;
                LineAmount := Round(ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code", LineAmount2), Currency."Amount Rounding Precision");
            end;
            LineDiscount := 0;
        end;
    end;

    procedure InitializeRequest(BankAcc: Code[20]; LastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean);
    begin
        if BankAcc <> '' then
            if BankAcc2.Get(BankAcc) then begin
                UseCheckNo := LastCheckNo;
                OneCheckPrVendor := NewOneCheckPrVend;
                ReprintChecks := NewReprintChecks;
                TestPrint := NewTestPrint;
                PreprintedStub := NewPreprintedStub;
            end;
    end;

    procedure ExchangeAmt(PostingDate: Date; CurrencyCode: Code[10]; CurrencyCode2: Code[10]; Amount: Decimal) Amount2: Decimal;
    begin
        if (CurrencyCode <> '') and (CurrencyCode2 = '') then
            Amount2 := CurrencyExchangeRate.ExchangeAmtLCYToFCY(PostingDate, CurrencyCode, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode))
        else
            if (CurrencyCode = '') and (CurrencyCode2 <> '') then
                Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToLCY(PostingDate, CurrencyCode2, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode2))
            else
                if (CurrencyCode <> '') and (CurrencyCode2 <> '') and (CurrencyCode <> CurrencyCode2) then
                    Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate, CurrencyCode2, CurrencyCode, Amount)
                else
                    Amount2 := Amount;
    end;

    local procedure CheckGenJournalBatchAndLineIsApproved(GenJournalLine: Record "Gen. Journal Line"): Boolean;
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        GenJournalBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
        exit(
          VerifyRecordIdIsApproved(GenJournalBatch.RECORDID) or
          VerifyRecordIdIsApproved(GenJournalLine.RECORDID));
    end;

    local procedure VerifyRecordIdIsApproved(RecordID: RecordID): Boolean;
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Table ID", RecordID.TABLENO);
        ApprovalEntry.SetRange("Record ID to Approve", RecordID);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        ApprovalEntry.SetRange("Related to Change", false);
        if ApprovalEntry.IsEmpty then
            exit(false);

        ApprovalEntry.SetFilter(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        exit(ApprovalEntry.IsEmpty);
    end;
}