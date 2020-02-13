/**
*   //Note: The standard report 10074 has been changed to 1306
*   Documentation Section
*       GRALE01 - 1/2/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created report according to definition from NAV 2009 (ID 10074).
*
*       GRALE02 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Removed KitManagement references and associated tables
*/

report 50100 "Sales Invoice"
{
    CaptionML = ENU = 'Sales - Invoice', ESM = 'Ventas - Factura', FRC = 'Facture de vente', ENC = 'Sales - Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportsLayout/SalesInvoice.rdl';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterHeadingML = ENU = 'Sales Invoice', ESM = 'Factura Venta', FRC = 'Facture De Vente', ENC = 'Sales Invoice';
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";

            column(No_SalesInvHeader; "No.")
            {

            }

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLink = "Document No." = field("No.");

                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.") where("Document Type" = const("Posted Invoice"), "Print On Invoice" = const(true));
                    DataItemLink = "No." = field("Document No."), "Document Line No." = field("Line No.");

                    trigger OnAfterGetRecord();
                    begin
                        with TempSalesInvoiceLine do begin
                            Init;
                            "Document No." := "Sales Invoice Header"."No.";
                            "Line No." := HighestLineNo + 10;
                            HighestLineNo := "Line No.";
                        end;
                        if StrLen(Comment) <= MaxStrLen(TempSalesInvoiceLine.Description) then begin
                            TempSalesInvoiceLine.Description := Comment;
                            TempSalesInvoiceLine."Description 2" := '';
                        end else begin
                            SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                            while (SpacePointer > 1) and (Comment[SpacePointer] <> ' ') do
                                SpacePointer := SpacePointer - 1;

                            if SpacePointer = 1 then
                                SpacePointer := MaxStrLen(TempSalesInvoiceLine.Description) + 1;
                            TempSalesInvoiceLine.Description := CopyStr(Comment, 1, SpacePointer - 1);
                            TempSalesInvoiceLine."Description 2" := CopyStr(CopyStr(Comment, SpacePointer + 1), 1, MaxStrLen(TempSalesInvoiceLine."Description 2"));
                        end;
                        TempSalesInvoiceLine.Insert;
                    end;
                }

                trigger OnPreDataItem();
                begin
                    TempSalesInvoiceLine.Reset;
                    TempSalesInvoiceLine.DeleteAll;
                    TempSalesInvoiceLineAsm.Reset;
                    TempSalesInvoiceLineAsm.DeleteAll;
                end;

                trigger OnAfterGetRecord();
                begin
                    TempSalesInvoiceLine := "Sales Invoice Line";
                    TempSalesInvoiceLine.Insert;
                    TempSalesInvoiceLineAsm := "Sales Invoice Line";
                    TempSalesInvoiceLineAsm.Insert;
                    HighestLineNo := "Line No.";
                end;
            }

            dataitem("Sales Comment Line"; "Sales Comment Line")
            {
                DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.") where("Document Type" = const("Posted Invoice"), "Print On Invoice" = const(true), "Document Line No." = const(0));
                DataItemLink = "No." = field("No.");

                column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                {

                }

                trigger OnPreDataItem();
                begin
                    with TempSalesInvoiceLine do begin
                        Init;
                        "Document No." := "Sales Invoice Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    end;
                    TempSalesInvoiceLine.Insert;
                end;

                trigger OnAfterGetRecord();
                begin
                    with TempSalesInvoiceLine do begin
                        Init;
                        "Document No." := "Sales Invoice Header"."No.";
                        "Line No." := HighestLineNo + 1000;
                        HighestLineNo := "Line No.";
                    end;
                    if STRLEN(Comment) <= MAXSTRLEN(TempSalesInvoiceLine.Description) then begin
                        TempSalesInvoiceLine.Description := Comment;
                        TempSalesInvoiceLine."Description 2" := '';
                    end else begin
                        SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                        while (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') do
                            SpacePointer := SpacePointer - 1;
                        if SpacePointer = 1 then
                            SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                        TempSalesInvoiceLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                        TempSalesInvoiceLine."Description 2" := COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesInvoiceLine."Description 2"));
                    end;
                    TempSalesInvoiceLine.Insert;
                end;


            }

            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {

                    }

                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {

                    }

                    column(CompanyInformationPicture; CompanyInfo3.Picture)
                    {

                    }

                    column(CompanyAddress1; CompanyAddress[1])
                    {

                    }

                    column(CompanyAddress2; CompanyAddress[2])
                    {

                    }

                    column(CompanyAddress3; CompanyAddress[3])
                    {

                    }

                    column(CompanyAddress4; CompanyAddress[4])
                    {

                    }

                    column(CompanyAddress5; CompanyAddress[5])
                    {

                    }

                    column(CompanyAddress6; CompanyAddress[6])
                    {

                    }

                    column(CopyTxt; CopyTxt)
                    {

                    }

                    column(BillToAddress1; BillToAddress[1])
                    {

                    }

                    column(BillToAddress2; BillToAddress[2])
                    {

                    }

                    column(BillToAddress3; BillToAddress[3])
                    {

                    }

                    column(BillToAddress4; BillToAddress[4])
                    {

                    }

                    column(BillToAddress5; BillToAddress[5])
                    {

                    }

                    column(BillToAddress6; BillToAddress[6])
                    {

                    }

                    column(BillToAddress7; BillToAddress[7])
                    {

                    }

                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {

                    }
                    column(ShptDate_SalesInvHeader; "Sales Invoice Header"."Shipment Date")
                    {

                    }

                    column(DueDate_SalesInvHeader; "Sales Invoice Header"."Due Date")
                    {

                    }

                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {

                    }

                    column(ShipToAddress1; ShipToAddress[1])
                    {

                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {

                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {

                    }

                    column(ShipToAddress4; ShipToAddress[4])
                    {

                    }

                    column(ShipToAddress5; ShipToAddress[5])
                    {

                    }

                    column(ShipToAddress6; ShipToAddress[6])
                    {

                    }

                    column(ShipToAddress7; ShipToAddress[7])
                    {

                    }

                    column(BilltoCustNo_SalesInvHeader; "Sales Invoice Header"."Bill-to Customer No.")
                    {

                    }
                    column(ExtDocNo_SalesInvHeader; "Sales Invoice Header"."External Document No.")
                    {

                    }

                    column(OrderDate_SalesInvHeader; "Sales Invoice Header"."Order Date")
                    {

                    }

                    column(OrderNo_SalesInvHeader; "Sales Invoice Header"."Order No.")
                    {

                    }

                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {

                    }

                    column(DocumentDate_SalesInvHeader; "Sales Invoice Header"."Document Date")
                    {

                    }

                    column(Description_SalesInvHeader; "Sales Invoice Header".Description)
                    {

                    }

                    column(ReferenceNo_SalesInvHeader; "Sales Invoice Header"."Your Reference")
                    {

                    }

                    column(CurrencyCode; CurrencyCode)
                    {

                    }

                    column(CompanyAddress7; CompanyAddress[7])
                    {

                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {

                    }
                    column(BillToAddress8; BillToAddress[8])
                    {

                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {

                    }
                    column(TaxRegNo; TaxRegNo)
                    {

                    }

                    column(TaxRegLabel; TaxRegLabel)
                    {

                    }

                    column(DocumentText; DocumentText)
                    {

                    }

                    column(CopyNo; CopyNo)
                    {

                    }

                    column(CustTaxIdentificationType; FORMAT(Cust."Tax Identification Type"))
                    {

                    }

                    column(BillCaption; BillCaptionLbl)
                    {

                    }
                    column(ToCaption; ToCaptionLbl)
                    {

                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {

                    }

                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {

                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {

                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {

                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {

                    }

                    column(PONumberCaption; PONumberCaptionLbl)
                    {

                    }

                    column(PODateCaption; PODateCaptionLbl)
                    {

                    }

                    column(OurOrderNoCaption; OurOrderNoCaptionLbl)
                    {

                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {

                    }

                    column(ShipCaption; ShipCaptionLbl)
                    {

                    }

                    column(InvoiceNumberCaption; InvoiceNumberCaptionLbl)
                    {

                    }
                    column(InvoiceDateCaption; InvoiceDateCaptionLbl)
                    {

                    }

                    column(PageCaption; PageCaptionLbl)
                    {

                    }

                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {

                    }

                    column(TaxNoCaption; TaxNoCaptionLbl)
                    {

                    }

                    column(DescriptionCaption; DescriptionCaptionLbl)
                    {

                    }

                    column(CurrencyCaption; CurrencyCaptionLbl)
                    {

                    }

                    column(ReferenceNoCaption; ReferenceNoCaptionLbl)
                    {

                    }

                    column(CanadianBusinessNo; CompanyInformation."Federal ID No.")
                    {

                    }

                    column(VatRegistrationNo; CompanyInformation."VAT Registration No.")
                    {

                    }

                    dataitem(SalesInvLine; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {

                        }

                        column(TempSalesInvoiceLineNo; TempSalesInvoiceLine."No.")
                        {

                        }
                        column(TempSalesInvoiceLineUOM; TempSalesInvoiceLine."Unit of Measure")
                        {

                        }
                        column(OrderedQuantity; OrderedQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TempSalesInvoiceLineQty; TempSalesInvoiceLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(LowDescriptionToPrint; LowDescriptionToPrint)
                        {

                        }
                        column(HighDescriptionToPrint; HighDescriptionToPrint)
                        {

                        }
                        column(TempSalesInvoiceLineDocNo; TempSalesInvoiceLine."Document No.")
                        {

                        }
                        column(TempSalesInvoiceLineLineNo; TempSalesInvoiceLine."Line No.")
                        {

                        }
                        column(TaxLiable; TaxLiable)
                        {

                        }
                        column(TempSalesInvoiceLineAmtTaxLiable; TempSalesInvoiceLine.Amount - TaxLiable)
                        {

                        }
                        column(TempSalesInvoiceLineAmtAmtExclInvDisc; TempSalesInvoiceLine.Amount - AmountExclInvDisc)
                        {

                        }
                        column(TempSalesInvoiceLineAmtInclVATAmount; TempSalesInvoiceLine."Amount Including VAT" - TempSalesInvoiceLine.Amount)
                        {

                        }
                        column(TempSalesInvoiceLineAmtInclVAT; TempSalesInvoiceLine."Amount Including VAT")
                        {

                        }

                        column(WorkDate; TempSalesInvoiceLine."Work Date")
                        {

                        }

                        column(TotalTaxLabel; TotalTaxLabel)
                        {

                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {

                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {

                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {

                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {

                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {

                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {

                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {

                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {

                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {

                        }
                        column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
                        {

                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {

                        }
                        column(OrderQtyCaption; OrderQtyCaptionLbl)
                        {

                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {

                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {

                        }
                        column(TotalPriceCaption; TotalPriceCaptionLbl)
                        {

                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {

                        }
                        column(InvoiceDiscountCaption; InvoiceDiscountCaptionLbl)
                        {

                        }
                        column(TotalCaption; TotalCaption)
                        {

                        }
                        column(AmountSubjecttoSalesTaxCaption; AmountSubjecttoSalesTaxCaption)
                        {

                        }
                        column(AmountExemptfromSalesTaxCaption; AmountExemptfromSalesTaxCaption)
                        {

                        }

                        column(WorkDateCaption; WorkDateCaptionLbl)
                        {

                        }

                        dataitem(AsmLoop; Integer)
                        {
                            DataItemTableView = sorting(Number);

                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }

                            column(TempPostedAsmLineDesc; BlanksForIndent + TempPostedAsmLine.Description)
                            {

                            }

                            column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                            {

                            }

                            trigger OnPreDataItem();
                            begin
                                clear(TempPostedAsmLine);
                                SetRange(Number, 1, TempPostedAsmLine.COUNT);
                            end;

                            trigger OnAfterGetRecord();
                            begin
                                if Number = 1 then
                                    TempPostedAsmLine.FindSet
                                else begin
                                    TempPostedAsmLine.Next;
                                    TaxLiable := 0;
                                    AmountExclInvDisc := 0;
                                    TempSalesInvoiceLine.Amount := 0;
                                    TempSalesInvoiceLine."Amount Including VAT" := 0;
                                end;
                            end;
                        }

                        trigger OnPreDataItem();
                        begin
                            //CurrReport.CreateTotals(TaxLiable, AmountExclInvDisc, TempSalesInvoiceLine.Amount, TempSalesInvoiceLine."Amount Including VAT"); //GRALE02 - This is deprecated
                            NumberOfLines := TempSalesInvoiceLine.Count;
                            SetRange(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                            PrintFooter := FALSE;
                        end;

                        trigger OnAfterGetRecord();
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            with TempSalesInvoiceLine do begin
                                if OnLineNumber = 1 then
                                    Find('-')
                                else
                                    Next;

                                OrderedQuantity := 0;
                                if "Sales Invoice Header"."Order No." = '' then
                                    OrderedQuantity := Quantity
                                else begin
                                    if OrderLine.GET(1, "Sales Invoice Header"."Order No.", "Line No.") then
                                        OrderedQuantity := OrderLine.Quantity
                                    else begin
                                        ShipmentLine.SETRANGE("Order No.", "Sales Invoice Header"."Order No.");
                                        ShipmentLine.SETRANGE("Order Line No.", "Line No.");
                                        if ShipmentLine.Find('-') then
                                            repeat
                                                OrderedQuantity := OrderedQuantity + ShipmentLine.Quantity;
                                            until ShipmentLine.Next = 0;
                                    end;
                                end;

                                DescriptionToPrint := Description + ' ' + "Description 2";
                                if Type = 0 then begin

                                    if OnLineNumber < NumberOfLines then begin
                                        Next;
                                        if Type = 0 then begin
                                            DescriptionToPrint := CopyStr(DescriptionToPrint + ' ' + Description + ' ' + "Description 2", 1, MAXSTRLEN(DescriptionToPrint));
                                            OnLineNumber := OnLineNumber + 1;
                                            SalesInvLine.Next;
                                        end else
                                            Next(-1);
                                    end;

                                    "No." := '';
                                    "Unit of Measure" := '';
                                    Amount := 0;
                                    "Amount Including VAT" := 0;
                                    "Inv. Discount Amount" := 0;
                                    Quantity := 0;
                                end else
                                    if Type = Type::"G/L Account" then
                                        "No." := '';

                                if ("No." = '') and ("Job Task No." = '') then begin
                                    HighDescriptionToPrint := DescriptionToPrint;
                                    LowDescriptionToPrint := '';
                                end else begin
                                    HighDescriptionToPrint := '';
                                    LowDescriptionToPrint := DescriptionToPrint;
                                end;

                                if Amount <> "Amount Including VAT" then begin
                                    TaxFlag := true;
                                    TaxLiable := Amount;
                                end else begin
                                    TaxFlag := false;
                                    TaxLiable := 0;
                                end;

                                AmountExclInvDisc := Amount + "Inv. Discount Amount";

                                if Quantity = 0 then
                                    UnitPriceToPrint := 0  // so it won't print
                                else
                                    UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity, 0.00001);
                            end;

                            CollectAsmInformation(TempSalesInvoiceLine);
                        end;
                    }

                    dataitem(LineFee; Integer)
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number = Filter(1 ..));

                        column(LineFeeCaptionLbl; TempLineFeeNoteOnReportHist.ReportText)
                        {

                        }

                        trigger OnAfterGetRecord();
                        begin
                            if not DisplayAdditionalFeeNote then
                                CurrReport.Break;

                            if Number = 1 then begin
                                if not TempLineFeeNoteOnReportHist.FindSet then
                                    CurrReport.Break;
                            end else
                                if TempLineFeeNoteOnReportHist.Next = 0 then
                                    CurrReport.Break;
                        end;
                    }
                }

                trigger OnPreDataItem();
                begin
                    NoLoops := 1 + Abs(NoCopies) + Customer."Invoice Copies";
                    if NoLoops <= 0 then
                        NoLoops := 1;
                    CopyNo := 0;
                end;

                trigger OnAfterGetRecord();
                begin
                    //CurrReport.PageNo := 1;
                    if CopyNo = NoLoops then begin
                        if not CurrReport.Preview then
                            SalesInvPrinted.Run("Sales Invoice Header");
                        CurrReport.Break;
                    end else
                        CopyNo := CopyNo + 1;
                    if CopyNo = 1 then //original
                        clear(CopyTxt)
                    else
                        CopyTxt := Text000;
                end;

            }

            trigger OnAfterGetRecord();
            begin
                if PrintCompany then begin
                    if RespCenter.Get("Responsibility Center") then begin
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    end;
                end;

                CurrReport.Language := Language.GetLanguageId("Language Code");

                if "Salesperson Code" = '' then
                    Clear(SalesPurchPerson)
                else
                    SalesPurchPerson.Get("Salesperson Code");

                if not Customer.Get("Bill-to Customer No.") then begin
                    Clear(Customer);
                    "Bill-to Name" := Text009;
                    "Ship-to Name" := Text009;
                end;
                DocumentText := USText000;
                if "Prepayment Invoice" then
                    DocumentText := USText001;

                FormatAddress.SalesInvBillTo(BillToAddress, "Sales Invoice Header");
                FormatAddress.SalesInvShipTo(ShipToAddress, CustAddress, "Sales Invoice Header");

                if "Payment Terms Code" = '' then
                    Clear(PaymentTerms)
                else
                    PaymentTerms.Get("Payment Terms Code");

                if "Shipment Method Code" = '' then
                    Clear(ShipmentMethod)
                else
                    ShipmentMethod.Get("Shipment Method Code");

                if "Currency Code" = '' then begin
                    GLSetup.TESTFIELD("LCY Code");
                    TotalCaption := STRSUBSTNO(TotalCaptionTxt, GLSetup."LCY Code");
                    AmountExemptfromSalesTaxCaption := STRSUBSTNO(AmountExemptfromSalesTaxCaptionTxt, GLSetup."LCY Code");
                    AmountSubjecttoSalesTaxCaption := STRSUBSTNO(AmountSubjecttoSalesTaxCaptionTxt, GLSetup."LCY Code");
                end else begin
                    TotalCaption := STRSUBSTNO(TotalCaptionTxt, "Currency Code");
                    AmountExemptfromSalesTaxCaption := STRSUBSTNO(AmountExemptfromSalesTaxCaption, "Currency Code");
                    AmountSubjecttoSalesTaxCaption := STRSUBSTNO(AmountSubjecttoSalesTaxCaption, "Currency Code");
                end;

                //GRALE02 - Add Start
                CurrencyCode := "Currency Code";
                //GRALE02 - Add End

                GetLineFeeNoteOnReportHist("No.");

                if LogInteraction then
                    if not CurrReport.Preview then begin
                        if "Bill-to Contact No." <> '' then
                            SegManagement.LogDocument(4, "No.", 0, 0, Database::Contact, "Bill-to Contact No.", "Salesperson Code", "Campaign No.", "Posting Description", '')
                        else
                            SegManagement.LogDocument(4, "No.", 0, 0, Database::Customer, "Bill-to Customer No.", "Salesperson Code", "Campaign No.", "Posting Description", '');
                    end;

                Clear(BreakdownTitle);
                Clear(BreakdownLabel);
                Clear(BreakdownAmt);
                TotalTaxLabel := Text008;
                TaxRegNo := '';
                TaxRegLabel := '';
                if "Tax Area Code" <> '' then begin
                    TaxArea.Get("Tax Area Code");
                    case TaxArea.Country of
                        TaxArea.Country::US:
                            TotalTaxLabel := Text005;
                        TaxArea.Country::CA:
                            begin
                                TotalTaxLabel := Text007;
                                TaxRegNo := CompanyInformation."VAT Registration No.";
                                TaxRegLabel := CompanyInformation.FIELDCAPTION("VAT Registration No.");
                            end;
                    end;

                    SalesTaxCalc.StartSalesTaxCalculation;
                    if TaxArea."Use External Tax Engine" then
                        SalesTaxCalc.CallExternalTaxEngineForDoc(DATABASE::"Sales Invoice Header", 0, "No.")
                    else begin
                        SalesTaxCalc.AddSalesInvoiceLines("No.");
                        SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                    end;
                    SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                    BrkIdx := 0;
                    PrevPrintOrder := 0;
                    PrevTaxPercent := 0;
                    with TempSalesTaxAmtLine do begin
                        Reset;
                        SetCurrentKey("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
                        if Find('-') then
                            repeat
                                if ("Print Order" = 0) OR
                                    ("Print Order" <> PrevPrintOrder) OR
                                    ("Tax %" <> PrevTaxPercent)
                                then begin
                                    BrkIdx := BrkIdx + 1;
                                    if BrkIdx > 1 then begin
                                        if TaxArea.Country = TaxArea.Country::CA then
                                            BreakdownTitle := Text006
                                        else
                                            BreakdownTitle := Text003;
                                    end;
                                    if BrkIdx > ARRAYLEN(BreakdownAmt) then begin
                                        BrkIdx := BrkIdx - 1;
                                        BreakdownLabel[BrkIdx] := Text004;
                                    end else
                                        BreakdownLabel[BrkIdx] := STRSUBSTNO("Print Description", "Tax %");
                                end;
                                BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                            until Next = 0;
                    end;
                    if BrkIdx = 1 then begin
                        Clear(BreakdownLabel);
                        Clear(BreakdownAmt);
                    end;
                end;
            end;

        }


    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoCopies; NoCopies)
                    {
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }

                    field(PrintCompany; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }

                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }

                    field(DisplayAssemblyInformation; DisplayAssemblyInformation)
                    {
                        Caption = 'Show Assembly Components';
                    }

                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        Caption = 'Show Additional Fee Note';
                        ToolTip = 'Specifies if you want notes about additional fees to be shown on the document.';
                    }
                }
            }
        }

        trigger OnInit();
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage();
        begin
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
        end;
    }

    trigger OnInitReport();
    begin
        GLSetup.Get();
    end;

    trigger OnPreReport();
    begin
        ShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
        if not CurrReport.UseRequestPage then
            InitLogInteraction;

        CompanyInformation.Get;
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.Calcfields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.Calcfields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.Calcfields(Picture);
                end;

        end;

        if PrintCompany then
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        else
            Clear(CompanyAddress);

    end;

    var
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        Cust: Record Customer;
        OrderLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        TempSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        TempSalesInvoiceLineAsm: Record "Sales Invoice Line" temporary;
        RespCenter: Record "Responsibility Center";
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        TaxArea: Record "Tax Area";
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate NAV2009";
        SegManagement: Codeunit SegManagement;
        Language: Codeunit Language;
        TaxLiable: Decimal;
        OrderedQuantity: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        PrevTaxPercent: Decimal;
        BreakdownAmt: array[4] of Decimal;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        CurrencyCode: Code[10];
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        DocumentText: Text[20];
        CopyTxt: Text[10];
        DescriptionToPrint: Text[210];
        HighDescriptionToPrint: Text[210];
        LowDescriptionToPrint: Text[210];
        BreakdownLabel: array[4] of Text[30];
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[100];
        ShipToAddress: array[8] of Text[100];
        CustAddress: array[8] of Text[100];
        TotalCaption: Text;
        AmountSubjecttoSalesTaxCaption: Text;
        AmountExemptfromSalesTaxCaption: Text;
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        TaxFlag: Boolean;
        LogInteractionEnable: Boolean;
        LogInteraction: Boolean;
        DisplayAdditionalFeeNote: Boolean;
        DisplayAssemblyInformation: Boolean;
        Text000: TextConst ENU = 'COPY', ESM = 'COPIA', FRC = 'COPIER', ENC = 'COPY';
        Text001: TextConst ENU = 'Transferred from page %1', ESM = 'Transferido desde p g. %1', FRC = 'Transf‚r‚ de la page %1', ENC = 'Transferred from page %1';
        Text002: TextConst ENU = 'Transferred to page %1', ESM = 'Transferido a p gina %1', FRC = 'Transf‚r‚ … la page %1', ENC = 'Transferred to page %1';
        Text003: TextConst ENU = 'Sales Tax Breakdown:', ESM = 'An lisis impto. vtas.:', FRC = 'Ventilation taxe de vente :', ENC = 'Sales Tax Breakdown:';
        Text004: TextConst ENU = 'Other Taxes', ESM = 'Otros impuestos', FRC = 'Autres taxes', ENC = 'Other Taxes';
        Text005: TextConst ENU = 'Total Sales Tax:', ESM = 'Total impto. vtas.:', FRC = 'Taxes de vente totales:', ENC = 'Total Sales Tax:';
        Text006: TextConst ENU = 'Tax Breakdown:', ESM = 'Desglose imptos.:', FRC = 'Ventilation fiscale :', ENC = 'Tax Breakdown:';
        Text007: TextConst ENU = 'Total Tax:', ESM = 'Total impto.:', FRC = 'Taxe totale :', ENC = 'Total Tax:';
        Text008: TextConst ENU = 'Tax:', ESM = 'Impto.:', FRC = 'Taxe :', ENC = 'Tax:';
        Text009: TextConst ENU = 'VOID INVOICE', ESM = 'ANULAR FACTURA', FRC = 'ANNULER FACTURE', ENC = 'VOID INVOICE';
        USText000: TextConst ENU = 'INVOICE', ESM = 'FACTURA', FRC = 'FACTURE', ENC = 'INVOICE';
        USText001: TextConst ENU = 'PREPAYMENT REQUEST', ESM = 'SOLICITUD PREPAGO', FRC = 'REQUÒTE PMENT ANTIC.', ENC = 'PREPAYMENT REQUEST';
        BillCaptionLbl: TextConst ENU = 'Bill', ESM = 'Facturar', FRC = 'Facturer', ENC = 'Bill';
        ToCaptionLbl: TextConst ENU = 'To:', ESM = 'Para:', FRC = '· :', ENC = 'To:';
        ShipViaCaptionLbl: TextConst ENU = 'Ship Via', ESM = 'Env¡o a trav‚s de', FRC = 'Livrer par', ENC = 'Ship Via';
        ShipDateCaptionLbl: TextConst ENU = 'Ship Date', ESM = 'Fecha env¡o', FRC = 'Date de livraison', ENC = 'Ship Date';
        DueDateCaptionLbl: TextConst ENU = 'Due Date', ESM = 'Fecha vencimiento', FRC = 'Date d''‚ch‚ance', ENC = 'Due Date';
        TermsCaptionLbl: TextConst ENU = 'Terms', ESM = 'T‚rminos', FRC = 'Modalit‚s', ENC = 'Terms';
        CustomerIDCaptionLbl: TextConst ENU = 'Customer ID', ESM = 'Id. cliente', FRC = 'Code de client', ENC = 'Customer ID';
        PONumberCaptionLbl: TextConst ENU = 'P.O. Number', ESM = 'N£mero pedido compra', FRC = 'Nø de bon de commande', ENC = 'P.O. Number';
        PODateCaptionLbl: TextConst ENU = 'P.O. Date', ESM = 'Fecha pedido compra', FRC = 'Date du bon de commande', ENC = 'P.O. Date';
        OurOrderNoCaptionLbl: TextConst ENU = 'Our Order No.', ESM = 'Nuestro pedido Nø', FRC = 'Notre nø de commande', ENC = 'Our Order No.';
        SalesPersonCaptionLbl: TextConst ENU = 'SalesPerson', ESM = 'Vendedor', FRC = 'Repr‚sentant', ENC = 'SalesPerson';
        ShipCaptionLbl: TextConst ENU = 'Ship', ESM = 'Enviar', FRC = 'Livrer', ENC = 'Ship';
        InvoiceNumberCaptionLbl: TextConst ENU = 'Invoice Number:', ESM = 'N£mero factura:', FRC = 'Num‚ro de facture :', ENC = 'Invoice Number:';
        InvoiceDateCaptionLbl: TextConst ENU = 'Invoice Date:', ESM = 'Fecha factura:', FRC = 'Date de la facture :', ENC = 'Invoice Date:';
        PageCaptionLbl: TextConst ENU = 'Page:', ESM = 'P g.:', FRC = 'Page :', ENC = 'Page:';
        TaxIdentTypeCaptionLbl: TextConst ENU = 'Tax Ident. Type', ESM = 'Tipo de identificaci¢n fiscal', FRC = 'Type ident. taxe', ENC = 'Tax Ident. Type';
        ItemDescriptionCaptionLbl: TextConst ENU = 'Item/Description', ESM = 'Producto/descripci¢n', FRC = 'Article/Description', ENC = 'Item/Description';
        UnitCaptionLbl: TextConst ENU = 'Unit', ESM = 'Unidad', FRC = 'Unit‚', ENC = 'Unit';
        OrderQtyCaptionLbl: TextConst ENU = 'Order Qty', ESM = 'Cantidad pedido', FRC = 'Qt‚ commande', ENC = 'Order Qty';
        QuantityCaptionLbl: TextConst ENU = 'Quantity', ESM = 'Cantidad', FRC = 'Quantit‚', ENC = 'Quantity';
        UnitPriceCaptionLbl: TextConst ENU = 'Unit Price', ESM = 'Precio unitario', FRC = 'Prix unitaire', ENC = 'Unit Price';
        TotalPriceCaptionLbl: TextConst ENU = 'Total Price', ESM = 'Precio total', FRC = 'Prix total', ENC = 'Total Price';
        SubtotalCaptionLbl: TextConst ENU = 'Subtotal:', ESM = 'Subtotal:', FRC = 'Sous-total :', ENC = 'Subtotal:';
        InvoiceDiscountCaptionLbl: TextConst ENU = 'Invoice Discount:', ESM = 'Descuento factura:', FRC = 'Escompte de la facture :', ENC = 'Invoice Discount:';
        TotalCaptionTxt: TextConst ENU = 'Total %1:', ESM = 'Total %1:', FRC = 'Total %1ÿ:', ENC = 'Total %1:';
        AmountSubjecttoSalesTaxCaptionTxt: TextConst ENU = 'Amount Subject to Sales Tax %1', ESM = 'Importe sujeto a impuestos de ventas %1', FRC = 'Montant assujetti … la taxe de vente %1', ENC = 'Amount Subject to Sales Tax %1';
        AmountExemptfromSalesTaxCaptionTxt: TextConst ENU = 'Amount Exempt from Sales Tax %1', ESM = 'Importe exento de impuestos de ventas %1', FRC = 'Montant exon‚r‚ de la taxe de vente %1', ENC = 'Amount Exempt from Sales Tax %1';
        TaxNoCaptionLbl: TextConst ENU = 'Tax No.';
        DescriptionCaptionLbl: TextConst ENU = 'Description';
        CurrencyCaptionLbl: TextConst ENU = 'Currency';
        ReferenceNoCaptionLbl: TextConst ENU = 'Reference No.';
        WorkDateCaptionLbl: TextConst ENU = 'Work Date';

    procedure InitLogInteraction();
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    procedure CollectAsmInformation(TempSalesInvoiceLine: Record "Sales Invoice Line" temporary);
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        TempPostedAsmLine.DeleteAll;
        if not DisplayAssemblyInformation then
            exit;
        if not TempSalesInvoiceLineAsm.GET(TempSalesInvoiceLine."Document No.", TempSalesInvoiceLine."Line No.") then
            exit;
        SalesInvoiceLine.GET(TempSalesInvoiceLineAsm."Document No.", TempSalesInvoiceLineAsm."Line No.");
        if SalesInvoiceLine.Type <> SalesInvoiceLine.Type::Item then
            exit;
        with ValueEntry do begin
            SETCURRENTKEY("Document No.");
            SETRANGE("Document No.", SalesInvoiceLine."Document No.");
            SETRANGE("Document Type", "Document Type"::"Sales Invoice");
            SETRANGE("Document Line No.", SalesInvoiceLine."Line No.");
            SETRANGE("Applies-to Entry", 0);
            if not FindSet then
                exit;
        end;
        repeat
            if ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") then
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                        if PostedAsmLine.FindSet then
                            repeat
                                TreatAsmLineBuffer(PostedAsmLine);
                            until PostedAsmLine.Next = 0;
                    end;
                end;
        until ValueEntry.Next = 0;
    end;

    procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line");
    begin
        CLEAR(TempPostedAsmLine);
        TempPostedAsmLine.SETRANGE(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SETRANGE("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SETRANGE("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SETRANGE(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SETRANGE("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FindFirst then begin
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.MODIFY;
        end else begin
            CLEAR(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.Insert;
        end;
    end;

    procedure GetUOMText(UOMCode: Code[10]): Text[10];
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.GET(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10];
    begin
        exit(PADSTR('', 2, ' '));
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20]);
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DeleteAll;
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SETRANGE("Document No.", SalesInvoiceHeaderNo);
        if not CustLedgerEntry.FindFirst then
            exit;

        if not Customer.GET(CustLedgerEntry."Customer No.") then
            exit;

        LineFeeNoteOnReportHist.SETRANGE("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SETRANGE("Language Code", Customer."Language Code");
        if LineFeeNoteOnReportHist.FindSet then begin
            repeat
                TempLineFeeNoteOnReportHist.Init;
                TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.Insert;
            until LineFeeNoteOnReportHist.Next = 0;
        end else begin
            LineFeeNoteOnReportHist.SETRANGE("Language Code", Language.GetUserLanguageCode);
            if LineFeeNoteOnReportHist.FindSet then
                repeat
                    TempLineFeeNoteOnReportHist.Init;
                    TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.Insert;
                until LineFeeNoteOnReportHist.Next = 0;
        end;
    end;
}