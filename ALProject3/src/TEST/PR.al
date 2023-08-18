
// trigger OnInsert()
// begin
//     if "Document No" = '' then begin // ถ้า Document เป็นค่าว่าง 
//         InvenSetup.Get();
//         InvenSetup.TestField("Document No"); // ทดสอบว่าข้อมูลตรงกันไหม
//         NoSeriesMgt.InitSeries(InvenSetup."Document No", xRec."No.Series", 0D, "Document No", "No.Series"); //ก็ไปทำฟังชั่น get doc no ใน no series
//     end;
//     InitRecord();
// end;

// trigger OnModify()
// var

// begin

// end;


// procedure InitRecord() // ใช้ข้างนอกและข้างในได้  InitRecord เริ่มต้นการบัทึกลงตาราง
// begin
//     "Document Date" := WorkDate();
// end;

// procedure AssistEdit(OldCertofAnalysis: Record "product grade sorting header"): Boolean
// begin
//     InvenSetup.Get(); // เรียกใช้ฟังชั่น ให้ get ข้อมูลใน inventory setup โดยใช้คำสั่ง get
//     TestNoSeries(); // จากนั้นให้ไปเข้าฟังชั่น TestNoseries
//     if NoSeriesMgt.SelectSeries(GetNoSeriesCode(), OldCertofAnalysis."No.Series", "No.Series") then begin // ถ้าเข้าเงื่อนไขก็นำ noseries มาใส่
//         TestNoSeries();
//         NoSeriesMgt.SetSeries("Document No");
//         exit(true);
//     end;
// end;

// local procedure TestNoSeries() // ใช้ได้แค่ภายใน
// begin
//     InvenSetup.TestField("Document No"); // มันจะทำการ testfield ว่ามันmatch กันไหม ละอาข้อมูลมา
// end;

// local procedure GetNoSeriesCode(): Code[20]
// begin
//     exit(InvenSetup."Document No"); // ตรงนี้คือจังหวะเอา no series มาใสใน Document No
// end;


// var
//     productgradesortingline: Record "product grade sorting line";
//     // Mycode: Codeunit "My Codeunit";
// begin
//     productgradesortingline.Reset();
//     productgradesortingline.SetRange("Document No", Rec."Document No");
//     if productgradesortingline.FindSet() then begin
//         repeat
//             ProductionOrder.Reset();
//             ProductionOrder.SetRange("References Document No", productgradesortingline."Document No");
//             ProductionOrder.SetRange("References Line No", productgradesortingline."Line No");
//             if not ProductionOrder.FindSet() then begin
//                 Message('%1', productgradesortingline);
//             end;
//         until productgradesortingline.Next() = 0;

//     end;
//     Mycode.CreateProdOrder(Rec."Document No");
// end;

//  SalesLine.Reset();
//         SalesLine.SetRange("Document Type", rec."Document Type");
//         SalesLine.SetRange("Document No.", rec."Document No.");
//         if SalesLine.FindSet() then begin
//             repeat
//                 Total += SalesLine."Amount1";
//             until SalesLine.Next() = 0;
//         end;

//         SalesHeader.Reset();
//         SalesHeader.SetRange("Document Type", Rec."Document Type");
//         SalesHeader.SetRange("No.", Rec."Document No.");
//         if SalesHeader.FindSet() then begin
//             SalesHeader.Amount2 := Total;
//             SalesHeader.Modify();
//         end;
//     end;