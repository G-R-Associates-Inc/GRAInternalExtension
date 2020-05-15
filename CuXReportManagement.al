/**
* This codeunit will subscribe to onAfterSubstituteReport in Codeunit 44 - Report Mamagement
*
*   Documentation Section
*       GRALE01 - 05/15/20 - Lina El Sadek, G.R. & Associates Inc.
*               - Created codeunit.
*/

codeunit 50108 CuXReportManagement
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin

        if ReportId = Report::"Check (Stub/Check/Stub)" then
            NewReportId := Report::"Check (Stub/Check/Stub) Custom";

        if ReportId = Report::"Check (Stub/Stub/Check)" then
            NewReportId := Report::"Check (Stub/Stub/Check) Custom";
    end;

}