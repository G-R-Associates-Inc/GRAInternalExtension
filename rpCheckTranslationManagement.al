/**
*   Documentation Section
*       GRALE01 - 1/7/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created report according to definition from NAV 2009 (ID 10400).
*/

report 50105 "Check Translation Management"
{
    Caption = 'Test Check Translation Management Functions';
    DefaultLayout = RDLC;
    RDLCLayout = './ReportsLayout/CheckTranslationManagement.rdl';

    dataset
    {
        dataitem(PageLoop; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            column(TodayFormatted; Format(Today, 0, 4))
            {

            }
            column(TestLanguage; TestLanguage)
            {

            }
            column(TestCurrencyCode; TestCurrencyCode)
            {

            }
            column(TestDate; TestDate)
            {

            }
            column(CheckTransFunctionsCaption; CheckTranslationFunctionsCaptionLbl)
            {

            }

            column(TestDateCaption; TestDateCaptionLbl)
            {

            }

            column(TestLanguageCaption; TestLanguageCaptionLbl)
            {

            }

            column(TestCurrencyCodeCaption; TestCurrencyCodeCaptionLbl)
            {

            }

            column(DateToTestCaption; DateToTestCaptionLbl)
            {

            }

            dataitem(AmountTestLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(TestAmountText1; TestAmountText[1])
                {

                }

                column(TestAmountText2; TestAmountText[2])
                {

                }

                column(AmountInWordsCaption; AmountInWordsCaptionLbl)
                {

                }

                trigger OnPreDataItem();
                begin
                    if TestOption = TestOption::"Dates Only" then
                        CurrReport.Break();
                    SetRange(Number, 1, TestNumAmounts);
                end;

                trigger OnAfterGetRecord();
                begin
                    if not FormatNoText(TestAmountText, TestAmount[Number], TestLanguageCode, TestCurrencyCode) then
                        TestAmountText[1] := 'ERROR: ' + TestAmountText[1];
                end;
            }

            dataitem(DateTestLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                column(TestDateIndicator; TestDateIndicator)
                {

                }

                column(TestDateText; TestDateText)
                {

                }

                column(TestDateSeparatorFormatted; Format(TestDateSeparator[Number]))
                {

                }

                column(TestDateIndicatorCaption; TestDateIndicatorCaptionLbl)
                {

                }

                column(TestDateTextCaption; TestDateTextCaptionLbl)
                {

                }

                column(DateSeparatorCaption; DateSeparatorCaptionLbl)
                {

                }

                trigger OnPreDataItem();
                begin
                    if TestOption = TestOption::"Amounts Only" then
                        CurrReport.Break();
                    SetRange(Number, 1, TestNumDates);
                end;

                trigger OnAfterGetRecord();
                begin
                    TestDateText := FormatDate(TestDate, TestDateFormat[Number], TestDateSeparator[Number], TestLanguageCode, TestDateIndicator);
                end;
            }


        }
    }

    requestpage
    {
        SaveValues = true;

        trigger OnOpenPage();
        begin
            TestDate := WorkDate;
        end;
    }

    trigger OnPreReport();
    begin
        MakeTestData;
        case TestLanguage of
            TestLanguage::ENU:
                TestLanguageCode := 1033;
            TestLanguage::FRC:
                TestLanguageCode := 3084;
            TestLanguage::ESM:
                TestLanguageCode := 2058;
            TestLanguage::ENC:
                TestLanguageCode := 4105;
        end;
    end;


    var
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        TestDate: Date;
        TestCurrencyCode: Code[10];
        CurrencyCode: Code[10];
        TestAmount: array[50] of Decimal;
        EnglishLanguageCode: Integer;
        FrenchLanguageCode: Integer;
        SpanishLanguageCode: Integer;
        CAEnglishLanguageCode: Integer;
        LanguageCode: Integer;
        TestLanguageCode: Integer;
        TestNumAmounts: Integer;
        TestNumDates: Integer;
        HundredText: Text[30];
        AndText: Text[30];
        DollarsText: Text[30];
        ZeroText: Text[30];
        CentsText: Text[30];
        OneMillionText: Text[30];
        TestDateText: Text[30];
        TestDateIndicator: Text[30];
        TestAmountText: array[2] of Text[80];
        OnesText: array[30] of Text[30];
        TensText: array[10] of Text[30];
        HundredsText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        TestLanguage: Option ENU,ENC,FRC,ESM;
        TestOption: Option "Both Amounts and Dates","Amounts Only","Dates Only";
        TestDateFormat: array[20] of Option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD";
        TestDateSeparator: array[20] of Option " ","-",".","/";
        Text000: TextConst ENU = 'Zero', ESM = 'Cero', FRC = 'Z‚ro', ENC = 'Zero';
        Text001: TextConst ENU = 'One', ESM = 'Uno', FRC = 'Un', ENC = 'One';
        Text002: TextConst ENU = 'Two', ESM = 'Dos', FRC = 'Deux', ENC = 'Two';
        Text003: TextConst ENU = 'Three', ESM = 'Tres', FRC = 'Trois', ENC = 'Three';
        Text004: TextConst ENU = 'Four', ESM = 'Cuatro', FRC = 'Quatre', ENC = 'Four';
        Text005: TextConst ENU = 'Five', ESM = 'Cinco', FRC = 'Cinq', ENC = 'Five';
        Text006: TextConst ENU = 'Six', ESM = 'Seis', FRC = 'Six', ENC = 'Six';
        Text007: TextConst ENU = 'Seven', ESM = 'Siete', FRC = 'Sept', ENC = 'Seven';
        Text008: TextConst ENU = 'Eight', ESM = 'Ocho', FRC = 'Huit', ENC = 'Eight';
        Text009: TextConst ENU = 'Nine', ESM = 'Nueve', FRC = 'Neuf', ENC = 'Nine';
        Text010: TextConst ENU = 'Ten', ESM = 'Diez', FRC = 'Dix', ENC = 'Ten';
        Text011: TextConst ENU = 'Eleven', ESM = 'Once', FRC = 'Onze', ENC = 'Eleven';
        Text012: TextConst ENU = 'Twelve', ESM = 'Doce', FRC = 'Douze', ENC = 'Twelve';
        Text013: TextConst ENU = 'Thirteen', ESM = 'Trece', FRC = 'Treize', ENC = 'Thirteen';
        Text014: TextConst ENU = 'Fourteen', ESM = 'Catorce', FRC = 'Quatorze', ENC = 'Fourteen';
        Text015: TextConst ENU = 'Fifteen', ESM = 'Quince', FRC = 'Quinze', ENC = 'Fifteen';
        Text016: TextConst ENU = 'Sixteen', ESM = 'Diecis‚is', FRC = 'Seize', ENC = 'Sixteen';
        Text017: TextConst ENU = 'Seventeen', ESM = 'Diecisiete', FRC = 'Dix-sept', ENC = 'Seventeen';
        Text018: TextConst ENU = 'Eighteen', ESM = 'Dieciocho', FRC = 'Dix-huit', ENC = 'Eighteen';
        Text019: TextConst ENU = 'Nineteen', ESM = 'Diecinueve', FRC = 'Dix-neuf', ENC = 'Nineteen';
        Text020: TextConst ENU = 'Twenty', ESM = 'Veinte', FRC = 'Vingt', ENC = 'Twenty';
        Text021: TextConst ENU = 'Thirty', ESM = 'Treinta', FRC = 'Trente', ENC = 'Thirty';
        Text022: TextConst ENU = 'Forty', ESM = 'Cuarenta', FRC = 'Quarante', ENC = 'Forty';
        Text023: TextConst ENU = 'Fifty', ESM = 'Cincuenta', FRC = 'Cinquante', ENC = 'Fifty';
        Text024: TextConst ENU = 'Sixty', ESM = 'Sesenta', FRC = 'Soixante', ENC = 'Sixty';
        Text025: TextConst ENU = 'Seventy', ESM = 'Setenta', FRC = 'Soixante-dix', ENC = 'Seventy';
        Text026: TextConst ENU = 'Eighty', ESM = 'Ochenta', FRC = 'Quatre-vingt', ENC = 'Eighty';
        Text027: TextConst ENU = 'Ninety', ESM = 'Noventa', FRC = 'Quatre-vingt-dix', ENC = 'Ninety';
        Text028: TextConst ENU = 'Hundred', ESM = 'Cien', FRC = 'Cent', ENC = 'Hundred';
        Text029: TextConst ENU = 'and', ESM = 'y', FRC = 'et', ENC = 'and';
        Text030: TextConst ENU = 'Dollars', ESM = 'D¢lares', FRC = 'Dollars', ENC = 'Dollars';
        Text031: TextConst ENU = 'Thousand', ESM = 'Mil', FRC = 'Mille', ENC = 'Thousand';
        Text032: TextConst ENU = 'Million', ESM = 'Mill¢n', FRC = 'Million', ENC = 'Million';
        Text033: TextConst ENU = 'Billion', ESM = 'Mil millones', FRC = 'Milliard', ENC = 'Billion';
        Text035: TextConst ENU = '/100', ESM = '/100', FRC = '/100', ENC = '/100';
        Text036: TextConst ENU = 'One Million', ESM = 'Un mill¢n', FRC = 'Un million', ENC = 'One Million';
        Text041: TextConst ENU = 'Twenty One', ESM = 'Veintiuno', FRC = 'Vingt-et-un', ENC = 'Twenty One';
        Text042: TextConst ENU = 'Twenty Two', ESM = 'Veintid¢s', FRC = 'Vingt-deux', ENC = 'Twenty Two';
        Text043: TextConst ENU = 'Twenty Three', ESM = 'Veintitr‚s', FRC = 'Vingt-trois', ENC = 'Twenty Three';
        Text044: TextConst ENU = 'Twenty Four', ESM = 'Veinticuatro', FRC = 'Vingt-quatre', ENC = 'Twenty Four';
        Text045: TextConst ENU = 'Twenty Five', ESM = 'Veinticinco', FRC = 'Vingt-cinq', ENC = 'Twenty Five';
        Text046: TextConst ENU = 'Twenty Six', ESM = 'Veintis‚is', FRC = 'Vingt-six', ENC = 'Twenty Six';
        Text047: TextConst ENU = 'Twenty Seven', ESM = 'Veintisiete', FRC = 'Vingt-sept', ENC = 'Twenty Seven';
        Text048: TextConst ENU = 'Twenty Eight', ESM = 'Veintiocho', FRC = 'Vingt-huit', ENC = 'Twenty Eight';
        Text049: TextConst ENU = 'Twenty Nine', ESM = 'Veintinueve', FRC = 'Vingt-neuf', ENC = 'Twenty Nine';
        Text051: TextConst ENU = 'One Hundred', ESM = 'Cien', FRC = 'Cent', ENC = 'One Hundred';
        Text052: TextConst ENU = 'Two Hundred', ESM = 'Doscientos', FRC = 'Deux cents', ENC = 'Two Hundred';
        Text053: TextConst ENU = 'Three Hundred', ESM = 'Trescientos', FRC = 'Trois cents', ENC = 'Three Hundred';
        Text054: TextConst ENU = 'Four Hundred', ESM = 'Cuatrocientos', FRC = 'Quatre cents', ENC = 'Four Hundred';
        Text055: TextConst ENU = 'Five Hundred', ESM = 'Quinientos', FRC = 'Cinq cents', ENC = 'Five Hundred';
        Text056: TextConst ENU = 'Six Hundred', ESM = 'Seiscientos', FRC = 'Six cents', ENC = 'Six Hundred';
        Text057: TextConst ENU = 'Seven Hundred', ESM = 'Setecientos', FRC = 'Sept cents', ENC = 'Seven Hundred';
        Text058: TextConst ENU = 'Eight Hundred', ESM = 'Ochocientos', FRC = 'Huit cents', ENC = 'Eight Hundred';
        Text059: TextConst ENU = 'Nine Hundred', ESM = 'Novecientos', FRC = 'Neuf cents', ENC = 'Nine Hundred';
        Text100: TextConst ENU = 'Language Code %1 is not implemented.', ESM = 'El c¢d. idioma %1 no est  implementado.', FRC = 'Le code langue %1 n''est pas impl‚ment‚.', ENC = 'Language Code %1 is not implemented.';
        Text101: TextConst ENU = '%1 results in a written number that is too long.', ESM = 'Los resultados de %1 son un n£mero escrito demasiado largo.', FRC = '%1 r‚sultats dans un nombre ‚crit qui est trop long.', ENC = '%1 results in a written number that is too long.';
        Text102: TextConst ENU = '%1 is too large to convert to text.', ESM = '%1 es demasiado largo para convertir a texto.', FRC = '%1 est trop grand pour ˆtre converti en texte.', ENC = '%1 is too large to convert to text.';
        Text103: TextConst ENU = '%1 language is not enabled.', ESM = 'Idioma %1 no est  activado.', FRC = 'La langue %1 n''est pas activ‚e.', ENC = '%1 language is not enabled.';
        Text104: TextConst ENU = '****', ESM = '****', FRC = '****', ENC = '****';
        Text107: TextConst ENU = 'MM DD YYYY', ESM = 'MM DD AAAA', FRC = 'MM JJ AAAA', ENC = 'MM DD YYYY';
        Text108: TextConst ENU = 'DD MM YYYY', ESM = 'DD MM AAAA', FRC = 'JJ MM AAAA', ENC = 'DD MM YYYY';
        Text109: TextConst ENU = 'YYYY MM DD', ESM = 'AAAA MM DD', FRC = 'AAAA MM JJ', ENC = 'YYYY MM DD';
        Text110: TextConst ENU = 'US dollars', ESM = 'Pesos', FRC = 'Dollars US', ENC = 'CA Dollars';
        Text111: TextConst ENU = 'Mexican pesos', ESM = 'Pesos mexicanos', FRC = 'Pesos mexicains', ENC = 'Mexican pesos';
        Text112: TextConst ENU = 'Canadian dollars', ESM = 'D¢lares canadienses', FRC = 'Dollars canadiens', ENC = 'Canadian dollars';
        CheckTranslationFunctionsCaptionLbl: TextConst ENU = 'Test of Check Translation Functions', ESM = 'Funciones de traducci¢n prueba de cheque', FRC = 'Test des fonctions de traduction des chŠques', ENC = 'Test of Check Translation Functions';
        TestDateCaptionLbl: TextConst ENU = 'Test Date', ESM = 'Fecha prueba', FRC = 'Date de test', ENC = 'Test Date';
        TestLanguageCaptionLbl: TextConst ENU = 'Test Language', ESM = 'Idioma prueba', FRC = 'Langue de test', ENC = 'Test Language';
        TestCurrencyCodeCaptionLbl: TextConst ENU = 'Test Currency Code', ESM = 'C¢d. divisa prueba', FRC = 'Code devise de test', ENC = 'Test Currency Code';
        DateToTestCaptionLbl: TextConst ENU = 'Date to Test', ESM = 'Fecha para prueba', FRC = 'Date … tester', ENC = 'Date to Test';
        AmountInWordsCaptionLbl: TextConst ENU = 'Amount In Words', ESM = 'Importe en palabras', FRC = 'Montant en lettres', ENC = 'Amount In Words';
        TestDateIndicatorCaptionLbl: TextConst ENU = 'Check Date Indicator', ESM = 'Comprobar indicador fecha', FRC = 'Indicateur de date de chŠque', ENC = 'Cheque Date Indicator';
        TestDateTextCaptionLbl: TextConst ENU = 'Check Date', ESM = 'Fecha cheque', FRC = 'Date du chŠque', ENC = 'Cheque Date';
        DateSeparatorCaptionLbl: TextConst ENU = 'Check Date Separator', ESM = 'Comprobar separador fecha', FRC = 'V‚rifier s‚parateur de dates', ENC = 'Cheque Date Separator';
        USTextErr: TextConst ENU = '%1 language is not enabled. %2 is set up for checks in %1.', ESM = 'Idioma %1 no est  activado. %2 se ha configurado para cheques en %1.', FRC = 'La langue %1 n''est pas activ‚e. %2 est configur‚ pour des chŠques en %1.', ENC = '%1 language is not enabled. %2 is set up for cheques in %1.';


    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; NewLanguageCode: Integer; NewCurrencyCode: Code[10]) Result: Boolean;
    begin
        SetObjectLanguage(NewLanguageCode);

        InitTextVariable;
        GLSetup.Get;
        GLSetup.TestField("LCY Code");
        CurrencyCode := NewCurrencyCode;
        IF CurrencyCode = '' THEN BEGIN
            Currency.INIT;
            Currency.Code := GLSetup."LCY Code";
            CASE GLSetup."LCY Code" OF
                'USD':
                    Currency.Description := Text110;
                'MXP':
                    Currency.Description := Text111;
                'CAD':
                    Currency.Description := Text112;
            END;
        END ELSE
            IF NOT Currency.GET(CurrencyCode) THEN
                CLEAR(Currency);
        CLEAR(NoText);

        IF No < 1000000000000.0 THEN
            CASE LanguageCode OF
                EnglishLanguageCode, CAEnglishLanguageCode:
                    Result := FormatNoTextENU(NoText, No);
                SpanishLanguageCode:
                    Result := FormatNoTextESM(NoText, No);
                FrenchLanguageCode:
                    Result := FormatNoTextFRC(NoText, No);
                ELSE BEGIN
                        NoText[1] := STRSUBSTNO(Text100, LanguageCode);
                        Result := FALSE;
                    END;
            END
        ELSE BEGIN
            NoText[1] := STRSUBSTNO(Text102, No);
            Result := FALSE;
        END;
    end;

    local procedure SetObjectLanguage(NewLanguageCode: Integer);
    var
        WindowsLang: Record "Windows Language";
    begin
        EnglishLanguageCode := 1033;
        FrenchLanguageCode := 3084;
        SpanishLanguageCode := 2058;
        CAEnglishLanguageCode := 4105;


        WindowsLang.GET(NewLanguageCode);
        if NOT WindowsLang."Globally Enabled" then
            ERROR(Text103, WindowsLang.Name);
        LanguageCode := NewLanguageCode;
        CurrReport.LANGUAGE(LanguageCode);
    end;

    local procedure InitTextVariable();
    begin
        OnesText[1] := Text001;
        OnesText[2] := Text002;
        OnesText[3] := Text003;
        OnesText[4] := Text004;
        OnesText[5] := Text005;
        OnesText[6] := Text006;
        OnesText[7] := Text007;
        OnesText[8] := Text008;
        OnesText[9] := Text009;
        OnesText[10] := Text010;
        OnesText[11] := Text011;
        OnesText[12] := Text012;
        OnesText[13] := Text013;
        OnesText[14] := Text014;
        OnesText[15] := Text015;
        OnesText[16] := Text016;
        OnesText[17] := Text017;
        OnesText[18] := Text018;
        OnesText[19] := Text019;
        OnesText[20] := Text020;
        OnesText[21] := Text041;
        OnesText[22] := Text042;
        OnesText[23] := Text043;
        OnesText[24] := Text044;
        OnesText[25] := Text045;
        OnesText[26] := Text046;
        OnesText[27] := Text047;
        OnesText[28] := Text048;
        OnesText[29] := Text049;

        TensText[1] := Text010;
        TensText[2] := Text020;
        TensText[3] := Text021;
        TensText[4] := Text022;
        TensText[5] := Text023;
        TensText[6] := Text024;
        TensText[7] := Text025;
        TensText[8] := Text026;
        TensText[9] := Text027;

        HundredsText[1] := Text051;
        HundredsText[2] := Text052;
        HundredsText[3] := Text053;
        HundredsText[4] := Text054;
        HundredsText[5] := Text055;
        HundredsText[6] := Text056;
        HundredsText[7] := Text057;
        HundredsText[8] := Text058;
        HundredsText[9] := Text059;

        ExponentText[1] := '';
        ExponentText[2] := Text031;
        ExponentText[3] := Text032;
        ExponentText[4] := Text033;

        HundredText := Text028;
        AndText := Text029;
        DollarsText := Text030;
        ZeroText := Text000;
        CentsText := Text035;
        OneMillionText := Text036;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[40]; Divider: Text[1]): Boolean;
    begin
        if NoTextIndex > ARRAYLEN(NoText) then
            exit(FALSE);
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ARRAYLEN(NoText) then begin
                NoText[ARRAYLEN(NoText)] := STRSUBSTNO(Text101, AddText);
                exit(FALSE);
            end;
        end;

        case LanguageCode of
            EnglishLanguageCode:
                if (NoText[NoTextIndex] = Text104) then
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + UPPERCASE(AddText), '<')
                else
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + Divider + UPPERCASE(AddText), '<');
            SpanishLanguageCode:
                if (NoText[NoTextIndex] = Text104) then
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + UPPERCASE(AddText), '<')
                else
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + Divider + UPPERCASE(AddText), '<');
            CAEnglishLanguageCode:
                if (NoText[NoTextIndex] = Text104) then
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + AddText, '<')
                else
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + Divider + AddText, '<');
            FrenchLanguageCode:
                if NoText[NoTextIndex] = Text104 then
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + AddText, '<')
                else
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + Divider + LOWERCASE(AddText), '<');
        end;

        exit(TRUE);
    end;

    procedure FormatDate(Date: Date; DateFormat: Option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD"; DateSeparator: Option " ","-",".","/"; NewLanguageCode: Integer; var DateIndicator: Text[10]) ChequeDate: Text[30];
    begin
        SetObjectLanguage(NewLanguageCode);

        case DateFormat of
            DateFormat::"MM DD YYYY":
                begin
                    DateIndicator := Text107;
                    case DateSeparator of
                        0:
                            ChequeDate := FORMAT(Date, 0, '<Month,2> <Day,2> <Year4>');
                        1:
                            ChequeDate := FORMAT(Date, 0, '<Month,2>-<Day,2>-<Year4>');
                        2:
                            ChequeDate := FORMAT(Date, 0, '<Month,2>.<Day,2>.<Year4>');
                        3:
                            ChequeDate := FORMAT(Date, 0, '<Month,2>/<Day,2>/<Year4>');
                    end;
                end;
            DateFormat::"DD MM YYYY":
                begin
                    DateIndicator := Text108;
                    case DateSeparator of
                        0:
                            ChequeDate := FORMAT(Date, 0, '<Day,2> <Month,2> <Year4>');
                        1:
                            ChequeDate := FORMAT(Date, 0, '<Day,2>-<Month,2>-<Year4>');
                        2:
                            ChequeDate := FORMAT(Date, 0, '<Day,2>.<Month,2>.<Year4>');
                        3:
                            ChequeDate := FORMAT(Date, 0, '<Day,2>/<Month,2>/<Year4>');
                    end;
                end;
            DateFormat::"YYYY MM DD":
                begin
                    DateIndicator := Text109;
                    case DateSeparator of
                        0:
                            ChequeDate := FORMAT(Date, 0, '<Year4> <Month,2> <Day,2>');
                        1:
                            ChequeDate := FORMAT(Date, 0, '<Year4>-<Month,2>-<Day,2>');
                        2:
                            ChequeDate := FORMAT(Date, 0, '<Year4>.<Month,2>.<Day,2>');
                        3:
                            ChequeDate := FORMAT(Date, 0, '<Year4>/<Month,2>/<Day,2>');
                    end;
                end;
            else begin
                    DateIndicator := '';
                    ChequeDate := FORMAT(Date, 0, 4);
                end;
        end;
    end;

    local procedure FormatNoTextENU(var NoText: array[2] of Text[80]; No: Decimal): Boolean;
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        NoTextIndex := 1;
        NoText[1] := Text104;

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroText, ' ')
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds], ' ');
                    AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText, ' ');
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens], ' ');
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones], ' ');
                if PrintExponent AND (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent], ' ');
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            end;
        end;

        if LanguageCode = CAEnglishLanguageCode then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, Currency.Description, ' ');
            AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
            exit(AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + CentsText, ' '));
        end else begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
            AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + CentsText, ' ');
            exit(AddToNoText(NoText, NoTextIndex, PrintExponent, Currency.Description, ' '));
        end;
    end;

    local procedure FormatNoTextESM(var NoText: array[2] of Text[80]; No: Decimal): Boolean;
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        NoTextIndex := 1;
        NoText[1] := Text104;

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroText, ' ')
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                if Hundreds > 0 then begin
                    if (Hundreds = 1) AND (Tens = 0) AND (Ones = 0) then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText, ' ')
                    else
                        AddToNoText(NoText, NoTextIndex, PrintExponent, HundredsText[Hundreds], ' ');
                end;
                case Tens of
                    0:
                        if (Hundreds = 0) AND (Ones = 1) AND (Exponent > 1) then
                            PrintExponent := TRUE
                        else
                            if Ones > 0 then
                                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                    1, 2:
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones], ' ');
                    else begin
                            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens], ' ');
                            if Ones <> 0 then begin
                                AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
                                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                            end;
                        end;
                end;
                if PrintExponent AND (Exponent > 1) then begin
                    if (Hundreds = 0) AND (Tens = 0) AND (Ones = 1) AND (Exponent = 3) then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OneMillionText, ' ')
                    else
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent], ' ');
                end;
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            end;
        end;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Currency.Description, ' ');
        exit(AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + CentsText, ' '));
    end;

    local procedure FormatNoTextFRC(var NoText: array[2] of Text[80]; No: Decimal): Boolean;
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        NoTextIndex := 1;
        NoText[1] := Text104;

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroText, ' ')
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;

                if Hundreds = 1 then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText, ' ')
                else begin
                    if Hundreds > 1 then begin
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds], ' ');
                        if (Tens * 10 + Ones) = 0 then
                            AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText + 's', ' ')
                        else
                            AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText, ' ');
                    end;
                end;

                FormatTensFRC(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

                if PrintExponent AND (Exponent > 1) then
                    if ((Hundreds * 100 + Tens * 10 + Ones) > 1) AND (Exponent <> 2) then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent] + 's', ' ')
                    else
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent], ' ');

                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            end;
        end;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Currency.Description, ' ');
        AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
        exit(AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100, 2) + CentsText, ' '));
    end;

    local procedure FormatTensFRC(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; Exponent: Integer; Hundreds: Integer; Tens: Integer; Ones: Integer);
    begin
        case Tens of
            9:
                begin
                    if Ones = 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[9] + 's', ' ')
                    else begin
                        AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[8], ' ');
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10], '-');
                    end;
                end;
            8:
                begin
                    if Ones = 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[8] + 's', ' ')
                    else begin
                        AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[8], ' ');
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], '-');
                    end;
                end;
            7:
                begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[6], ' ');
                    if Ones = 1 then begin
                        AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10], ' ');
                    end else
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10], '-');
                end;
            2:
                begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[2], ' ');
                    if Ones > 0 then begin
                        if Ones = 1 then begin
                            AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                        end else
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], '-');
                    end;
                end;
            1:
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones], ' ');
            0:
                begin
                    if Ones > 0 then
                        if (Ones = 1) AND (Hundreds < 1) AND (Exponent = 2) then
                            PrintExponent := TRUE
                        else
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                end;
            else begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens], ' ');
                    if Ones > 0 then begin
                        if Ones = 1 then begin
                            AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                        end else
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], '-');
                    end;
                end;
        end;
    end;

    procedure MakeTestData();
    var
        i: Integer;
        j: Integer;
    begin
        TestAmount[1] := 293.38;
        TestAmount[2] := 80;
        TestAmount[3] := 100;
        TestAmount[4] := 99.45;
        TestAmount[5] := 1266;
        TestAmount[6] := 1399121.38;
        TestAmount[7] := 185.38;
        TestAmount[8] := 680.33;
        TestAmount[9] := 80.99;
        TestAmount[10] := 200.66;
        TestAmount[11] := 238.27;
        TestAmount[12] := 80765.56;
        TestAmount[13] := 1000.78;
        TestAmount[14] := 2980.32;
        TestAmount[15] := 1301476.89;
        TestAmount[16] := 2000000.38;
        TestAmount[17] := 345497.88;
        TestAmount[18] := 1000065;
        TestAmount[19] := 1500300999.38;
        TestAmount[20] := 3000000000.0;
        TestAmount[21] := 1001.99;
        TestAmount[22] := 88;
        TestAmount[23] := 121;
        TestAmount[24] := 331;
        TestAmount[25] := 3341;
        TestAmount[26] := 1051;
        TestAmount[27] := 1000061;
        TestAmount[28] := 81;
        TestAmount[29] := 11;
        TestAmount[30] := 71;
        TestAmount[31] := 91;
        TestAmount[32] := 0;
        TestAmount[33] := 1;
        TestAmount[34] := 0.99;
        TestAmount[35] := 1.23;
        TestAmount[36] := 12.34;
        TestAmount[37] := 123.45;
        TestAmount[38] := 1234.56;
        TestAmount[39] := 12345.67;
        TestAmount[40] := 123456.78;
        TestAmount[41] := 1234567.89;
        TestAmount[42] := 12345678.9;
        TestAmount[43] := 123456789.01;
        TestAmount[44] := 1234567890.12;
        TestAmount[45] := 987654321098.76;
        TestAmount[46] := 9999999999.0;
        TestAmount[47] := 1000;
        TestNumAmounts := 47;

        TestNumDates := 0;
        FOR i := 0 TO 3 DO
            FOR j := 0 TO 3 DO BEGIN
                TestNumDates := TestNumDates + 1;
                TestDateFormat[TestNumDates] := i;
                TestDateSeparator[TestNumDates] := j;
            END;
    end;

    PROCEDURE SetCheckPrintParams(NewDateFormat: option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD"; NewDateSeparator: option " ","-",".","/"; NewCountryCode: Code[10]; NewCheckLanguage: option "E English","F French","S Spanish"; CheckToAddr: Text[50]; VAR CheckDateFormat: Option; VAR DateSeparator: Option; VAR CheckLanguage: Integer; VAR CheckStyle: option " ",US,CA);
    VAR
        WindowsLanguage: Record "Windows Language";
        CompanyInformation: Record "Company Information";
    BEGIN
        CheckDateFormat := NewDateFormat;
        DateSeparator := NewDateSeparator;
        CASE NewCheckLanguage OF
            NewCheckLanguage::"E English":
                IF NewCountryCode = 'CA' THEN
                    CheckLanguage := 4105
                ELSE
                    CheckLanguage := 1033;
            NewCheckLanguage::"F French":
                CheckLanguage := 3084;
            NewCheckLanguage::"S Spanish":
                CheckLanguage := 2058;
            ELSE
                CheckLanguage := 1033;
        END;
        CompanyInformation.GET;
        CASE CompanyInformation.GetCountryRegionCode(NewCountryCode) OF
            'US', 'MX':
                CheckStyle := CheckStyle::US;
            'CA':
                CheckStyle := CheckStyle::CA;
            ELSE
                CheckStyle := CheckStyle::US;
        END;
        IF CheckLanguage <> WindowsLanguage."Language ID" THEN
            WindowsLanguage.GET(CheckLanguage);
        IF NOT WindowsLanguage."Globally Enabled" THEN BEGIN
            IF CheckLanguage = 4105 THEN
                CheckLanguage := 1033
            ELSE
                ERROR(USTextErr, WindowsLanguage.Name, CheckToAddr);
        END;
    END;
}