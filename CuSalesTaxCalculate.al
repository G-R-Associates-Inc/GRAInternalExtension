/**
* This codeunit is the Sales Tax Calculate from NAV 2009
*
*   Documentation Section
*       GRALE01 - 12/23/19 - Lina El Sadek, G.R. & Associates Inc.
*               - Created codeunit.
*
*       GRALE02 - 01/08/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Modified the Tax Type option to reflect the new values
*/
Codeunit 50106 "Sales Tax Calculate NAV2009"
{

    VAR
        TaxArea: Record "Tax Area";
        TaxAreaLine: Record "Tax Area Line";
        TaxDetail: Record "Tax Detail";
        TaxJurisdiction: Record "Tax Jurisdiction";
        TMPTaxDetail: Record "Tax Detail" TEMPORARY;
        TempSalesTaxLine: Record "Sales Tax Amount Line" TEMPORARY;
        RedistSalesTaxLine: Record "Sales Tax Amount Line" TEMPORARY;
        Currency: Record Currency;
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TaxAmountDifference: Record "Sales Tax Amount Difference";
        TempTaxAmountDifference: Record "Sales Tax Amount Difference" TEMPORARY;
        TaxDetailMaximumsTemp: Record "Tax Detail" TEMPORARY;
        ServiceHeader: Record "Service Header";
        ExchangeFactor: Decimal;
        TotalTaxAmountRounding: Decimal;
        TotalForAllocation: Decimal;
        MaxAmountPerQty: Decimal;
        RemainingTaxDetails: Integer;
        LastCalculationOrder: Integer;
        Initialised: Boolean;
        FirstLine: Boolean;
        TaxOnTaxCalculated: Boolean;
        CalculationOrderViolation: Boolean;
        SalesHeaderRead: Boolean;
        PurchHeaderRead: Boolean;
        ServHeaderRead: Boolean;
        TaxAreaRead: Boolean;
        TaxCountry: Option US,CA;
        Text000: TextConst ENU = '%1 in %2 %3 must be filled in with unique values when %4 is %5.', ESM = 'Cuando %4 es %5, %1 en %2 %3 se debe rellenar con valores £nicos.', FRC = '%1 dans %2 %3 doit ˆtre compl‚t‚ avec une valeur unique lorsque %4 est %5.', ENC = '%1 in %2 %3 must be filled in with unique values when %4 is %5.';
        Text001: TextConst ENU = '"The sales tax amount for the %1 %2 and the %3 %4 is incorrect. "', ESM = '"El importe del impto. ventas para el %1 %2 es incorrecto para %3 %4. "', FRC = '"Le montant de la taxe de vente pour le %1 %2 et le %3 %4 est erron‚. "', ENC = '"The sales tax amount for the %1 %2 and the %3 %4 is incorrect. "';
        Text003: TextConst ENU = 'Lines is not initialized', ESM = 'L¡neas no inicializadas', FRC = 'Lignes non initialis‚es', ENC = 'Lines is not initialized';
        Text004: TextConst ENU = 'The calculated sales tax amount is %5, but was supposed to be %6.', ESM = 'El importe impto. ventas calculado es %5, pero sol¡a ser %6.', FRC = 'Le montant sales tax calcul‚ est %5, mais il est suppos‚ ˆtre %6.', ENC = 'The calculated sales tax amount is %5, but was supposed to be %6.';
        Text1020000: TextConst ENU = 'Tax country/region %1 is being used.  You must use %2.', ESM = 'Pa¡s/regi¢n impuesto %1 en uso. Debe usar %2.', FRC = 'Le pays/r‚gion %1 est utilis‚ … des fins fiscales. Vous devez utiliser %2.', ENC = 'Tax country/region %1 is being used.  You must use %2.';
        Text1020001: TextConst ENU = 'Note to Programmers: The function "CopyTaxDifferences" must not be called unless the function "EndSalesTaxCalculation", or the function "PutSalesTaxAmountLineTable", is called first.', ESM = 'Nota para los programadores: no debe llamarse a la funci¢n "CopyTaxDifferences" a menos que se llame primero a "EndSalesTaxCalculation" o "PutSalesTaxAmountLineTable".', FRC = 'Note … l''intention des programmeurs : La fonction "CopyTaxDifferences" ne doit pas ˆtre appel‚e … moins que la fonction "EndSalesTaxCalculation" ou la fonction "PutSalesTaxAmountLineTable" n''ait ‚t‚ appel‚e au pr‚alable.', ENC = 'Note to Programmers: The function "CopyTaxDifferences" must not be called unless the function "EndSalesTaxCalculation", or the function "PutSalesTaxAmountLineTable", is called first.';
        Text1020002: TextConst ENU = 'A %1 record could not be found within the following parameters:/%2: %3, %4: %5, %6: %7.', ESM = 'No se encontr¢ el registro %1 en los siguientes par metros:/%2: %3, %4: %5, %6: %7.', FRC = 'Impossible de trouver un enregistrement %1 parmi les paramŠtres suivants :/%2 : %3, %4 : %5, %6 : %7.', ENC = 'A %1 record could not be found within the following parameters:/%2: %3, %4: %5, %6: %7.';
        Text1020003: TextConst ENU = 'Invalid function call. Function reserved for external tax engines only.', ESM = 'Retiro de funci¢n no v lido. Funci¢n reservada s¢lo para motores de impuestos.', FRC = 'Appel de fonction non valide. Cette fonction est r‚serv‚e aux moteurs fiscaux externes uniquement.', ENC = 'Invalid function call. Function reserved for external tax engines only.';

    PROCEDURE CallExternalTaxEngineForDoc(DocTable: Integer; DocType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"; DocNo: Code[20]) STETransactionID: Text[20];
    BEGIN
        ERROR(Text1020003);
    END;

    /*PROCEDURE CallExternalTaxEngineForJnl(VAR GenJnlLine: Record 81;CalculationType: Option Normal,Reverse,Expense) : Decimal;
    BEGIN
      ERROR(Text1020003);
    END;

    PROCEDURE CallExternalTaxEngineForSales(VAR SalesHeader: Record 36;UpdateRecIfChanged: Boolean) STETransactionIDChanged : Boolean;
    VAR
      OldTransactionID: Text[20];
    BEGIN
      WITH SalesHeader DO BEGIN
        OldTransactionID := "STE Transaction ID";
        "STE Transaction ID" := CallExternalTaxEngineForDoc(DATABASE::"Sales Header","Document Type","No.");
        STETransactionIDChanged := ("STE Transaction ID" <> OldTransactionID);
        IF STETransactionIDChanged AND UpdateRecIfChanged THEN
          MODIFY;
      END;
    END;

    PROCEDURE CallExternalTaxEngineForPurch(VAR PurchHeader: Record 38;UpdateRecIfChanged: Boolean) STETransactionIDChanged : Boolean;
    VAR
      OldTransactionID: Text[20];
    BEGIN
      WITH PurchHeader DO BEGIN
        OldTransactionID := "STE Transaction ID";
        "STE Transaction ID" := CallExternalTaxEngineForDoc(DATABASE::"Purchase Header","Document Type","No.");
        STETransactionIDChanged := ("STE Transaction ID" <> OldTransactionID);
        IF STETransactionIDChanged AND UpdateRecIfChanged THEN
          MODIFY;
      END;
    END;

    PROCEDURE CallExternalTaxEngineForServ(VAR ServiceHeader: Record 5900;UpdateRecIfChanged: Boolean) STETransactionIDChanged : Boolean;
    VAR
      OldTransactionID: Text[20];
    BEGIN
      WITH ServiceHeader DO BEGIN
        OldTransactionID := "STE Transaction ID";
        "STE Transaction ID" := CallExternalTaxEngineForDoc(DATABASE::"Service Header","Document Type","No.");
        STETransactionIDChanged := ("STE Transaction ID" <> OldTransactionID);
        IF STETransactionIDChanged AND UpdateRecIfChanged THEN
          MODIFY;
      END;
    END;

    PROCEDURE FinalizeExternalTaxCalcForDoc(DocTable: Integer;DocNo: Code[20]);
    BEGIN
      ERROR(Text1020003);
    END;

    PROCEDURE FinalizeExternalTaxCalcForJnl(VAR GLEntry: Record 17);
    BEGIN
      ERROR(Text1020003);
    END;*/

    /*PROCEDURE CalculateTax(TaxAreaCode: Code[20]; TaxGroupCode: Code[10]; TaxLiable: Boolean; Date: Date; Amount: Decimal; Quantity: Decimal; ExchangeRate: Decimal) TaxAmount: Decimal;
    VAR
        MaxAmount: Decimal;
        TaxBaseAmount: Decimal;
    BEGIN
        TaxAmount := 0;

        IF NOT TaxLiable OR (TaxAreaCode = '') OR (TaxGroupCode = '') OR
          ((Amount = 0) AND (Quantity = 0))
        THEN
            EXIT;

        IF ExchangeRate = 0 THEN
            ExchangeFactor := 1
        ELSE
            ExchangeFactor := ExchangeRate;

        Amount := Amount / ExchangeFactor;

        TaxAreaLine.SETCURRENTKEY("Tax Area", "Calculation Order");
        TaxAreaLine.SETRANGE("Tax Area", TaxAreaCode);
        TaxAreaLine.FINDLAST;
        LastCalculationOrder := TaxAreaLine."Calculation Order" + 1;
        TaxOnTaxCalculated := FALSE;
        CalculationOrderViolation := FALSE;
        REPEAT
            IF TaxAreaLine."Calculation Order" >= LastCalculationOrder THEN
                CalculationOrderViolation := TRUE
            ELSE
                LastCalculationOrder := TaxAreaLine."Calculation Order";
            TaxDetail.RESET;
            TaxDetail.SETRANGE("Tax Jurisdiction Code", TaxAreaLine."Tax Jurisdiction Code");
            IF TaxGroupCode = '' THEN
                TaxDetail.SETFILTER("Tax Group Code", '%1', TaxGroupCode)
            ELSE
                TaxDetail.SETFILTER("Tax Group Code", '%1|%2', '', TaxGroupCode);
            IF Date = 0D THEN
                TaxDetail.SETFILTER("Effective Date", '<=%1', WORKDATE)
            ELSE
                TaxDetail.SETFILTER("Effective Date", '<=%1', Date);
            TaxDetail.SETFILTER("Tax Type", '%1|%2', TaxDetail."Tax Type"::"Sales and Use Tax",
                                TaxDetail."Tax Type"::"Sales Tax Only");
            IF TaxDetail.FINDLAST AND NOT TaxDetail."Expense/Capitalize" THEN BEGIN
                TaxOnTaxCalculated := TaxOnTaxCalculated OR TaxDetail."Calculate Tax on Tax";
                IF TaxDetail."Calculate Tax on Tax" THEN
                    TaxBaseAmount := Amount + TaxAmount
                ELSE
                    TaxBaseAmount := Amount;
                // This code uses a temporary table to keep track of Maximums.
                //   This temporary table should be cleared before the first call
                //   to this routine.  All subsequent calls will use the values in
                //   that get put into this temporary table.
                TaxDetailMaximumsTemp := TaxDetail;
                IF NOT TaxDetailMaximumsTemp.FIND THEN
                    TaxDetailMaximumsTemp.INSERT;
                MaxAmountPerQty := TaxDetailMaximumsTemp."Maximum Amount/Qty.";
                IF (ABS(TaxBaseAmount) <= TaxDetail."Maximum Amount/Qty.") OR
                   (TaxDetail."Maximum Amount/Qty." = 0)
                THEN BEGIN
                    TaxAmount := TaxAmount + TaxBaseAmount * TaxDetail."Tax Below Maximum" / 100;
                    TaxDetailMaximumsTemp."Maximum Amount/Qty." := TaxDetailMaximumsTemp."Maximum Amount/Qty." - TaxBaseAmount;
                    TaxDetailMaximumsTemp.MODIFY;
                END ELSE BEGIN
                    MaxAmount := TaxBaseAmount / ABS(TaxBaseAmount) * TaxDetail."Maximum Amount/Qty.";
                    TaxAmount :=
                      TaxAmount + ((MaxAmount * TaxDetail."Tax Below Maximum") +
                       ((TaxBaseAmount - MaxAmount) * TaxDetail."Tax Above Maximum")) / 100;
                    TaxDetailMaximumsTemp."Maximum Amount/Qty." := 0;
                    TaxDetailMaximumsTemp.MODIFY;
                END;
            END;
            TaxDetail.SETRANGE("Tax Type", TaxDetail."Tax Type"::"Excise Tax");
            IF TaxDetail.FINDLAST AND NOT TaxDetail."Expense/Capitalize" THEN BEGIN
                TaxDetailMaximumsTemp := TaxDetail;
                IF NOT TaxDetailMaximumsTemp.FIND THEN
                    TaxDetailMaximumsTemp.INSERT;
                MaxAmountPerQty := TaxDetailMaximumsTemp."Maximum Amount/Qty.";

                IF (ABS(Quantity) <= TaxDetail."Maximum Amount/Qty.") OR
                   (TaxDetail."Maximum Amount/Qty." = 0)
                THEN BEGIN
                    TaxAmount := TaxAmount + Quantity * TaxDetail."Tax Below Maximum";
                    TaxDetailMaximumsTemp."Maximum Amount/Qty." := TaxDetailMaximumsTemp."Maximum Amount/Qty." - Quantity;
                    TaxDetailMaximumsTemp.MODIFY;
                END ELSE BEGIN
                    MaxAmount := Quantity / ABS(Quantity) * TaxDetail."Maximum Amount/Qty.";
                    TaxAmount :=
                      TaxAmount + (MaxAmount * TaxDetail."Tax Below Maximum") +
                      ((Quantity - MaxAmount) * TaxDetail."Tax Above Maximum");
                    TaxDetailMaximumsTemp."Maximum Amount/Qty." := 0;
                    TaxDetailMaximumsTemp.MODIFY;
                END;
            END;
        UNTIL TaxAreaLine.NEXT(-1) = 0;
        TaxAmount := TaxAmount * ExchangeFactor;

        IF TaxOnTaxCalculated AND CalculationOrderViolation THEN
            ERROR(
              Text000,
              TaxAreaLine.FIELDCAPTION("Calculation Order"), TaxArea.TABLECAPTION, TaxAreaLine."Tax Area",
              TaxDetail.FIELDCAPTION("Calculate Tax on Tax"), CalculationOrderViolation);
    END;*/

    /*PROCEDURE ReverseCalculateTax(TaxAreaCode: Code[20];TaxGroupCode: Code[10];TaxLiable: Boolean;Date: Date;TotalAmount: Decimal;Quantity: Decimal;ExchangeRate: Decimal) Amount: Decimal;
    VAR
      Inclination: ARRAY [10] OF Decimal;
      Constant: ARRAY [10] OF Decimal;
      MaxRangeAmount: ARRAY [10] OF Decimal;
      MaxTaxAmount: Decimal;
      i: Integer;
      j: Integer;
      Steps: Integer;
      InclinationLess: Decimal;
      InclinationHigher: Decimal;
      ConstantHigher: Decimal;
      SplitAmount: Decimal;
      MaxAmount: Decimal;
      Inserted: Boolean;
      Found: Boolean;
    BEGIN
      Amount := TotalAmount;

      IF NOT TaxLiable OR (TaxAreaCode = '') OR (TaxGroupCode = '') OR
         ((Amount = 0) AND (Quantity = 0))
      THEN
        EXIT;

      IF ExchangeRate = 0 THEN
        ExchangeFactor := 1
      ELSE
        ExchangeFactor := ExchangeRate;

      TotalAmount := TotalAmount / ExchangeFactor;

      TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
      TaxAreaLine.SETRANGE("Tax Area",TaxAreaCode);
      Steps := 1;
      CLEAR(Inclination);
      CLEAR(Constant);
      CLEAR(MaxRangeAmount);
      TaxAreaLine.FINDLAST;
      LastCalculationOrder := TaxAreaLine."Calculation Order" + 1;
      TaxOnTaxCalculated := FALSE;
      CalculationOrderViolation := FALSE;
      REPEAT
        IF TaxAreaLine."Calculation Order" >= LastCalculationOrder THEN
          CalculationOrderViolation := TRUE
        ELSE
          LastCalculationOrder := TaxAreaLine."Calculation Order";
        TaxDetail.RESET;
        TaxDetail.SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
        IF TaxGroupCode = '' THEN
          TaxDetail.SETFILTER("Tax Group Code",'%1',TaxGroupCode)
        ELSE
          TaxDetail.SETFILTER("Tax Group Code",'%1|%2','',TaxGroupCode);
        IF Date = 0D THEN
          TaxDetail.SETFILTER("Effective Date",'<=%1',WORKDATE)
        ELSE
          TaxDetail.SETFILTER("Effective Date",'<=%1',Date);
        TaxDetail.SETFILTER("Tax Type",'%1|%2',TaxDetail."Tax Type"::"Sales and Use Tax",
                            TaxDetail."Tax Type"::"Sales Tax Only");
        IF TaxDetail.FINDLAST THEN BEGIN
          TaxOnTaxCalculated := TaxOnTaxCalculated OR TaxDetail."Calculate Tax on Tax";
          InclinationLess := TaxDetail."Tax Below Maximum" / 100;
          InclinationHigher := TaxDetail."Tax Above Maximum" / 100;

          IF TaxDetail."Maximum Amount/Qty." = 0 THEN BEGIN
            FOR i := 1 TO Steps DO
              IF TaxDetail."Calculate Tax on Tax" THEN BEGIN
                Inclination[i] := Inclination[i] + (1 + Inclination[i]) * InclinationLess;
                Constant[i] := (1 + InclinationLess) * Constant[i];
              END ELSE
                Inclination[i] := Inclination[i] + InclinationLess;
          END ELSE BEGIN
            IF TaxDetail."Calculate Tax on Tax" THEN BEGIN
              ConstantHigher :=
                (TaxDetail."Tax Below Maximum" - TaxDetail."Tax Above Maximum") / 100 *
                TaxDetail."Maximum Amount/Qty.";
              i := 1;
              Found := FALSE;
              WHILE i < Steps DO BEGIN
                MaxTaxAmount := (1 + Inclination[i]) * MaxRangeAmount[i] + Constant[i];
                IF ABS(TaxDetail."Maximum Amount/Qty.") < MaxTaxAmount THEN BEGIN
                  SplitAmount :=
                    (ABS(TaxDetail."Maximum Amount/Qty.") / TaxDetail."Maximum Amount/Qty.") *
                    ((ABS(TaxDetail."Maximum Amount/Qty.") - Constant[i]) / (1 + Inclination[i]));
                  i := Steps;
                  Found := TRUE;
                END;
                i := i + 1;
              END;
              IF NOT Found THEN
                SplitAmount :=
                  (ABS(TaxDetail."Maximum Amount/Qty.") / TaxDetail."Maximum Amount/Qty.") *
                  (ABS(TaxDetail."Maximum Amount/Qty.") - Constant[Steps]) / (1 + Inclination[Steps]);
            END ELSE BEGIN
              ConstantHigher :=
                (TaxDetail."Tax Below Maximum" - TaxDetail."Tax Above Maximum") / 100 *
                TaxDetail."Maximum Amount/Qty.";
              SplitAmount := TaxDetail."Maximum Amount/Qty.";
            END;
            i := 1;
            Inserted := FALSE;
            WHILE i <= Steps DO BEGIN
              CASE TRUE OF
                (MaxRangeAmount[i] < SplitAmount) AND (MaxRangeAmount[i] > 0):
                  BEGIN
                    IF TaxDetail."Calculate Tax on Tax" THEN BEGIN
                      Inclination[i] := Inclination[i] + (1 + Inclination[i]) * InclinationLess;
                      Constant[i] := (1 + InclinationLess) * Constant[i];
                    END ELSE
                      Inclination[i] := Inclination[i] + InclinationLess;
                  END;
                MaxRangeAmount[i] = SplitAmount:
                  BEGIN
                    IF TaxDetail."Calculate Tax on Tax" THEN BEGIN
                      Inclination[i] := Inclination[i] + (1 + Inclination[i]) * InclinationLess;
                      Constant[i] := (1 + InclinationLess) * Constant[i];
                    END ELSE
                      Inclination[i] := Inclination[i] + InclinationLess;
                    Inserted := TRUE;
                  END;
                (MaxRangeAmount[i] > SplitAmount) OR (MaxRangeAmount[i] = 0):
                  BEGIN
                    IF Inserted THEN BEGIN
                      IF TaxDetail."Calculate Tax on Tax" THEN BEGIN
                        Inclination[i] := Inclination[i] + (1 + Inclination[i]) * InclinationHigher;
                        Constant[i] := (1 + InclinationHigher) * Constant[i];
                      END ELSE
                        Inclination[i] := Inclination[i] + InclinationHigher;
                      Constant[i] := Constant[i] + ConstantHigher;
                    END ELSE BEGIN
                      Steps := Steps + 1;
                      FOR j := Steps DOWNTO i + 1 DO BEGIN
                        Inclination[j] := Inclination[j - 1];
                        Constant[j] := Constant[j - 1];
                        MaxRangeAmount[j] := MaxRangeAmount[j - 1];
                      END;
                      IF TaxDetail."Calculate Tax on Tax" THEN BEGIN
                        Inclination[i] := Inclination[i] + (1 + Inclination[i]) * InclinationLess;
                        Constant[i] := (1 + InclinationLess) * Constant[i];
                      END ELSE
                        Inclination[i] := Inclination[i] + InclinationLess;
                      MaxRangeAmount[i] := SplitAmount;
                      Inserted := TRUE;
                    END;
                  END;
              END;
              i := i + 1;
            END;
          END;
        END;
        TaxDetail.SETRANGE("Tax Type",TaxDetail."Tax Type"::"Excise Tax");
        IF TaxDetail.FINDLAST THEN BEGIN
          IF (ABS(Quantity) <= TaxDetail."Maximum Amount/Qty.") OR
             (TaxDetail."Maximum Amount/Qty." = 0)
          THEN
            ConstantHigher := Quantity * TaxDetail."Tax Below Maximum"
          ELSE BEGIN
            MaxAmount := Quantity / ABS(Quantity) * TaxDetail."Maximum Amount/Qty.";
            ConstantHigher :=
              (MaxAmount * TaxDetail."Tax Below Maximum") +
              ((Quantity - MaxAmount) * TaxDetail."Tax Above Maximum");
          END;
          ConstantHigher := ABS(ConstantHigher);

          FOR i := 1 TO Steps DO
            Constant[i] := Constant[i] + ConstantHigher;
        END;
      UNTIL TaxAreaLine.NEXT(-1) = 0;

      IF TaxOnTaxCalculated AND CalculationOrderViolation THEN
        ERROR(
          Text000,
          TaxAreaLine.FIELDCAPTION("Calculation Order"),TaxArea.TABLECAPTION,TaxAreaLine."Tax Area",
          TaxDetail.FIELDCAPTION("Calculate Tax on Tax"),CalculationOrderViolation);

      i := 1;
      Found := FALSE;
      WHILE i < Steps DO BEGIN
        MaxTaxAmount := (1 + Inclination[i]) * MaxRangeAmount[i] + Constant[i];
        IF ABS(TotalAmount) < MaxTaxAmount THEN BEGIN
          IF TotalAmount = 0 THEN
            Amount := 0
          ELSE
            Amount :=
              (ABS(TotalAmount) / TotalAmount) *
              ((ABS(TotalAmount) - Constant[i]) / (1 + Inclination[i]));
          i := Steps;
          Found := TRUE;
        END;
        i := i + 1;
      END;

      IF NOT Found THEN
        IF TotalAmount = 0 THEN
          Amount := 0
        ELSE
          Amount :=
            (ABS(TotalAmount) / TotalAmount) *
            (ABS(TotalAmount) - Constant[Steps]) / (1 + Inclination[Steps]);

      Amount := Amount * ExchangeFactor;
    END;

    PROCEDURE InitSalesTaxLines(TaxAreaCode: Code[20];TaxGroupCode: Code[10];TaxLiable: Boolean;Amount: Decimal;Quantity: Decimal;Date: Date;DesiredTaxAmount: Decimal);
    VAR
      GenJnlLine: Record 81;
      MaxAmount: Decimal;
      TaxAmount: Decimal;
      AddedTaxAmount: Decimal;
      TaxBaseAmount: Decimal;
    BEGIN
      TaxAmount := 0;

      Initialised := TRUE;
      FirstLine := TRUE;
      TMPTaxDetail.DELETEALL;

      RemainingTaxDetails := 0;

      IF (TaxAreaCode = '') OR (TaxGroupCode = '') THEN
        EXIT;

      TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
      TaxAreaLine.SETRANGE("Tax Area",TaxAreaCode);
      TaxAreaLine.FINDLAST;
      LastCalculationOrder := TaxAreaLine."Calculation Order" + 1;
      TaxOnTaxCalculated := FALSE;
      CalculationOrderViolation := FALSE;
      REPEAT
        IF TaxAreaLine."Calculation Order" >= LastCalculationOrder THEN
          CalculationOrderViolation := TRUE
        ELSE
          LastCalculationOrder := TaxAreaLine."Calculation Order";
        TaxDetail.RESET;
        TaxDetail.SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
        IF TaxGroupCode = '' THEN
          TaxDetail.SETFILTER("Tax Group Code",'%1',TaxGroupCode)
        ELSE
          TaxDetail.SETFILTER("Tax Group Code",'%1|%2','',TaxGroupCode);
        IF Date = 0D THEN
          TaxDetail.SETFILTER("Effective Date",'<=%1',WORKDATE)
        ELSE
          TaxDetail.SETFILTER("Effective Date",'<=%1',Date);
        TaxDetail.SETFILTER("Tax Type",'%1|%2',TaxDetail."Tax Type"::"Sales and Use Tax",
                            TaxDetail."Tax Type"::"Sales Tax Only");
        IF TaxDetail.FINDLAST AND
           ((TaxDetail."Tax Below Maximum" <> 0) OR (TaxDetail."Tax Above Maximum" <> 0)) AND
           NOT TaxDetail."Expense/Capitalize"
        THEN BEGIN
          TaxOnTaxCalculated := TaxOnTaxCalculated OR TaxDetail."Calculate Tax on Tax";
          IF TaxDetail."Calculate Tax on Tax" THEN
            TaxBaseAmount := Amount + TaxAmount
          ELSE
            TaxBaseAmount := Amount;
          IF TaxLiable THEN BEGIN
            // This code uses a temporary table to keep track of Maximums.
            //   This temporary table should be cleared before the first call
            //   to this routine.  All subsequent calls will use the values in
            //   that get put into this temporary table.

            TaxDetailMaximumsTemp := TaxDetail;
            IF NOT TaxDetailMaximumsTemp.FIND THEN
              TaxDetailMaximumsTemp.INSERT;
            MaxAmountPerQty := TaxDetailMaximumsTemp."Maximum Amount/Qty.";

            IF (ABS(TaxBaseAmount) <= TaxDetail."Maximum Amount/Qty.") OR
               (TaxDetail."Maximum Amount/Qty." = 0)
            THEN BEGIN
              AddedTaxAmount := TaxBaseAmount * TaxDetail."Tax Below Maximum" / 100;
              TaxDetailMaximumsTemp."Maximum Amount/Qty." := TaxDetailMaximumsTemp."Maximum Amount/Qty." - Quantity;
              TaxDetailMaximumsTemp.MODIFY;
            END ELSE BEGIN
              MaxAmount := TaxBaseAmount / ABS(TaxBaseAmount) * TaxDetail."Maximum Amount/Qty.";
              AddedTaxAmount :=
                ((MaxAmount * TaxDetail."Tax Below Maximum") +
                 ((TaxBaseAmount - MaxAmount) * TaxDetail."Tax Above Maximum")) / 100;
              TaxDetailMaximumsTemp."Maximum Amount/Qty." := 0;
              TaxDetailMaximumsTemp.MODIFY;
            END;
          END ELSE
            AddedTaxAmount := 0;
          TaxAmount := TaxAmount + AddedTaxAmount;
          TMPTaxDetail := TaxDetail;
          TMPTaxDetail."Tax Below Maximum" := AddedTaxAmount;
          TMPTaxDetail."Tax Above Maximum" := TaxBaseAmount;
          TMPTaxDetail.INSERT;
          RemainingTaxDetails := RemainingTaxDetails + 1;
        END;
        TaxDetail.SETRANGE("Tax Type",TaxDetail."Tax Type"::"Excise Tax");
        IF TaxDetail.FINDLAST AND
           ((TaxDetail."Tax Below Maximum" <> 0) OR (TaxDetail."Tax Above Maximum" <> 0)) AND
           NOT TaxDetail."Expense/Capitalize"
        THEN BEGIN
          IF TaxLiable THEN BEGIN
            TaxDetailMaximumsTemp := TaxDetail;
            IF NOT TaxDetailMaximumsTemp.FIND THEN
              TaxDetailMaximumsTemp.INSERT;
            IF (ABS(Quantity) <= TaxDetail."Maximum Amount/Qty.") OR
               (TaxDetail."Maximum Amount/Qty." = 0)
            THEN BEGIN
              AddedTaxAmount := Quantity * TaxDetail."Tax Below Maximum";
              TaxDetailMaximumsTemp."Maximum Amount/Qty." := TaxDetailMaximumsTemp."Maximum Amount/Qty." - Quantity;
              TaxDetailMaximumsTemp.MODIFY;
            END ELSE BEGIN
              MaxAmount := Quantity / ABS(Quantity) * TaxDetail."Maximum Amount/Qty.";
              AddedTaxAmount :=
                (MaxAmount * TaxDetail."Tax Below Maximum") +
                ((Quantity - MaxAmount) * TaxDetail."Tax Above Maximum");
              TaxDetailMaximumsTemp."Maximum Amount/Qty." := 0;
              TaxDetailMaximumsTemp.MODIFY;
            END;
          END ELSE
            AddedTaxAmount := 0;
          TaxAmount := TaxAmount + AddedTaxAmount;
          TMPTaxDetail := TaxDetail;
          TMPTaxDetail."Tax Below Maximum" := AddedTaxAmount;
          TMPTaxDetail."Tax Above Maximum" := TaxBaseAmount;
          TMPTaxDetail.INSERT;
          RemainingTaxDetails := RemainingTaxDetails + 1;
        END;
      UNTIL TaxAreaLine.NEXT(-1) = 0;

      TaxAmount := ROUND(TaxAmount);

      IF (TaxAmount <> DesiredTaxAmount) AND (ABS(TaxAmount - DesiredTaxAmount) <= 0.01) THEN
        IF TMPTaxDetail.FINDSET(TRUE) THEN BEGIN
          TMPTaxDetail."Tax Below Maximum" :=
            TMPTaxDetail."Tax Below Maximum" - TaxAmount + DesiredTaxAmount;
          TMPTaxDetail.MODIFY;
          TaxAmount := DesiredTaxAmount;
        END;

      IF TaxOnTaxCalculated AND CalculationOrderViolation THEN
        ERROR(
          Text000,
          TaxAreaLine.FIELDCAPTION("Calculation Order"),TaxArea.TABLECAPTION,TaxAreaLine."Tax Area",
          TaxDetail.FIELDCAPTION("Calculate Tax on Tax"),CalculationOrderViolation);

      IF TaxAmount <> DesiredTaxAmount THEN
        ERROR(
          Text001 +
          Text004,
          TaxAreaCode,GenJnlLine.FIELDCAPTION("Tax Area Code"),
          TaxGroupCode,GenJnlLine.FIELDCAPTION("Tax Group Code"),
          TaxAmount,DesiredTaxAmount);

      TotalForAllocation := DesiredTaxAmount;
    END;

    PROCEDURE GetSalesTaxLine(VAR TaxDetail2: Record 322;VAR ReturnTaxAmount: Decimal;VAR ReturnTaxBaseAmount: Decimal) : Boolean;
    VAR
      TaxAmount: Decimal;
    BEGIN
      ReturnTaxAmount := 0;

      IF NOT Initialised THEN
        ERROR(Text003);

      IF FirstLine THEN BEGIN
        IF NOT TMPTaxDetail.FINDSET THEN BEGIN
          Initialised := FALSE;
          EXIT(FALSE);
        END ELSE
          TotalTaxAmountRounding := 0;
        FirstLine := FALSE;
      END ELSE
        IF TMPTaxDetail.NEXT = 0 THEN BEGIN
          Initialised := FALSE;
          EXIT(FALSE);
        END;

      ReturnTaxBaseAmount := ROUND(TMPTaxDetail."Tax Above Maximum");

      TaxAmount := TMPTaxDetail."Tax Below Maximum";
      IF TaxAmount <> 0 THEN BEGIN
      ReturnTaxAmount := ROUND(TaxAmount + TotalTaxAmountRounding);
      TotalTaxAmountRounding := TaxAmount + TotalTaxAmountRounding - ReturnTaxAmount;
       END;

      IF RemainingTaxDetails = 0 THEN
        TaxAmount := TotalForAllocation
      ELSE
        IF ABS(TaxAmount) > ABS(TotalForAllocation) THEN
          TaxAmount := TotalForAllocation;

      TotalForAllocation := TotalForAllocation - TaxAmount;
      IF TMPTaxDetail."Tax Below Maximum" = 0 THEN
        ReturnTaxAmount := 0;

      TaxDetail2 := TMPTaxDetail;

      EXIT(TRUE);
    END;

    PROCEDURE ClearMaximums();
    BEGIN
      TaxDetailMaximumsTemp.DELETEALL;
    END;*/

    PROCEDURE StartSalesTaxCalculation();
    BEGIN
        TempSalesTaxLine.RESET;
        TempSalesTaxLine.DELETEALL;
        TempTaxAmountDifference.RESET;
        TempTaxAmountDifference.DELETEALL;
        CLEARALL;
    END;

    /*PROCEDURE AddSalesLine(SalesLine: Record 37);
    BEGIN
        IF NOT SalesHeaderRead THEN BEGIN
            SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
            SalesHeaderRead := TRUE;
            SalesHeader.TESTFIELD("Prices Including VAT", FALSE);
            IF NOT GetSalesTaxCountry(SalesHeader."Tax Area Code") THEN
                EXIT;
            SetUpCurrency(SalesHeader."Currency Code");
            IF SalesHeader."Currency Code" <> '' THEN
                SalesHeader.TESTFIELD("Currency Factor");
            IF SalesHeader."Currency Factor" = 0 THEN
                ExchangeFactor := 1
            ELSE
                ExchangeFactor := SalesHeader."Currency Factor";
            CopyTaxDifferencesToTemp(
              TaxAmountDifference."Document Product Area"::Sales,
              SalesLine."Document Type",
              SalesLine."Document No.");
        END;
        IF NOT GetSalesTaxCountry(SalesLine."Tax Area Code") THEN
            EXIT;

        SalesLine.TESTFIELD("Tax Group Code");

        WITH TempSalesTaxLine DO BEGIN
            RESET;
            CASE TaxCountry OF
                TaxCountry::US:  // Area Code
                    BEGIN
                        SETRANGE("Tax Area Code for Key", SalesLine."Tax Area Code");
                        "Tax Area Code for Key" := SalesLine."Tax Area Code";
                    END;
                TaxCountry::CA:  // Jurisdictions
                    BEGIN
                        SETRANGE("Tax Area Code for Key", '');
                        "Tax Area Code for Key" := '';
                    END;
            END;
            SETRANGE("Tax Group Code", SalesLine."Tax Group Code");
            TaxAreaLine.SETCURRENTKEY("Tax Area", "Calculation Order");
            TaxAreaLine.SETRANGE("Tax Area", SalesLine."Tax Area Code");
            TaxAreaLine.FINDSET;
            REPEAT
                SETRANGE("Tax Jurisdiction Code", TaxAreaLine."Tax Jurisdiction Code");
                "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                IF NOT FINDFIRST THEN BEGIN
                    INIT;
                    "Tax Group Code" := SalesLine."Tax Group Code";
                    "Tax Area Code" := SalesLine."Tax Area Code";
                    "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                    IF TaxCountry = TaxCountry::US THEN BEGIN
                        "Round Tax" := TaxArea."Round Tax";
                        TaxJurisdiction.GET("Tax Jurisdiction Code");
                        "Is Report-to Jurisdiction" := ("Tax Jurisdiction Code" = TaxJurisdiction."Report-to Jurisdiction");
                    END;
                    "Tax Base Amount" := (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") / ExchangeFactor;
                    "Line Amount" := SalesLine."Line Amount" / ExchangeFactor;
                    "Tax Liable" := SalesLine."Tax Liable";
                    Quantity := SalesLine."Quantity (Base)";
                    "Invoice Discount Amount" := SalesLine."Inv. Discount Amount";
                    "Calculation Order" := TaxAreaLine."Calculation Order";
                    INSERT;
                END ELSE BEGIN
                    "Line Amount" := "Line Amount" + (SalesLine."Line Amount" / ExchangeFactor);
                    IF SalesLine."Tax Liable" THEN
                        "Tax Liable" := SalesLine."Tax Liable";
                    "Tax Base Amount" := "Tax Base Amount" + ((SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") / ExchangeFactor);
                    "Tax Amount" := 0;
                    Quantity := Quantity + SalesLine."Quantity (Base)";
                    "Invoice Discount Amount" := "Invoice Discount Amount" + SalesLine."Inv. Discount Amount";
                    MODIFY;
                END;
            UNTIL TaxAreaLine.NEXT = 0;
        END;
    END;*/

    PROCEDURE AddSalesInvoiceLines(DocNo: Code[20]);
    VAR
        SalesInvoiceHeader: Record 112;
        SalesInvoiceLine: Record 113;
        InsertRec: Boolean;
    BEGIN
        SalesInvoiceHeader.GET(DocNo);
        SalesInvoiceHeader.TESTFIELD("Prices Including VAT", FALSE);
        IF NOT GetSalesTaxCountry(SalesInvoiceHeader."Tax Area Code") THEN
            EXIT;
        SetUpCurrency(SalesInvoiceHeader."Currency Code");
        IF SalesInvoiceHeader."Currency Factor" = 0 THEN
            ExchangeFactor := 1
        ELSE
            ExchangeFactor := SalesInvoiceHeader."Currency Factor";

        SalesInvoiceLine.SETRANGE("Document No.", DocNo);
        IF SalesInvoiceLine.FINDSET THEN
            REPEAT
                WITH TempSalesTaxLine DO BEGIN
                    RESET;
                    IF (SalesInvoiceLine.Type <> 0) AND (SalesInvoiceLine."Tax Area Code" <> '') THEN BEGIN
                        TaxAreaLine.SETCURRENTKEY("Tax Area", "Calculation Order");
                        TaxAreaLine.SETRANGE("Tax Area", SalesInvoiceLine."Tax Area Code");
                        TaxAreaLine.FINDSET;
                        REPEAT
                            CASE TaxCountry OF
                                TaxCountry::US:  // Area Code
                                    SETRANGE("Tax Area Code for Key", SalesInvoiceLine."Tax Area Code");
                                TaxCountry::CA:  // Jurisdictions
                                    SETRANGE("Tax Area Code for Key", '');
                            END;
                            SalesInvoiceLine.TESTFIELD("Tax Group Code");
                            SETRANGE("Tax Group Code", SalesInvoiceLine."Tax Group Code");
                            SETRANGE("Tax Jurisdiction Code", TaxAreaLine."Tax Jurisdiction Code");
                            IF NOT FINDFIRST THEN BEGIN
                                INIT;
                                CASE TaxCountry OF
                                    TaxCountry::US:  // Area Code
                                        "Tax Area Code for Key" := SalesInvoiceLine."Tax Area Code";
                                    TaxCountry::CA:  // Jurisdictions
                                        "Tax Area Code for Key" := '';
                                END;
                                "Tax Group Code" := SalesInvoiceLine."Tax Group Code";
                                "Tax Area Code" := SalesInvoiceLine."Tax Area Code";
                                "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                                IF TaxCountry = TaxCountry::US THEN BEGIN
                                    IF "Tax Area Code" <> TaxArea.Code THEN
                                        TaxArea.GET("Tax Area Code");
                                    "Round Tax" := TaxArea."Round Tax";
                                    TaxJurisdiction.GET("Tax Jurisdiction Code");
                                    "Is Report-to Jurisdiction" :=
                                      ("Tax Jurisdiction Code" = TaxJurisdiction."Report-to Jurisdiction");
                                END;
                                "Line Amount" := SalesInvoiceLine."Line Amount" / ExchangeFactor;
                                "Tax Base Amount" := SalesInvoiceLine."VAT Base Amount" / ExchangeFactor;
                                Quantity := SalesInvoiceLine.Quantity;
                                "Tax Liable" := SalesInvoiceLine."Tax Liable";
                                "Calculation Order" := TaxAreaLine."Calculation Order";
                                InsertRec := TRUE;
                                INSERT;
                            END ELSE BEGIN
                                "Line Amount" := "Line Amount" + (SalesInvoiceLine."Line Amount" / ExchangeFactor);
                                "Tax Base Amount" := "Tax Base Amount" + (SalesInvoiceLine."VAT Base Amount" / ExchangeFactor);
                                Quantity := Quantity + SalesInvoiceLine.Quantity;
                                IF SalesInvoiceLine."Tax Liable" THEN
                                    "Tax Liable" := SalesInvoiceLine."Tax Liable";
                                InsertRec := FALSE;
                                MODIFY;
                            END;
                        UNTIL TaxAreaLine.NEXT = 0;
                    END;
                END;
            UNTIL SalesInvoiceLine.NEXT = 0;

        CopyTaxDifferencesToTemp(
          TaxAmountDifference."Document Product Area"::"Posted Sale",
          TaxAmountDifference."Document Type"::Invoice,
          SalesInvoiceHeader."No.");
    END;

    /*
    PROCEDURE AddSalesCrMemoLines(DocNo: Code[20]);
    VAR
      SalesCrMemoHeader: Record 114;
      SalesCrMemoLine: Record 115;
      InsertRec: Boolean;
    BEGIN
      SalesCrMemoHeader.GET(DocNo);
      SalesCrMemoHeader.TESTFIELD("Prices Including VAT",FALSE);
      IF NOT GetSalesTaxCountry(SalesCrMemoHeader."Tax Area Code") THEN
        EXIT;
      SetUpCurrency(SalesCrMemoHeader."Currency Code");
      IF SalesCrMemoHeader."Currency Factor" = 0 THEN
        ExchangeFactor := 1
      ELSE
        ExchangeFactor := SalesCrMemoHeader."Currency Factor";

      SalesCrMemoLine.SETRANGE("Document No.",DocNo);
      IF SalesCrMemoLine.FINDSET THEN
         REPEAT
           WITH TempSalesTaxLine DO BEGIN
             RESET;
             IF (SalesCrMemoLine.Type <> 0) AND (SalesCrMemoLine."Tax Area Code" <> '') THEN BEGIN
               TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
               TaxAreaLine.SETRANGE("Tax Area",SalesCrMemoLine."Tax Area Code");
               TaxAreaLine.FINDSET;
               REPEAT
                 CASE TaxCountry OF
                   TaxCountry::US :  // Area Code
                     SETRANGE("Tax Area Code for Key",SalesCrMemoLine."Tax Area Code");
                   TaxCountry::CA :  // Jurisdictions
                     SETRANGE("Tax Area Code for Key",'');
                 END;
                 SalesCrMemoLine.TESTFIELD("Tax Group Code");
                 SETRANGE("Tax Group Code",SalesCrMemoLine."Tax Group Code");
                 SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
                 IF NOT FINDFIRST THEN BEGIN
                   INIT;
                   CASE TaxCountry OF
                     TaxCountry::US :  // Area Code
                       "Tax Area Code for Key" := SalesCrMemoLine."Tax Area Code";
                     TaxCountry::CA :  // Jurisdictions
                       "Tax Area Code for Key" := '';
                   END;
                   "Tax Group Code" := SalesCrMemoLine."Tax Group Code";
                   "Tax Area Code" := SalesCrMemoLine."Tax Area Code";
                   "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                   IF TaxCountry = TaxCountry::US THEN BEGIN
                     IF "Tax Area Code" <> TaxArea.Code THEN
                       TaxArea.GET("Tax Area Code");
                     "Round Tax" := TaxArea."Round Tax";
                     TaxJurisdiction.GET("Tax Jurisdiction Code");
                     "Is Report-to Jurisdiction" :=
                       ("Tax Jurisdiction Code" = TaxJurisdiction."Report-to Jurisdiction");
                   END;
                   "Line Amount" := SalesCrMemoLine."Line Amount" / ExchangeFactor;
                   "Tax Base Amount" := SalesCrMemoLine."VAT Base Amount" / ExchangeFactor;
                   Quantity := SalesCrMemoLine.Quantity;
                   "Tax Liable" := SalesCrMemoLine."Tax Liable";
                   "Calculation Order" :=  TaxAreaLine."Calculation Order";
                   InsertRec := TRUE;
                   INSERT;
                 END ELSE BEGIN
                   "Line Amount" := "Line Amount" + (SalesCrMemoLine."Line Amount" / ExchangeFactor);
                   "Tax Base Amount" := "Tax Base Amount" + (SalesCrMemoLine."VAT Base Amount" / ExchangeFactor);
                   Quantity := Quantity + SalesCrMemoLine.Quantity;
                   IF SalesCrMemoLine."Tax Liable" THEN
                     "Tax Liable" := SalesCrMemoLine."Tax Liable";
                   InsertRec := FALSE;
                   MODIFY;
                 END;
               UNTIL TaxAreaLine.NEXT = 0;
             END;
           END;
         UNTIL SalesCrMemoLine.NEXT = 0;

      CopyTaxDifferencesToTemp(
        TaxAmountDifference."Document Product Area"::"Posted Sale",
        TaxAmountDifference."Document Type"::"Credit Memo",
        SalesCrMemoHeader."No.");
    END;

    PROCEDURE AddPurchLine(PurchLine: Record 39);
    VAR
      TaxDetail: Record 322;
    BEGIN
      IF NOT PurchHeaderRead THEN BEGIN
        PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");
        PurchHeaderRead := TRUE;
        PurchHeader.TESTFIELD("Prices Including VAT",FALSE);
        IF NOT GetSalesTaxCountry(PurchHeader."Tax Area Code") THEN
          EXIT;
        SetUpCurrency(PurchHeader."Currency Code");
        IF PurchHeader."Currency Code" <> '' THEN
          PurchHeader.TESTFIELD("Currency Factor");
        IF PurchHeader."Currency Factor" = 0 THEN
          ExchangeFactor := 1
        ELSE
          ExchangeFactor := PurchHeader."Currency Factor";
        CopyTaxDifferencesToTemp(
          TaxAmountDifference."Document Product Area"::Purchase,
          PurchLine."Document Type",
          PurchLine."Document No.");
      END;
      IF NOT GetSalesTaxCountry(PurchLine."Tax Area Code") THEN
        EXIT;

      PurchLine.TESTFIELD("Tax Group Code");

      WITH TempSalesTaxLine DO BEGIN
        RESET;
        CASE TaxCountry OF
          TaxCountry::US :  // Area Code
            BEGIN
              SETRANGE("Tax Area Code for Key",PurchLine."Tax Area Code");
              "Tax Area Code for Key" := PurchLine."Tax Area Code";
            END;
          TaxCountry::CA :  // Jurisdictions
            BEGIN
              SETRANGE("Tax Area Code for Key",'');
              "Tax Area Code for Key" := '';
            END;
        END;
        SETRANGE("Tax Group Code",PurchLine."Tax Group Code");
        SETRANGE("Use Tax",PurchLine."Use Tax");
        TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
        TaxAreaLine.SETRANGE("Tax Area",PurchLine."Tax Area Code");
        TaxAreaLine.FINDSET;
        REPEAT
          SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
          "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
          IF NOT FINDFIRST THEN BEGIN
            INIT;
            "Tax Group Code" := PurchLine."Tax Group Code";
            "Tax Area Code" := PurchLine."Tax Area Code";
            "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
            IF TaxCountry = TaxCountry::US THEN BEGIN
              "Round Tax" := TaxArea."Round Tax";
              TaxJurisdiction.GET("Tax Jurisdiction Code");
              "Is Report-to Jurisdiction" := ("Tax Jurisdiction Code" = TaxJurisdiction."Report-to Jurisdiction");
            END;
            "Tax Base Amount" := (PurchLine."Line Amount" - PurchLine."Inv. Discount Amount") / ExchangeFactor;
            "Line Amount" := PurchLine."Line Amount" / ExchangeFactor;
            "Tax Liable" := PurchLine."Tax Liable";
            "Use Tax" := PurchLine."Use Tax";

            TaxDetail.RESET;
            TaxDetail.SETRANGE("Tax Jurisdiction Code","Tax Jurisdiction Code");
            IF "Tax Group Code" = '' THEN
              TaxDetail.SETFILTER("Tax Group Code",'%1',"Tax Group Code")
            ELSE
              TaxDetail.SETFILTER("Tax Group Code",'%1|%2','',"Tax Group Code");
            IF PurchHeader."Posting Date" = 0D THEN
              TaxDetail.SETFILTER("Effective Date",'<=%1',WORKDATE)
            ELSE
              TaxDetail.SETFILTER("Effective Date",'<=%1', PurchHeader."Posting Date");
            TaxDetail.SETFILTER("Tax Type",'%1|%2',TaxDetail."Tax Type"::"Sales and Use Tax",
                            TaxDetail."Tax Type"::"Sales Tax Only");
            IF TaxDetail.FINDLAST THEN
              "Expense/Capitalize" := TaxDetail."Expense/Capitalize";

            "Calculation Order" :=  TaxAreaLine."Calculation Order";
            Quantity := PurchLine."Quantity (Base)";
            "Invoice Discount Amount" := PurchLine."Inv. Discount Amount";
            INSERT;
          END ELSE BEGIN
            "Line Amount" := "Line Amount" + (PurchLine."Line Amount" / ExchangeFactor);
            IF PurchLine."Tax Liable" THEN
              "Tax Liable" := PurchLine."Tax Liable";
            "Tax Base Amount" := "Tax Base Amount" + ((PurchLine."Line Amount" - PurchLine."Inv. Discount Amount") / ExchangeFactor);
            "Tax Amount" := 0;
            Quantity := Quantity + PurchLine."Quantity (Base)";
            "Invoice Discount Amount" := "Invoice Discount Amount" + PurchLine."Inv. Discount Amount";
            MODIFY;
          END;
        UNTIL TaxAreaLine.NEXT = 0;
      END;
    END;

    PROCEDURE AddPurchInvoiceLines(DocNo: Code[20]);
    VAR
      PurchInvHeader: Record 122;
      PurchInvLine: Record 123;
      InsertRec: Boolean;
    BEGIN
      PurchInvHeader.GET(DocNo);
      PurchInvHeader.TESTFIELD("Prices Including VAT",FALSE);
      IF NOT GetSalesTaxCountry(PurchInvHeader."Tax Area Code") THEN
        EXIT;
      SetUpCurrency(PurchInvHeader."Currency Code");
      IF PurchInvHeader."Currency Factor" = 0 THEN
        ExchangeFactor := 1
      ELSE
        ExchangeFactor := PurchInvHeader."Currency Factor";

      PurchInvLine.SETRANGE("Document No.",DocNo);
      IF PurchInvLine.FINDSET THEN
         REPEAT
           WITH TempSalesTaxLine DO BEGIN
             RESET;
             IF (PurchInvLine.Type <> 0) AND (PurchInvLine."Tax Area Code" <> '')  THEN BEGIN
               TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
               TaxAreaLine.SETRANGE("Tax Area",PurchInvLine."Tax Area Code");
               TaxAreaLine.FINDSET;
               REPEAT
                 CASE TaxCountry OF
                   TaxCountry::US :  // Area Code
                     SETRANGE("Tax Area Code for Key",PurchInvLine."Tax Area Code");
                   TaxCountry::CA :  // Jurisdictions
                     SETRANGE("Tax Area Code for Key",'');
                 END;
                 PurchInvLine.TESTFIELD("Tax Group Code");
                 SETRANGE("Tax Group Code",PurchInvLine."Tax Group Code");
                 SETRANGE("Use Tax",PurchInvLine."Use Tax");
                 SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
                 IF NOT FINDFIRST THEN BEGIN
                   INIT;
                   CASE TaxCountry OF
                     TaxCountry::US :  // Area Code
                       "Tax Area Code for Key" := PurchInvLine."Tax Area Code";
                     TaxCountry::CA :  // Jurisdictions
                       "Tax Area Code for Key" := '';
                   END;
                   "Tax Group Code" := PurchInvLine."Tax Group Code";
                   "Tax Area Code" := PurchInvLine."Tax Area Code";
                   "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                   IF TaxCountry = TaxCountry::US THEN BEGIN
                     IF "Tax Area Code" <> TaxArea.Code THEN
                       TaxArea.GET("Tax Area Code");
                     "Round Tax" := TaxArea."Round Tax";
                     TaxJurisdiction.GET("Tax Jurisdiction Code");
                     "Is Report-to Jurisdiction" :=
                       ("Tax Jurisdiction Code" = TaxJurisdiction."Report-to Jurisdiction");
                   END;
                   "Line Amount" := PurchInvLine."Line Amount" / ExchangeFactor;
                   "Tax Base Amount" := PurchInvLine."VAT Base Amount" / ExchangeFactor;
                   Quantity := PurchInvLine.Quantity;
                   "Tax Liable" := PurchInvLine."Tax Liable";
                   "Use Tax" := PurchInvLine."Use Tax";

                   TaxDetail.RESET;
                   TaxDetail.SETRANGE("Tax Jurisdiction Code","Tax Jurisdiction Code");
                   IF "Tax Group Code" = '' THEN
                     TaxDetail.SETFILTER("Tax Group Code",'%1',"Tax Group Code")
                   ELSE
                     TaxDetail.SETFILTER("Tax Group Code",'%1|%2','',"Tax Group Code");
                   IF PurchInvHeader."Posting Date" = 0D THEN
                     TaxDetail.SETFILTER("Effective Date",'<=%1',WORKDATE)
                   ELSE
                     TaxDetail.SETFILTER("Effective Date",'<=%1',PurchInvHeader."Posting Date");
                   TaxDetail.SETFILTER("Tax Type",'%1|%2',TaxDetail."Tax Type"::"Sales and Use Tax",
                                       TaxDetail."Tax Type"::"Sales Tax Only");
                   IF TaxDetail.FINDLAST THEN
                     "Expense/Capitalize" := TaxDetail."Expense/Capitalize";

                   "Calculation Order" :=  TaxAreaLine."Calculation Order";
                   InsertRec := TRUE;
                   INSERT;
                 END ELSE BEGIN
                   "Line Amount" := "Line Amount" + (PurchInvLine."Line Amount" / ExchangeFactor);
                   "Tax Base Amount" := "Tax Base Amount" + (PurchInvLine."VAT Base Amount" / ExchangeFactor);
                   Quantity := Quantity + PurchInvLine.Quantity;
                   IF PurchInvLine."Tax Liable" THEN
                     "Tax Liable" := PurchInvLine."Tax Liable";
                   InsertRec := FALSE;
                   MODIFY;
                 END;
               UNTIL TaxAreaLine.NEXT = 0;
             END;
           END;
         UNTIL PurchInvLine.NEXT = 0;

      CopyTaxDifferencesToTemp(
        TaxAmountDifference."Document Product Area"::"Posted Purchase",
        TaxAmountDifference."Document Type"::Invoice,
        PurchInvHeader."No.");
    END;

    PROCEDURE AddPurchCrMemoLines(DocNo: Code[20]);
    VAR
      PurchCrMemoHeader: Record 124;
      PurchCrMemoLine: Record 125;
      InsertRec: Boolean;
    BEGIN
      PurchCrMemoHeader.GET(DocNo);
      PurchCrMemoHeader.TESTFIELD("Prices Including VAT",FALSE);
      IF NOT GetSalesTaxCountry(PurchCrMemoHeader."Tax Area Code") THEN
        EXIT;
      SetUpCurrency(PurchCrMemoHeader."Currency Code");
      IF PurchCrMemoHeader."Currency Factor" = 0 THEN
        ExchangeFactor := 1
      ELSE
        ExchangeFactor := PurchCrMemoHeader."Currency Factor";

      PurchCrMemoLine.SETRANGE("Document No.",DocNo);
      IF PurchCrMemoLine.FINDSET THEN
         REPEAT
           WITH TempSalesTaxLine DO BEGIN
             RESET;
             IF (PurchCrMemoLine.Type <> 0) AND (PurchCrMemoLine."Tax Area Code" <> '') THEN BEGIN
               TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
               TaxAreaLine.SETRANGE("Tax Area",PurchCrMemoLine."Tax Area Code");
               TaxAreaLine.FINDSET;
               REPEAT
                 CASE TaxCountry OF
                   TaxCountry::US :  // Area Code
                     SETRANGE("Tax Area Code for Key",PurchCrMemoLine."Tax Area Code");
                   TaxCountry::CA :  // Jurisdictions
                     SETRANGE("Tax Area Code for Key",'');
                 END;
                 PurchCrMemoLine.TESTFIELD("Tax Group Code");
                 SETRANGE("Tax Group Code",PurchCrMemoLine."Tax Group Code");
                 SETRANGE("Use Tax",PurchCrMemoLine."Use Tax");
                 SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
                 IF NOT FINDFIRST THEN BEGIN
                   INIT;
                   CASE TaxCountry OF
                     TaxCountry::US :  // Area Code
                       "Tax Area Code for Key" := PurchCrMemoLine."Tax Area Code";
                     TaxCountry::CA :  // Jurisdictions
                       "Tax Area Code for Key" := '';
                   END;
                   "Tax Group Code" := PurchCrMemoLine."Tax Group Code";
                   "Tax Area Code" := PurchCrMemoLine."Tax Area Code";
                   "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                   IF TaxCountry = TaxCountry::US THEN BEGIN
                     IF "Tax Area Code" <> TaxArea.Code THEN
                       TaxArea.GET("Tax Area Code");
                     "Round Tax" := TaxArea."Round Tax";
                     TaxJurisdiction.GET("Tax Jurisdiction Code");
                     "Is Report-to Jurisdiction" :=
                       ("Tax Jurisdiction Code" = TaxJurisdiction."Report-to Jurisdiction");
                   END;
                   "Line Amount" := PurchCrMemoLine."Line Amount" / ExchangeFactor;
                   "Tax Base Amount" := PurchCrMemoLine."VAT Base Amount" / ExchangeFactor;
                   Quantity := PurchCrMemoLine.Quantity;
                   "Tax Liable" := PurchCrMemoLine."Tax Liable";
                   "Use Tax" := PurchCrMemoLine."Use Tax";

                   TaxDetail.RESET;
                   TaxDetail.SETRANGE("Tax Jurisdiction Code","Tax Jurisdiction Code");
                   IF "Tax Group Code" = '' THEN
                     TaxDetail.SETFILTER("Tax Group Code",'%1',"Tax Group Code")
                   ELSE
                     TaxDetail.SETFILTER("Tax Group Code",'%1|%2','',"Tax Group Code");
                   IF PurchCrMemoHeader."Posting Date" = 0D THEN
                     TaxDetail.SETFILTER("Effective Date",'<=%1',WORKDATE)
                   ELSE
                     TaxDetail.SETFILTER("Effective Date",'<=%1',PurchCrMemoHeader."Posting Date");
                   TaxDetail.SETFILTER("Tax Type",'%1|%2',TaxDetail."Tax Type"::"Sales and Use Tax",
                                       TaxDetail."Tax Type"::"Sales Tax Only");
                   IF TaxDetail.FINDLAST THEN
                     "Expense/Capitalize" := TaxDetail."Expense/Capitalize";

                   "Calculation Order" :=  TaxAreaLine."Calculation Order";
                   InsertRec := TRUE;
                   INSERT;
                 END ELSE BEGIN
                   "Line Amount" := "Line Amount" + (PurchCrMemoLine."Line Amount" / ExchangeFactor);
                   "Tax Base Amount" := "Tax Base Amount" + (PurchCrMemoLine."VAT Base Amount" / ExchangeFactor);
                   Quantity := Quantity + PurchCrMemoLine.Quantity;
                   IF PurchCrMemoLine."Tax Liable" THEN
                     "Tax Liable" := PurchCrMemoLine."Tax Liable";
                   InsertRec := FALSE;
                   MODIFY;
                 END;
               UNTIL TaxAreaLine.NEXT = 0;
             END;
           END;
         UNTIL PurchCrMemoLine.NEXT = 0;

      CopyTaxDifferencesToTemp(
        TaxAmountDifference."Document Product Area"::"Posted Purchase",
        TaxAmountDifference."Document Type"::"Credit Memo",
        PurchCrMemoHeader."No.");
    END;

    PROCEDURE AddServiceLine(ServiceLine: Record 5902);
    BEGIN
      IF NOT ServHeaderRead THEN BEGIN
        ServiceHeader.GET(ServiceLine."Document Type",ServiceLine."Document No.");
        ServHeaderRead := TRUE;
        ServiceHeader.TESTFIELD("Prices Including VAT",FALSE);
        IF NOT GetSalesTaxCountry(ServiceHeader."Tax Area Code") THEN
          EXIT;
        SetUpCurrency(ServiceHeader."Currency Code");
        IF ServiceHeader."Currency Code" <> '' THEN
          ServiceHeader.TESTFIELD("Currency Factor");
        IF ServiceHeader."Currency Factor" = 0 THEN
          ExchangeFactor := 1
        ELSE
          ExchangeFactor := ServiceHeader."Currency Factor";
        CopyTaxDifferencesToTemp(
          TaxAmountDifference."Document Product Area"::Service,
          ServiceLine."Document Type",
          ServiceLine."Document No.");
      END;
      IF NOT GetSalesTaxCountry(ServiceLine."Tax Area Code") THEN
        EXIT;

      ServiceLine.TESTFIELD("Tax Group Code");

      WITH TempSalesTaxLine DO BEGIN
        RESET;
        CASE TaxCountry OF
          TaxCountry::US :  // Area Code
            BEGIN
              SETRANGE("Tax Area Code for Key",ServiceLine."Tax Area Code");
              "Tax Area Code for Key" := ServiceLine."Tax Area Code";
            END;
          TaxCountry::CA :  // Jurisdictions
            BEGIN
              SETRANGE("Tax Area Code for Key",'');
              "Tax Area Code for Key" := '';
            END;
        END;
        SETRANGE("Tax Group Code",ServiceLine."Tax Group Code");
        TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
        TaxAreaLine.SETRANGE("Tax Area",ServiceLine."Tax Area Code");
        TaxAreaLine.FINDSET;
        REPEAT
          SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
          "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
          IF NOT FINDFIRST THEN BEGIN
            INIT;
            "Tax Group Code" := ServiceLine."Tax Group Code";
            "Tax Area Code" := ServiceLine."Tax Area Code";
            "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
            IF TaxCountry = TaxCountry::US THEN BEGIN
              "Round Tax" := TaxArea."Round Tax";
              TaxJurisdiction.GET("Tax Jurisdiction Code");
              "Is Report-to Jurisdiction" := ("Tax Jurisdiction Code" = TaxJurisdiction."Report-to Jurisdiction");
            END;
            "Tax Base Amount" := (ServiceLine."Line Amount" - ServiceLine."Inv. Discount Amount") / ExchangeFactor;
            "Line Amount" := ServiceLine."Line Amount" / ExchangeFactor;
            "Tax Liable" := ServiceLine."Tax Liable";
            Quantity := ServiceLine."Quantity (Base)";
            "Invoice Discount Amount" := ServiceLine."Inv. Discount Amount";
            "Calculation Order" :=  TaxAreaLine."Calculation Order";
            INSERT;
          END ELSE BEGIN
            "Line Amount" := "Line Amount" + (ServiceLine."Line Amount" / ExchangeFactor);
            IF ServiceLine."Tax Liable" THEN
              "Tax Liable" := ServiceLine."Tax Liable";
            "Tax Base Amount" :=
              "Tax Base Amount" + ((ServiceLine."Line Amount" - ServiceLine."Inv. Discount Amount") / ExchangeFactor);
            "Tax Amount" := 0;
            Quantity := Quantity + ServiceLine."Quantity (Base)";
            "Invoice Discount Amount" := "Invoice Discount Amount" + ServiceLine."Inv. Discount Amount";
            MODIFY;
          END;
        UNTIL TaxAreaLine.NEXT = 0;
      END;
    END;

    PROCEDURE AddServInvoiceLines(DocNo: Code[20]);
    VAR
      ServInvHeader: Record 5992;
      ServInvLine: Record 5993;
      InsertRec: Boolean;
    BEGIN
      ServInvHeader.GET(DocNo);
      ServInvHeader.TESTFIELD("Prices Including VAT",FALSE);
      IF NOT GetSalesTaxCountry(ServInvHeader."Tax Area Code") THEN
        EXIT;
      SetUpCurrency(ServInvHeader."Currency Code");
      IF ServInvHeader."Currency Factor" = 0 THEN
        ExchangeFactor := 1
      ELSE
        ExchangeFactor := ServInvHeader."Currency Factor";

      ServInvLine.SETRANGE("Document No.",DocNo);
      IF ServInvLine.FINDSET THEN
         REPEAT
           WITH TempSalesTaxLine DO BEGIN
             RESET;
             IF (ServInvLine.Type <> 0) AND (ServInvLine."Tax Area Code" <> '') THEN BEGIN
               TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
               TaxAreaLine.SETRANGE("Tax Area",ServInvLine."Tax Area Code");
               TaxAreaLine.FINDSET;
               REPEAT
                 CASE TaxCountry OF
                   TaxCountry::US :  // Area Code
                     SETRANGE("Tax Area Code for Key",ServInvLine."Tax Area Code");
                   TaxCountry::CA :  // Jurisdictions
                     SETRANGE("Tax Area Code for Key",'');
                 END;
                 ServInvLine.TESTFIELD("Tax Group Code");
                 SETRANGE("Tax Group Code",ServInvLine."Tax Group Code");
                 SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
                 IF NOT FINDFIRST THEN BEGIN
                   INIT;
                   CASE TaxCountry OF
                     TaxCountry::US :  // Area Code
                       "Tax Area Code for Key" := ServInvLine."Tax Area Code";
                     TaxCountry::CA :  // Jurisdictions
                       "Tax Area Code for Key" := '';
                   END;
                   "Tax Group Code" := ServInvLine."Tax Group Code";
                   "Tax Area Code" := ServInvLine."Tax Area Code";
                   "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                   IF TaxCountry = TaxCountry::US THEN BEGIN
                     IF "Tax Area Code" <> TaxArea.Code THEN
                       TaxArea.GET("Tax Area Code");
                     "Round Tax" := TaxArea."Round Tax";
                     TaxJurisdiction.GET("Tax Jurisdiction Code");
                     "Is Report-to Jurisdiction" :=
                       ("Tax Jurisdiction Code" = TaxJurisdiction."Report-to Jurisdiction");
                   END;
                   "Line Amount" := ServInvLine."Line Amount" / ExchangeFactor;
                   "Tax Base Amount" := ServInvLine."VAT Base Amount" / ExchangeFactor;
                   Quantity := ServInvLine.Quantity;
                   "Tax Liable" := ServInvLine."Tax Liable";


                   "Calculation Order" :=  TaxAreaLine."Calculation Order";
                   InsertRec := TRUE;
                   INSERT;
                 END ELSE BEGIN
                   "Line Amount" := "Line Amount" + (ServInvLine."Line Amount" / ExchangeFactor);
                   "Tax Base Amount" := "Tax Base Amount" + (ServInvLine."VAT Base Amount" / ExchangeFactor);
                   Quantity := Quantity + ServInvLine.Quantity;
                   IF ServInvLine."Tax Liable" THEN
                     "Tax Liable" := ServInvLine."Tax Liable";
                   InsertRec := FALSE;
                   MODIFY;
                 END;
               UNTIL TaxAreaLine.NEXT = 0;
             END;
           END;
         UNTIL ServInvLine.NEXT = 0;

      CopyTaxDifferencesToTemp(
        TaxAmountDifference."Document Product Area"::"Posted Service",
        TaxAmountDifference."Document Type"::Invoice,
        ServInvHeader."No.");
    END;

    PROCEDURE AddServCrMemoLines(DocNo: Code[20]);
    VAR
      ServCrMemoHeader: Record 5994;
      ServCrMemoLine: Record 5995;
      InsertRec: Boolean;
    BEGIN
      ServCrMemoHeader.GET(DocNo);
      ServCrMemoHeader.TESTFIELD("Prices Including VAT",FALSE);
      IF NOT GetSalesTaxCountry(ServCrMemoHeader."Tax Area Code") THEN
        EXIT;
      SetUpCurrency(ServCrMemoHeader."Currency Code");
      IF ServCrMemoHeader."Currency Factor" = 0 THEN
        ExchangeFactor := 1
      ELSE
        ExchangeFactor := ServCrMemoHeader."Currency Factor";

      ServCrMemoLine.SETRANGE("Document No.",DocNo);
      IF ServCrMemoLine.FINDSET THEN
         REPEAT
           WITH TempSalesTaxLine DO BEGIN
             RESET;
             IF (ServCrMemoLine.Type <> 0 ) AND (ServCrMemoLine."Tax Area Code" <> '') THEN BEGIN
               TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
               TaxAreaLine.SETRANGE("Tax Area",ServCrMemoLine."Tax Area Code");
               TaxAreaLine.FINDSET;
               REPEAT
                 CASE TaxCountry OF
                   TaxCountry::US :  // Area Code
                     SETRANGE("Tax Area Code for Key",ServCrMemoLine."Tax Area Code");
                   TaxCountry::CA :  // Jurisdictions
                     SETRANGE("Tax Area Code for Key",'');
                 END;
                 ServCrMemoLine.TESTFIELD("Tax Group Code");
                 SETRANGE("Tax Group Code",ServCrMemoLine."Tax Group Code");
                 SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
                 IF NOT FINDFIRST THEN BEGIN
                   INIT;
                   CASE TaxCountry OF
                     TaxCountry::US :  // Area Code
                       "Tax Area Code for Key" := ServCrMemoLine."Tax Area Code";
                     TaxCountry::CA :  // Jurisdictions
                       "Tax Area Code for Key" := '';
                   END;
                   "Tax Group Code" := ServCrMemoLine."Tax Group Code";
                   "Tax Area Code" := ServCrMemoLine."Tax Area Code";
                   "Tax Jurisdiction Code" := TaxAreaLine."Tax Jurisdiction Code";
                   IF TaxCountry = TaxCountry::US THEN BEGIN
                     IF "Tax Area Code" <> TaxArea.Code THEN
                       TaxArea.GET("Tax Area Code");
                     "Round Tax" := TaxArea."Round Tax";
                     TaxJurisdiction.GET("Tax Jurisdiction Code");
                     "Is Report-to Jurisdiction" :=
                       ("Tax Jurisdiction Code" = TaxJurisdiction."Report-to Jurisdiction");
                   END;
                   "Line Amount" := ServCrMemoLine."Line Amount" / ExchangeFactor;
                   "Tax Base Amount" := ServCrMemoLine."VAT Base Amount" / ExchangeFactor;
                   Quantity := ServCrMemoLine.Quantity;
                   "Tax Liable" := ServCrMemoLine."Tax Liable";

                   "Calculation Order" :=  TaxAreaLine."Calculation Order";
                   InsertRec := TRUE;
                   INSERT;
                 END ELSE BEGIN
                   "Line Amount" := "Line Amount" + (ServCrMemoLine."Line Amount" / ExchangeFactor);
                   "Tax Base Amount" := "Tax Base Amount" + (ServCrMemoLine."VAT Base Amount" / ExchangeFactor);
                   Quantity := Quantity + ServCrMemoLine.Quantity;
                   IF ServCrMemoLine."Tax Liable" THEN
                     "Tax Liable" := ServCrMemoLine."Tax Liable";
                   InsertRec := FALSE;
                   MODIFY;
                 END;
               UNTIL TaxAreaLine.NEXT = 0;
             END;
           END;
         UNTIL ServCrMemoLine.NEXT = 0;

      CopyTaxDifferencesToTemp(
        TaxAmountDifference."Document Product Area"::"Posted Service",
        TaxAmountDifference."Document Type"::"Credit Memo",
        ServCrMemoHeader."No.");
    END;*/

    PROCEDURE EndSalesTaxCalculation(Date: Date);
    VAR
        SalesTaxAmountLine2: Record "Sales Tax Amount Line" TEMPORARY;
        TaxAreaLine: Record 319;
        TaxDetail: Record 322;
        AddedTaxAmount: Decimal;
        TotalTaxAmount: Decimal;
        MaxAmount: Decimal;
        TaxBaseAmt: Decimal;
        TaxDetailFound: Boolean;
        LastTaxAreaCode: Code[20];
        LastTaxType: Integer;
        LastTaxGroupCode: Code[10];
        RoundTax: Option "To Nearest",Up,Down;
    BEGIN
        WITH TempSalesTaxLine DO BEGIN
            RESET;
            SETRANGE("Tax Type", "Tax Type"::"Sales and Use Tax");
            IF FINDSET THEN
                REPEAT
                    TaxDetailFound := FALSE;
                    TaxDetail.RESET;
                    TaxDetail.SETRANGE("Tax Jurisdiction Code", "Tax Jurisdiction Code");
                    IF "Tax Group Code" = '' THEN
                        TaxDetail.SETFILTER("Tax Group Code", '%1', "Tax Group Code")
                    ELSE
                        TaxDetail.SETFILTER("Tax Group Code", '%1|%2', '', "Tax Group Code");
                    IF Date = 0D THEN
                        TaxDetail.SETFILTER("Effective Date", '<=%1', WORKDATE)
                    ELSE
                        TaxDetail.SETFILTER("Effective Date", '<=%1', Date);

                    //TaxDetail.SETRANGE("Tax Type",TaxDetail."Tax Type"::"Sales and Use Tax");//GRALE02 - Delete
                    TaxDetail.SETRANGE("Tax Type", TaxDetail."Tax Type"::"Sales Tax"); //GRALE02 - Add
                                                                                       //GRALE02 - Delete Start
                                                                                       /*
                                                                                       IF "Use Tax" THEN

                                                                                         TaxDetail.SETFILTER("Tax Type",'%1|%2',TaxDetail."Tax Type"::"Sales and Use Tax",
                                                                                           TaxDetail."Tax Type"::"Use Tax Only")            
                                                                                       ELSE
                                                                                         TaxDetail.SETFILTER("Tax Type",'%1|%2',TaxDetail."Tax Type"::"Sales and Use Tax",
                                                                                           TaxDetail."Tax Type"::"Sales Tax Only");
                                                                                       */
                                                                                       //GRALE02 - Delete End
                                                                                       //GRALE02 - Add Start
                    TaxDetail.SETFILTER("Tax Type", '%1', TaxDetail."Tax Type"::"Sales Tax");
                    //GRALE02 - Add End
                    IF TaxDetail.FINDLAST THEN
                        TaxDetailFound := TRUE
                    ELSE
                        DELETE;
                    TaxDetail.SETRANGE("Tax Type", TaxDetail."Tax Type"::"Excise Tax");
                    IF TaxDetail.FIND('+') THEN BEGIN
                        TaxDetailFound := TRUE;
                        "Tax Type" := "Tax Type"::"Excise Tax";
                        INSERT;
                        "Tax Type" := "Tax Type"::"Sales and Use Tax";
                    END;
                    IF NOT TaxDetailFound THEN
                        ERROR(
                          Text1020002,
                          TaxDetail.TABLECAPTION,
                          FIELDCAPTION("Tax Jurisdiction Code"), "Tax Jurisdiction Code",
                          FIELDCAPTION("Tax Group Code"), "Tax Group Code",
                          TaxDetail.FIELDCAPTION("Effective Date"), TaxDetail.GETFILTER("Effective Date"));
                UNTIL NEXT = 0;
            RESET;
            IF FINDSET(TRUE) THEN
                REPEAT
                    TempTaxAmountDifference.RESET;
                    TempTaxAmountDifference.SETRANGE("Tax Area Code", "Tax Area Code for Key");
                    TempTaxAmountDifference.SETRANGE("Tax Jurisdiction Code", "Tax Jurisdiction Code");
                    TempTaxAmountDifference.SETRANGE("Tax Group Code", "Tax Group Code");
                    TempTaxAmountDifference.SETRANGE("Expense/Capitalize", "Expense/Capitalize");
                    TempTaxAmountDifference.SETRANGE("Tax Type", "Tax Type");
                    TempTaxAmountDifference.SETRANGE("Use Tax", "Use Tax");
                    IF TempTaxAmountDifference.FINDFIRST THEN BEGIN
                        "Tax Difference" := TempTaxAmountDifference."Tax Difference";
                        MODIFY;
                    END;
                UNTIL NEXT = 0;
            RESET;
            SETCURRENTKEY("Tax Area Code for Key", "Tax Group Code", "Tax Type", "Calculation Order");
            IF FINDLAST THEN BEGIN
                LastTaxAreaCode := "Tax Area Code for Key";
                LastCalculationOrder := -9999;
                LastTaxType := "Tax Type";
                LastTaxGroupCode := "Tax Group Code";
                RoundTax := "Round Tax";
                REPEAT
                    IF (LastTaxAreaCode <> "Tax Area Code for Key") OR
                       (LastTaxGroupCode <> "Tax Group Code")
                    THEN BEGIN
                        HandleRoundTaxUpOrDown(SalesTaxAmountLine2, RoundTax, TotalTaxAmount, LastTaxAreaCode, LastTaxGroupCode);
                        LastTaxAreaCode := "Tax Area Code for Key";
                        LastTaxType := "Tax Type";
                        LastTaxGroupCode := "Tax Group Code";
                        TaxOnTaxCalculated := FALSE;
                        LastCalculationOrder := -9999;
                        CalculationOrderViolation := FALSE;
                        TotalTaxAmount := 0;
                        RoundTax := "Round Tax";
                    END;
                    IF "Tax Type" = "Tax Type"::"Sales and Use Tax" THEN
                        TaxBaseAmt := "Tax Base Amount"
                    ELSE
                        TaxBaseAmt := Quantity;
                    IF LastCalculationOrder = "Calculation Order" THEN
                        CalculationOrderViolation := TRUE;
                    LastCalculationOrder := "Calculation Order";

                    TaxDetail.RESET;
                    TaxDetail.SETRANGE("Tax Jurisdiction Code", "Tax Jurisdiction Code");
                    IF "Tax Group Code" = '' THEN
                        TaxDetail.SETFILTER("Tax Group Code", '%1', "Tax Group Code")
                    ELSE
                        TaxDetail.SETFILTER("Tax Group Code", '%1|%2', '', "Tax Group Code");
                    IF Date = 0D THEN
                        TaxDetail.SETFILTER("Effective Date", '<=%1', WORKDATE)
                    ELSE
                        TaxDetail.SETFILTER("Effective Date", '<=%1', Date);
                    TaxDetail.SETRANGE("Tax Type", "Tax Type");
                    IF "Tax Type" = "Tax Type"::"Sales and Use Tax" THEN
                        IF "Use Tax" THEN
                            TaxDetail.SETFILTER("Tax Type", '%1|%2', "Tax Type"::"Sales and Use Tax",
                              "Tax Type"::"Use Tax Only")
                        ELSE
                            TaxDetail.SETFILTER("Tax Type", '%1|%2', "Tax Type"::"Sales and Use Tax",
                              "Tax Type"::"Sales Tax Only");
                    IF TaxDetail.FINDLAST THEN BEGIN
                        TaxOnTaxCalculated := TaxOnTaxCalculated OR TaxDetail."Calculate Tax on Tax";
                        IF TaxDetail."Calculate Tax on Tax" AND ("Tax Type" = "Tax Type"::"Sales and Use Tax") THEN
                            TaxBaseAmt := "Tax Base Amount" + TotalTaxAmount;
                        IF "Tax Liable" THEN BEGIN
                            IF (ABS(TaxBaseAmt) <= TaxDetail."Maximum Amount/Qty.") OR
                               (TaxDetail."Maximum Amount/Qty." = 0)
                            THEN
                                AddedTaxAmount := TaxBaseAmt * TaxDetail."Tax Below Maximum"
                            ELSE BEGIN
                                IF "Tax Type" = "Tax Type"::"Sales and Use Tax" THEN
                                    MaxAmount := TaxBaseAmt / ABS("Tax Base Amount") * TaxDetail."Maximum Amount/Qty."
                                ELSE
                                    MaxAmount := Quantity / ABS(Quantity) * TaxDetail."Maximum Amount/Qty.";
                                AddedTaxAmount :=
                                  (MaxAmount * TaxDetail."Tax Below Maximum") +
                                  ((TaxBaseAmt - MaxAmount) * TaxDetail."Tax Above Maximum");
                            END;
                            IF "Tax Type" = "Tax Type"::"Sales and Use Tax" THEN
                                AddedTaxAmount := AddedTaxAmount / 100.0;
                        END ELSE
                            AddedTaxAmount := 0;
                        "Tax Amount" := "Tax Amount" + AddedTaxAmount;
                        TotalTaxAmount := TotalTaxAmount + AddedTaxAmount;
                    END;
                    "Tax Amount" := "Tax Amount" + "Tax Difference";
                    TotalTaxAmount := TotalTaxAmount + "Tax Difference";
                    "Amount Including Tax" := "Tax Amount" + "Tax Base Amount";
                    IF TaxOnTaxCalculated AND CalculationOrderViolation THEN
                        ERROR(
                          Text000,
                          FIELDCAPTION("Calculation Order"), TaxArea.TABLECAPTION, "Tax Area Code",
                          TaxDetail.FIELDCAPTION("Calculate Tax on Tax"), CalculationOrderViolation);
                    SalesTaxAmountLine2.COPY(TempSalesTaxLine);
                    IF "Tax Type" = "Tax Type"::"Excise Tax" THEN
                        SalesTaxAmountLine2."Tax %" := 0
                    ELSE
                        IF "Tax Base Amount" <> 0 THEN
                            SalesTaxAmountLine2."Tax %" := 100 * ("Amount Including Tax" - "Tax Base Amount") / "Tax Base Amount"
                        ELSE
                            SalesTaxAmountLine2."Tax %" := "Tax %";
                    SalesTaxAmountLine2.INSERT;
                UNTIL NEXT(-1) = 0;
                HandleRoundTaxUpOrDown(SalesTaxAmountLine2, RoundTax, TotalTaxAmount, LastTaxAreaCode, LastTaxGroupCode);
            END;
            DELETEALL;
            SalesTaxAmountLine2.RESET;
            IF SalesTaxAmountLine2.FINDSET THEN
                REPEAT
                    TempSalesTaxLine.COPY(SalesTaxAmountLine2);
                    TempSalesTaxLine.INSERT;
                UNTIL SalesTaxAmountLine2.NEXT = 0;
        END;
    END;

    PROCEDURE GetSummarizedSalesTaxTable(VAR SummarizedSalesTaxAmtLine: Record "Sales Tax Amount Line");
    VAR
        TaxJurisdiction: Record "Tax Jurisdiction";
        RemTaxAmt: Decimal;
    BEGIN
        CLEAR(TaxJurisdiction);
        RemTaxAmt := 0;
        TempSalesTaxLine.RESET;

        WITH SummarizedSalesTaxAmtLine DO BEGIN
            DELETEALL;
            IF TempSalesTaxLine.FINDSET THEN
                REPEAT
                    CLEAR(SummarizedSalesTaxAmtLine);
                    CASE TaxCountry OF
                        TaxCountry::US:
                            BEGIN
                                "Tax Area Code for Key" := TempSalesTaxLine."Tax Area Code for Key";
                                IF TaxArea.Code <> "Tax Area Code for Key" THEN
                                    TaxArea.GET("Tax Area Code for Key");
                                "Print Description" := TaxArea.Description;
                            END;
                        TaxCountry::CA:
                            BEGIN
                                "Tax Jurisdiction Code" := TempSalesTaxLine."Tax Jurisdiction Code";
                                IF TaxJurisdiction.Code <> "Tax Jurisdiction Code" THEN BEGIN
                                    TaxJurisdiction.GET("Tax Jurisdiction Code");
                                    RemTaxAmt := 0;
                                END;
                                "Print Order" := TaxJurisdiction."Print Order";
                                "Print Description" := TaxJurisdiction."Print Description";
                                IF STRPOS("Print Description", '%1') <> 0 THEN
                                    "Tax %" := TempSalesTaxLine."Tax %";
                            END;
                    END;
                    IF NOT FIND('=') THEN
                        INSERT;
                    RemTaxAmt := RemTaxAmt + (TempSalesTaxLine."Tax Amount" * ExchangeFactor);
                    "Tax Amount" := "Tax Amount" + ROUND(RemTaxAmt, Currency."Amount Rounding Precision");
                    RemTaxAmt := RemTaxAmt - ROUND(RemTaxAmt, Currency."Amount Rounding Precision");
                    MODIFY;
                UNTIL TempSalesTaxLine.NEXT = 0;
            SETRANGE("Tax Amount", 0);
            DELETEALL;
            SETRANGE("Tax Amount");
        END;
    END;

    PROCEDURE GetSalesTaxAmountLineTable(VAR SalesTaxLine2: Record "Sales Tax Amount Line" TEMPORARY);
    BEGIN
        TempSalesTaxLine.RESET;
        IF TempSalesTaxLine.FINDSET THEN
            REPEAT
                SalesTaxLine2.COPY(TempSalesTaxLine);
                SalesTaxLine2.INSERT;
            UNTIL TempSalesTaxLine.NEXT = 0;
    END;

    /*PROCEDURE PutSalesTaxAmountLineTable(VAR SalesTaxLine2: Record "Sales Tax Amount Line" TEMPORARY;ProductArea: Integer;DocumentType: Integer;DocumentNo: Code[20]);
    BEGIN
      TempSalesTaxLine.RESET;
      TempSalesTaxLine.DELETEALL;
      IF SalesTaxLine2.FINDSET THEN
        REPEAT
          TempSalesTaxLine.COPY(SalesTaxLine2);
          TempSalesTaxLine.INSERT;
        UNTIL SalesTaxLine2.NEXT = 0;

      CreateSingleTaxDifference(ProductArea,DocumentType,DocumentNo);
    END;

    PROCEDURE DistTaxOverSalesLines(VAR SalesLine: Record 37);
    VAR
      TempSalesTaxLine2: Record "Sales Tax Amount Line" TEMPORARY;
      SalesLine2: Record 37 TEMPORARY;
      TaxAmount: Decimal;
      Amount: Decimal;
      ReturnTaxAmount: Decimal;
    BEGIN
      TotalTaxAmountRounding := 0;
      IF NOT SalesHeaderRead THEN BEGIN
        IF NOT SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.") THEN
          EXIT;
        SalesHeaderRead := TRUE;
        SetUpCurrency(SalesHeader."Currency Code");
        IF SalesHeader."Currency Factor" = 0 THEN
          ExchangeFactor := 1
        ELSE
          ExchangeFactor := SalesHeader."Currency Factor";
        IF NOT GetSalesTaxCountry(SalesHeader."Tax Area Code") THEN
          EXIT;
      END;

      WITH TempSalesTaxLine DO BEGIN
        RESET;
        IF FINDSET THEN
          REPEAT
            IF ("Tax Jurisdiction Code" <> TempSalesTaxLine2."Tax Jurisdiction Code") AND (TaxCountry = TaxCountry::CA) THEN BEGIN
              TempSalesTaxLine2."Tax Jurisdiction Code" := "Tax Jurisdiction Code";
              TotalTaxAmountRounding := 0;
            END;
            IF (TaxCountry = TaxCountry::US) THEN
              SalesLine.SETRANGE("Tax Area Code","Tax Area Code");
            SalesLine.SETRANGE("Tax Group Code","Tax Group Code");
            SalesLine.FINDSET(TRUE);
            REPEAT
              IF (TaxCountry = TaxCountry::US) OR
                 ((TaxCountry = TaxCountry::CA) AND (TaxAreaLine.GET(SalesLine."Tax Area Code","Tax Jurisdiction Code"))) THEN BEGIN
                IF "Tax Type" = "Tax Type"::"Sales and Use Tax" THEN BEGIN
                  Amount := (SalesLine."Line Amount" -  SalesLine."Inv. Discount Amount");
                  TaxAmount := Amount * "Tax %" / 100;
                END ELSE BEGIN
                  IF (SalesLine."Quantity (Base)" = 0) OR (Quantity = 0) THEN
                    TaxAmount := 0
                  ELSE
                    TaxAmount := "Tax Amount" * ExchangeFactor * SalesLine."Quantity (Base)" / Quantity;
                END;
                IF TaxAmount = 0 THEN
                  ReturnTaxAmount := 0
                ELSE BEGIN
                  ReturnTaxAmount := ArithmeticRound(TaxAmount + TotalTaxAmountRounding,Currency."Amount Rounding Precision");
                  TotalTaxAmountRounding := TaxAmount + TotalTaxAmountRounding - ReturnTaxAmount;
                END;
                SalesLine.Amount :=
                  SalesLine."Line Amount" - SalesLine."Inv. Discount Amount";
                SalesLine."VAT Base Amount" := SalesLine.Amount;
                IF SalesLine2.GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") THEN BEGIN
                  SalesLine2."Amount Including VAT" := SalesLine2."Amount Including VAT" + ReturnTaxAmount;
                  SalesLine2.MODIFY;
                END ELSE BEGIN
                  SalesLine2.COPY(SalesLine);
                  SalesLine2."Amount Including VAT" := SalesLine.Amount + ReturnTaxAmount;
                  SalesLine2.INSERT;
                END;
                IF  SalesLine."Tax Liable" THEN
                  SalesLine."Amount Including VAT" := SalesLine2."Amount Including VAT"
                ELSE
                  SalesLine."Amount Including VAT" := SalesLine.Amount;
                IF SalesLine.Amount <> 0 THEN
                  SalesLine."VAT %" :=
                    ROUND(100 * ( SalesLine."Amount Including VAT" - SalesLine.Amount) / SalesLine.Amount,0.00001)
                ELSE
                   SalesLine."VAT %" := 0;
                SalesLine.MODIFY;
              END;
            UNTIL SalesLine.NEXT = 0;
          UNTIL NEXT = 0;
        SalesLine.SETRANGE("Tax Area Code");
        SalesLine.SETRANGE("Tax Group Code");
        SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");;
        IF SalesLine.FINDSET(TRUE) THEN
          REPEAT
            SalesLine."Amount Including VAT" := ROUND(SalesLine."Amount Including VAT",Currency."Amount Rounding Precision");
            SalesLine.Amount :=
              ROUND(SalesLine."Line Amount" - SalesLine."Inv. Discount Amount",Currency."Amount Rounding Precision");
            SalesLine."VAT Base Amount" := SalesLine.Amount;
            IF SalesLine.Quantity = 0 THEN
              SalesLine.VALIDATE("Outstanding Amount",SalesLine."Amount Including VAT")
            ELSE
              SalesLine.VALIDATE(
                "Outstanding Amount",
                ROUND(
                  SalesLine."Amount Including VAT" * SalesLine."Outstanding Quantity" / SalesLine.Quantity,
                  Currency."Amount Rounding Precision"));
            IF (SalesLine."Tax Area Code" = '') AND ("Tax Area Code" <> '') THEN
              SalesLine."Amount Including VAT" := SalesLine.Amount;
            SalesLine.MODIFY;
          UNTIL SalesLine.NEXT = 0;
      END;
    END;

    PROCEDURE DistTaxOverPurchLines(VAR PurchLine: Record 39);
    VAR
      SalesTaxLine: Record "Sales Tax Amount Line" TEMPORARY;
      TempSalesTaxLine2: Record "Sales Tax Amount Line" TEMPORARY;
      PurchLine2: Record 39 TEMPORARY;
      PurchLine3: Record 39 TEMPORARY;
      TaxAmount: Decimal;
      ReturnTaxAmount: Decimal;
      Amount: Decimal;
      ExpenseTaxAmountRounding: Decimal;
    BEGIN
      TotalTaxAmountRounding := 0;
      ExpenseTaxAmountRounding := 0;
      IF NOT PurchHeaderRead THEN BEGIN
        IF NOT PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.") THEN
          EXIT;
        PurchHeaderRead := TRUE;
        SetUpCurrency(PurchHeader."Currency Code");
        IF PurchHeader."Currency Factor" = 0 THEN
          ExchangeFactor := 1
        ELSE
          ExchangeFactor := PurchHeader."Currency Factor";
        IF NOT GetSalesTaxCountry(PurchHeader."Tax Area Code") THEN
          EXIT;
      END;

      WITH TempSalesTaxLine DO BEGIN
        RESET;
        // LOCKING
        IF FINDSET THEN
          REPEAT
            IF ("Tax Jurisdiction Code" <> TempSalesTaxLine2."Tax Jurisdiction Code") AND (TaxCountry = TaxCountry::CA) THEN BEGIN
              // round by Jurisdiction for CA
              TempSalesTaxLine2."Tax Jurisdiction Code" := "Tax Jurisdiction Code";
              TotalTaxAmountRounding := 0;
              ExpenseTaxAmountRounding := 0;
            END;
            IF (TaxCountry = TaxCountry::US) THEN
              PurchLine.SETRANGE("Tax Area Code","Tax Area Code");
            PurchLine.SETRANGE("Tax Group Code","Tax Group Code");
            PurchLine.SETRANGE("Use Tax","Use Tax");
            PurchLine.FINDSET(TRUE);
            REPEAT
              IF (TaxCountry = TaxCountry::US) OR
                 ((TaxCountry = TaxCountry::CA) AND (TaxAreaLine.GET(PurchLine."Tax Area Code","Tax Jurisdiction Code"))) THEN BEGIN
                IF "Tax Type" = "Tax Type"::"Sales and Use Tax" THEN BEGIN
                  Amount := (PurchLine."Line Amount" -  PurchLine."Inv. Discount Amount");
                  TaxAmount := Amount * "Tax %" / 100;
                END ELSE BEGIN
                  IF (PurchLine."Quantity (Base)" = 0) OR (Quantity = 0) THEN
                    TaxAmount := 0
                  ELSE
                    TaxAmount := "Tax Amount" * ExchangeFactor * PurchLine."Quantity (Base)" / Quantity;
                END;
                IF (PurchLine."Use Tax" OR "Expense/Capitalize") AND (TaxAmount <> 0) THEN BEGIN
                  ExpenseTaxAmountRounding := ExpenseTaxAmountRounding + TaxAmount;
                  IF PurchLine3.GET(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") THEN BEGIN
                    PurchLine3."Tax To Be Expensed" :=
                      ArithmeticRound(
                        PurchLine3."Tax To Be Expensed" + ExpenseTaxAmountRounding,
                        Currency."Amount Rounding Precision");
                    PurchLine3.MODIFY;
                  END ELSE BEGIN
                    PurchLine3.COPY(PurchLine);
                    PurchLine3."Tax To Be Expensed" :=
                      ArithmeticRound(
                        ExpenseTaxAmountRounding,
                        Currency."Amount Rounding Precision");
                    PurchLine3.INSERT;
                  END;
                  PurchLine."Tax To Be Expensed" := PurchLine3."Tax To Be Expensed";
                  ExpenseTaxAmountRounding :=
                    ExpenseTaxAmountRounding -
                      ArithmeticRound(
                        ExpenseTaxAmountRounding,
                        Currency."Amount Rounding Precision");
                END ELSE BEGIN
                  IF NOT PurchLine3.GET(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") THEN BEGIN
                    PurchLine3.COPY(PurchLine);
                    PurchLine3."Tax To Be Expensed" := 0;
                    PurchLine3.INSERT;
                  END;
                  PurchLine."Tax To Be Expensed" := PurchLine3."Tax To Be Expensed";
                END;
                IF PurchLine."Use Tax" THEN
                  TaxAmount := 0;
                IF TaxAmount = 0 THEN
                  ReturnTaxAmount := 0
                ELSE BEGIN
                  ReturnTaxAmount := ArithmeticRound(TaxAmount + TotalTaxAmountRounding,Currency."Amount Rounding Precision");
                  TotalTaxAmountRounding := TaxAmount + TotalTaxAmountRounding - ReturnTaxAmount;
                END;
                PurchLine.Amount := PurchLine."Line Amount" - PurchLine."Inv. Discount Amount";
                PurchLine."VAT Base Amount" := PurchLine.Amount;
                IF PurchLine2.GET(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") THEN BEGIN
                  PurchLine2."Amount Including VAT" := PurchLine2."Amount Including VAT" + ReturnTaxAmount;
                  PurchLine2.MODIFY;
                END ELSE BEGIN
                  PurchLine2.COPY(PurchLine);
                  PurchLine2."Amount Including VAT" := PurchLine.Amount + ReturnTaxAmount;
                  PurchLine2.INSERT;
                END;
                IF PurchLine."Tax Liable" THEN
                  PurchLine."Amount Including VAT" := PurchLine2."Amount Including VAT"
                ELSE
                  PurchLine."Amount Including VAT" := PurchLine.Amount;
                IF PurchLine.Amount <> 0 THEN
                  PurchLine."VAT %" :=
                    ROUND(100 * ( PurchLine."Amount Including VAT" - PurchLine.Amount) / PurchLine.Amount,0.00001)
                ELSE
                   PurchLine."VAT %" := 0;
                PurchLine.MODIFY;
              END;
            UNTIL PurchLine.NEXT = 0;
          UNTIL NEXT = 0;
        PurchLine.SETRANGE("Tax Area Code");
        PurchLine.SETRANGE("Tax Group Code");
        PurchLine.SETRANGE("Use Tax");
        PurchLine.SETRANGE("Document Type",PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.",PurchHeader."No.");;
        IF PurchLine.FINDSET(TRUE) THEN
          REPEAT
            PurchLine."Amount Including VAT" := ROUND(PurchLine."Amount Including VAT",Currency."Amount Rounding Precision");
            PurchLine.Amount :=
              ROUND(PurchLine."Line Amount" - PurchLine."Inv. Discount Amount",Currency."Amount Rounding Precision");
            PurchLine."VAT Base Amount" := PurchLine.Amount;
            IF PurchLine.Quantity = 0 THEN
              PurchLine.VALIDATE("Outstanding Amount",PurchLine."Amount Including VAT")
            ELSE
              PurchLine.VALIDATE(
                "Outstanding Amount",
                ROUND(
                  PurchLine."Amount Including VAT" * PurchLine."Outstanding Quantity" / PurchLine.Quantity,
                  Currency."Amount Rounding Precision"));
            IF (PurchLine."Tax Area Code" = '') AND ("Tax Area Code" <> '') THEN
              PurchLine."Amount Including VAT" := PurchLine.Amount;
            IF PurchLine.Amount <> 0 THEN
              PurchLine.MODIFY;
          UNTIL PurchLine.NEXT = 0;
      END;
    END;

    PROCEDURE DistTaxOverServLines(VAR ServLine: Record 5902);
    VAR
      TempSalesTaxLine2: Record "Sales Tax Amount Line" TEMPORARY;
      ServLine2: Record 5902 TEMPORARY;
      TaxAmount: Decimal;
      Amount: Decimal;
      ReturnTaxAmount: Decimal;
    BEGIN
      TotalTaxAmountRounding := 0;
      IF NOT ServHeaderRead THEN BEGIN
        IF NOT ServiceHeader.GET(ServLine."Document Type",ServLine."Document No.") THEN
          EXIT;
        ServHeaderRead := TRUE;
        SetUpCurrency(ServiceHeader."Currency Code");
        IF ServiceHeader."Currency Factor" = 0 THEN
          ExchangeFactor := 1
        ELSE
          ExchangeFactor := ServiceHeader."Currency Factor";
        IF NOT GetSalesTaxCountry(ServiceHeader."Tax Area Code") THEN
          EXIT;
      END;

      WITH TempSalesTaxLine DO BEGIN
        RESET;
        IF FINDSET THEN
          REPEAT
            IF ("Tax Jurisdiction Code" <> TempSalesTaxLine2."Tax Jurisdiction Code") AND (TaxCountry = TaxCountry::CA) THEN BEGIN
              TempSalesTaxLine2."Tax Jurisdiction Code" := "Tax Jurisdiction Code";
              TotalTaxAmountRounding := 0;
            END;
            IF (TaxCountry = TaxCountry::US) THEN
              ServLine.SETRANGE("Tax Area Code","Tax Area Code");
            ServLine.SETRANGE("Tax Group Code","Tax Group Code");
            ServLine.FINDSET(TRUE);
            REPEAT
              IF (TaxCountry = TaxCountry::US) OR
                 ((TaxCountry = TaxCountry::CA) AND (TaxAreaLine.GET(ServLine."Tax Area Code","Tax Jurisdiction Code"))) THEN BEGIN
                IF "Tax Type" = "Tax Type"::"Sales and Use Tax" THEN BEGIN
                  Amount := (ServLine."Line Amount" -  ServLine."Inv. Discount Amount");
                  TaxAmount := Amount * "Tax %" / 100;
                END ELSE BEGIN
                  IF (ServLine."Quantity (Base)" = 0) OR (Quantity = 0) THEN
                    TaxAmount := 0
                  ELSE
                    TaxAmount := "Tax Amount" * ExchangeFactor * ServLine."Quantity (Base)" / Quantity;
                END;
                IF TaxAmount = 0 THEN
                  ReturnTaxAmount := 0
                ELSE BEGIN
                  ReturnTaxAmount := ArithmeticRound(TaxAmount + TotalTaxAmountRounding,Currency."Amount Rounding Precision");
                  TotalTaxAmountRounding := TaxAmount + TotalTaxAmountRounding - ReturnTaxAmount;
                END;
                ServLine.Amount :=
                  ServLine."Line Amount" - ServLine."Inv. Discount Amount";
                ServLine."VAT Base Amount" := ServLine.Amount;
                IF ServLine2.GET(ServLine."Document Type",ServLine."Document No.",ServLine."Line No.") THEN BEGIN
                  ServLine2."Amount Including VAT" := ServLine2."Amount Including VAT" + ReturnTaxAmount;
                  ServLine2.MODIFY;
                END ELSE BEGIN
                  ServLine2.COPY(ServLine);
                  ServLine2."Amount Including VAT" := ServLine.Amount + ReturnTaxAmount;
                  ServLine2.INSERT;
                END;
                IF  ServLine."Tax Liable" THEN
                  ServLine."Amount Including VAT" := ServLine2."Amount Including VAT"
                ELSE
                  ServLine."Amount Including VAT" := ServLine.Amount;
                IF ServLine.Amount <> 0 THEN
                  ServLine."VAT %" :=
                    ROUND(100 * ( ServLine."Amount Including VAT" - ServLine.Amount) / ServLine.Amount,0.00001)
                ELSE
                   ServLine."VAT %" := 0;
                ServLine.MODIFY;
              END;
            UNTIL ServLine.NEXT = 0;
          UNTIL NEXT = 0;
        ServLine.SETRANGE("Tax Area Code");
        ServLine.SETRANGE("Tax Group Code");
        ServLine.SETRANGE("Document Type",ServiceHeader."Document Type");
        ServLine.SETRANGE("Document No.",ServiceHeader."No.");;
        IF ServLine.FINDSET(TRUE) THEN
          REPEAT
            ServLine."Amount Including VAT" := ROUND(ServLine."Amount Including VAT",Currency."Amount Rounding Precision");
            ServLine.Amount :=
              ROUND(ServLine."Line Amount" - ServLine."Inv. Discount Amount",Currency."Amount Rounding Precision");
            ServLine."VAT Base Amount" := ServLine.Amount;
            ServLine.MODIFY;
          UNTIL ServLine.NEXT = 0;
      END;
    END;*/

    PROCEDURE GetSalesTaxCountry(TaxAreaCode: Code[20]): Boolean;
    BEGIN
        IF TaxAreaCode = '' THEN
            EXIT(FALSE);
        IF TaxAreaRead THEN BEGIN
            IF TaxAreaCode = TaxArea.Code THEN
                EXIT(TRUE);
            IF TaxArea.GET(TaxAreaCode) THEN
                IF TaxCountry <> TaxArea.Country THEN  // make sure countries match
                    ERROR(Text1020000, TaxArea.Country, TaxCountry)
                ELSE
                    EXIT(TRUE);
        END ELSE
            IF TaxArea.GET(TaxAreaCode) THEN BEGIN
                TaxAreaRead := TRUE;
                TaxCountry := TaxArea.Country;
                EXIT(TRUE);
            END;

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE SetUpCurrency(CurrencyCode: Code[10]);
    BEGIN
        IF CurrencyCode = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(CurrencyCode);
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
    END;


    /*PROCEDURE ReadTempPurchHeader(TempPurchHeader: Record 38 TEMPORARY);
    BEGIN
      PurchHeader.COPY(TempPurchHeader);
      IF PurchHeader."Tax Area Code" = '' THEN
        EXIT;
      PurchHeaderRead := TRUE;
      SetUpCurrency(TempPurchHeader."Currency Code");
      IF TempPurchHeader."Currency Factor" = 0 THEN
        ExchangeFactor := 1
      ELSE
        ExchangeFactor := PurchHeader."Currency Factor";
      TempPurchHeader.DELETEALL;

      CreateSingleTaxDifference(
        TaxAmountDifference."Document Product Area"::Purchase,
        PurchHeader."Document Type",
        PurchHeader."No.");
    END;

    PROCEDURE ReadTempSalesHeader(TempSalesHeader: Record 36 TEMPORARY);
    BEGIN
      SalesHeader.COPY(TempSalesHeader);
      IF SalesHeader."Tax Area Code" = '' THEN
        EXIT;
      SalesHeaderRead := TRUE;
      SetUpCurrency(TempSalesHeader."Currency Code");
      IF TempSalesHeader."Currency Factor" = 0 THEN
        ExchangeFactor := 1
      ELSE
        ExchangeFactor := TempSalesHeader."Currency Factor";
      TempSalesHeader.DELETEALL;

      CreateSingleTaxDifference(
        TaxAmountDifference."Document Product Area"::Sales,
        SalesHeader."Document Type",
        SalesHeader."No.");
    END;

    LOCAL PROCEDURE RedistTaxLines();
    VAR
      TempSalesTaxLine2: Record "Sales Tax Amount Line" TEMPORARY;
    BEGIN
      // Create 2nd rounded Tax Amount lines
      TempSalesTaxLine2.DELETEALL;
      RedistSalesTaxLine.DELETEALL;
      WITH RedistSalesTaxLine DO BEGIN
        TempSalesTaxLine.RESET;
        IF TempSalesTaxLine.FINDSET THEN
          REPEAT
            SETRANGE("Tax Jurisdiction Code",TempSalesTaxLine."Tax Jurisdiction Code");
            SETRANGE("Tax %",TempSalesTaxLine."Tax %");
            SETRANGE("Tax Liable",TempSalesTaxLine."Tax Liable");
            SETRANGE("Use Tax",TempSalesTaxLine."Use Tax");
            SETRANGE("Expense/Capitalize",TempSalesTaxLine."Expense/Capitalize");
            IF FINDFIRST THEN BEGIN
              TempSalesTaxLine2.COPY(TempSalesTaxLine);
              TempSalesTaxLine2."Tax Group Code" := '';
              TempSalesTaxLine2."Tax Amount" := ROUND(TempSalesTaxLine2."Tax Amount" + "Tax Amount",
                                                      Currency."Amount Rounding Precision");
              TempSalesTaxLine2."Tax Base Amount" := ROUND(TempSalesTaxLine2."Tax Base Amount" + "Tax Base Amount",
                                                       Currency."Amount Rounding Precision");
              TempSalesTaxLine2."Amount Including Tax" := TempSalesTaxLine2."Tax Amount" + TempSalesTaxLine2."Tax Base Amount";
              TempSalesTaxLine2."Line Amount" := ROUND(TempSalesTaxLine2."Line Amount" + "Line Amount",
                                                      Currency."Amount Rounding Precision");
              TempSalesTaxLine2.Quantity := TempSalesTaxLine2.Quantity + Quantity;
              DELETE;
              COPY(TempSalesTaxLine2);
              INSERT;
            END ELSE BEGIN
              COPY(TempSalesTaxLine);
              "Tax Amount" := ROUND("Tax Amount",Currency."Amount Rounding Precision");
              INSERT;
            END;
          UNTIL TempSalesTaxLine.NEXT = 0;
      END;

      // Write rounded lines back to first tax line table
      TempSalesTaxLine2.DELETEALL;
      WITH TempSalesTaxLine DO BEGIN
        RedistSalesTaxLine.RESET;
        RESET;
        IF RedistSalesTaxLine.FINDSET THEN BEGIN

          REPEAT
            SETRANGE("Tax Jurisdiction Code",RedistSalesTaxLine."Tax Jurisdiction Code");
            SETRANGE("Tax Base Amount",RedistSalesTaxLine."Tax Base Amount");
            SETRANGE("Tax Liable",RedistSalesTaxLine."Tax Liable");
            SETRANGE("Use Tax",RedistSalesTaxLine."Use Tax");
            SETRANGE("Expense/Capitalize",RedistSalesTaxLine."Expense/Capitalize");
            IF FINDFIRST THEN BEGIN
              TempSalesTaxLine2.COPY(TempSalesTaxLine);
              IF TempSalesTaxLine2."Tax %" = "Tax %" THEN BEGIN
                TempSalesTaxLine2."Tax Amount" := RedistSalesTaxLine."Tax Amount";
                TempSalesTaxLine2."Amount Including Tax" := "Tax Amount" + "Tax Base Amount";
                IF TempSalesTaxLine2."Tax Base Amount" <> 0 THEN
                  TempSalesTaxLine2."Tax %" :=
                     100 * ("Amount Including Tax" - "Tax Base Amount") / "Tax Base Amount"
                ELSE
                  TempSalesTaxLine2."Tax %" := "Tax %" ;
                TempSalesTaxLine2."Line Amount" := RedistSalesTaxLine."Line Amount";
                TempSalesTaxLine2.Quantity := RedistSalesTaxLine.Quantity;
              END;
              DELETE;
              COPY(TempSalesTaxLine2);
              INSERT;
            END;
          UNTIL RedistSalesTaxLine.NEXT = 0;
        END;
      END;
    END;*/

    LOCAL PROCEDURE CopyTaxDifferencesToTemp(ProductArea: Integer; DocumentType: Integer; DocumentNo: Code[20]);
    BEGIN
        TaxAmountDifference.RESET;
        TaxAmountDifference.SETRANGE("Document Product Area", ProductArea);
        TaxAmountDifference.SETRANGE("Document Type", DocumentType);
        TaxAmountDifference.SETRANGE("Document No.", DocumentNo);
        IF TaxAmountDifference.FINDSET THEN
            REPEAT
                TempTaxAmountDifference := TaxAmountDifference;
                TempTaxAmountDifference.INSERT;
            UNTIL TaxAmountDifference.NEXT = 0
        ELSE
            CreateSingleTaxDifference(ProductArea, DocumentType, DocumentNo);
    END;


    LOCAL PROCEDURE CreateSingleTaxDifference(ProductArea: Integer; DocumentType: Integer; DocumentNo: Code[20]);
    BEGIN
        TempTaxAmountDifference.RESET;
        TempTaxAmountDifference.DELETEALL;
        TempTaxAmountDifference.INIT;
        TempTaxAmountDifference."Document Product Area" := ProductArea;
        TempTaxAmountDifference."Document Type" := DocumentType;
        TempTaxAmountDifference."Document No." := DocumentNo;
        TempTaxAmountDifference.INSERT;
    END;

    /*PROCEDURE SaveTaxDifferences();
    BEGIN
      TempTaxAmountDifference.RESET;
      IF NOT TempTaxAmountDifference.FINDFIRST THEN
        ERROR(Text1020001);

      TaxAmountDifference.RESET;
      TaxAmountDifference.SETRANGE("Document Product Area",TempTaxAmountDifference."Document Product Area");
      TaxAmountDifference.SETRANGE("Document Type",TempTaxAmountDifference."Document Type");
      TaxAmountDifference.SETRANGE("Document No.",TempTaxAmountDifference."Document No.");
      TaxAmountDifference.DELETEALL;

      TempSalesTaxLine.RESET;
      TempSalesTaxLine.SETFILTER("Tax Difference",'<>0');
      IF TempSalesTaxLine.FINDSET THEN
        REPEAT
          TaxAmountDifference."Document Product Area" := TempTaxAmountDifference."Document Product Area";
          TaxAmountDifference."Document Type" := TempTaxAmountDifference."Document Type";
          TaxAmountDifference."Document No." := TempTaxAmountDifference."Document No.";
          TaxAmountDifference."Tax Area Code" := TempSalesTaxLine."Tax Area Code for Key";
          TaxAmountDifference."Tax Jurisdiction Code" := TempSalesTaxLine."Tax Jurisdiction Code";
          TaxAmountDifference."Tax %" := TempSalesTaxLine."Tax %";
          TaxAmountDifference."Tax Group Code" := TempSalesTaxLine."Tax Group Code";
          TaxAmountDifference."Expense/Capitalize" := TempSalesTaxLine."Expense/Capitalize";
          TaxAmountDifference."Tax Type" := TempSalesTaxLine."Tax Type";
          TaxAmountDifference."Use Tax" := TempSalesTaxLine."Use Tax";
          TaxAmountDifference."Tax Difference" := TempSalesTaxLine."Tax Difference";
          TaxAmountDifference.INSERT;
        UNTIL TempSalesTaxLine.NEXT = 0;
    END;

    PROCEDURE CalculateExpenseTax(TaxAreaCode: Code[20];TaxGroupCode: Code[10];TaxLiable: Boolean;Date: Date;Amount: Decimal;Quantity: Decimal;ExchangeRate: Decimal) TaxAmount: Decimal;
    VAR
      MaxAmount: Decimal;
      TaxBaseAmount: Decimal;
    BEGIN
      TaxAmount := 0;

      IF NOT TaxLiable OR (TaxAreaCode = '') OR (TaxGroupCode = '') OR
        ((Amount = 0) AND (Quantity = 0))
      THEN
        EXIT;

      IF ExchangeRate = 0 THEN
        ExchangeFactor := 1
      ELSE
        ExchangeFactor := ExchangeRate;

      Amount := Amount / ExchangeFactor;

      TaxAreaLine.SETCURRENTKEY("Tax Area","Calculation Order");
      TaxAreaLine.SETRANGE("Tax Area",TaxAreaCode);
      TaxAreaLine.FINDLAST;
      LastCalculationOrder := TaxAreaLine."Calculation Order" + 1;
      TaxOnTaxCalculated := FALSE;
      CalculationOrderViolation := FALSE;
      REPEAT
        IF TaxAreaLine."Calculation Order" >= LastCalculationOrder THEN
          CalculationOrderViolation := TRUE
        ELSE
          LastCalculationOrder := TaxAreaLine."Calculation Order";
        TaxDetail.RESET;
        TaxDetail.SETRANGE("Tax Jurisdiction Code",TaxAreaLine."Tax Jurisdiction Code");
        IF TaxGroupCode = '' THEN
          TaxDetail.SETFILTER("Tax Group Code",'%1',TaxGroupCode)
        ELSE
          TaxDetail.SETFILTER("Tax Group Code",'%1|%2','',TaxGroupCode);
        IF Date = 0D THEN
          TaxDetail.SETFILTER("Effective Date",'<=%1',WORKDATE)
        ELSE
          TaxDetail.SETFILTER("Effective Date",'<=%1',Date);
        TaxDetail.SETRANGE("Tax Type",TaxDetail."Tax Type"::"Sales and Use Tax");
        IF TaxDetail.FINDLAST AND TaxDetail."Expense/Capitalize" THEN BEGIN
          TaxOnTaxCalculated := TaxOnTaxCalculated OR TaxDetail."Calculate Tax on Tax";
          IF TaxDetail."Calculate Tax on Tax" THEN
            TaxBaseAmount := Amount + TaxAmount
          ELSE
            TaxBaseAmount := Amount;
          TaxDetailMaximumsTemp := TaxDetail;
          IF NOT TaxDetailMaximumsTemp.FIND THEN
            TaxDetailMaximumsTemp.INSERT;
          MaxAmountPerQty := TaxDetailMaximumsTemp."Maximum Amount/Qty.";
          IF (ABS(TaxBaseAmount) <= TaxDetail."Maximum Amount/Qty.") OR
             (TaxDetail."Maximum Amount/Qty." = 0)
          THEN BEGIN
            TaxAmount := TaxAmount + TaxBaseAmount * TaxDetail."Tax Below Maximum" / 100;
            TaxDetailMaximumsTemp."Maximum Amount/Qty." := TaxDetailMaximumsTemp."Maximum Amount/Qty." - TaxBaseAmount;
            TaxDetailMaximumsTemp.MODIFY;
          END ELSE BEGIN
            MaxAmount := TaxBaseAmount / ABS(TaxBaseAmount) * TaxDetail."Maximum Amount/Qty.";
            TaxAmount :=
              TaxAmount + ((MaxAmount * TaxDetail."Tax Below Maximum") +
               ((TaxBaseAmount - MaxAmount) * TaxDetail."Tax Above Maximum")) / 100;
            TaxDetailMaximumsTemp."Maximum Amount/Qty." := 0;
            TaxDetailMaximumsTemp.MODIFY;
          END;
        END;
        TaxDetail.SETRANGE("Tax Type",TaxDetail."Tax Type"::"Excise Tax");
        IF TaxDetail.FINDLAST AND TaxDetail."Expense/Capitalize" THEN BEGIN
          TaxDetailMaximumsTemp := TaxDetail;
          IF NOT TaxDetailMaximumsTemp.FIND THEN
            TaxDetailMaximumsTemp.INSERT;
          MaxAmountPerQty := TaxDetailMaximumsTemp."Maximum Amount/Qty.";

          IF (ABS(Quantity) <= TaxDetail."Maximum Amount/Qty.") OR
             (TaxDetail."Maximum Amount/Qty." = 0)
          THEN BEGIN
            TaxAmount := TaxAmount + Quantity * TaxDetail."Tax Below Maximum";
            TaxDetailMaximumsTemp."Maximum Amount/Qty." := TaxDetailMaximumsTemp."Maximum Amount/Qty." - Quantity;
            TaxDetailMaximumsTemp.MODIFY;
          END ELSE BEGIN
            MaxAmount := Quantity / ABS(Quantity) * TaxDetail."Maximum Amount/Qty.";
            TaxAmount :=
              TaxAmount + (MaxAmount * TaxDetail."Tax Below Maximum") +
              ((Quantity - MaxAmount) * TaxDetail."Tax Above Maximum");
            TaxDetailMaximumsTemp."Maximum Amount/Qty." := 0;
            TaxDetailMaximumsTemp.MODIFY;
          END;
        END;
      UNTIL TaxAreaLine.NEXT(-1) = 0;
      TaxAmount := TaxAmount * ExchangeFactor;

      IF TaxOnTaxCalculated AND CalculationOrderViolation THEN
        ERROR(
          Text000,
          TaxAreaLine.FIELDCAPTION("Calculation Order"),TaxArea.TABLECAPTION,TaxAreaLine."Tax Area",
          TaxDetail.FIELDCAPTION("Calculate Tax on Tax"),CalculationOrderViolation);
    END;

    PROCEDURE ArithmeticRound(Amount: Decimal;RoundingPrecision: Decimal) : Decimal;
    BEGIN
      IF Amount >= 0 THEN
        EXIT(ROUND(Amount,RoundingPrecision))
      ELSE
        EXIT(ROUND(Amount + 0.000000001,RoundingPrecision));
    END;*/

    PROCEDURE HandleRoundTaxUpOrDown(VAR SalesTaxAmountLine: Record "Sales Tax Amount Line"; RoundTax: Option "To Nearest",Up,Down; TotalTaxAmount: Decimal; TaxAreaCode: Code[20]; TaxGroupCode: Code[10]);
    VAR
        RoundedAmount: Decimal;
        RoundingError: Decimal;
    BEGIN
        IF (RoundTax = RoundTax::"To Nearest") OR (TotalTaxAmount = 0) THEN
            EXIT;
        CASE RoundTax OF
            RoundTax::Up:
                RoundedAmount := ROUND(TotalTaxAmount, 0.01, '>');
            RoundTax::Down:
                RoundedAmount := ROUND(TotalTaxAmount, 0.01, '<');
        END;
        RoundingError := RoundedAmount - TotalTaxAmount;
        WITH SalesTaxAmountLine DO BEGIN
            RESET;
            SETRANGE("Tax Area Code for Key", TaxAreaCode);
            SETRANGE("Tax Group Code", TaxGroupCode);
            SETRANGE("Is Report-to Jurisdiction", TRUE);
            IF FINDFIRST THEN BEGIN
                DELETE;
                "Tax Amount" := "Tax Amount" + RoundingError;
                "Amount Including Tax" := "Tax Amount" + "Tax Base Amount";
                IF "Tax Type" = "Tax Type"::"Excise Tax" THEN
                    "Tax %" := 0
                ELSE
                    IF "Tax Base Amount" <> 0 THEN
                        "Tax %" := 100 * ("Amount Including Tax" - "Tax Base Amount") / "Tax Base Amount";
                INSERT;
            END;
        END;
    END;
}

