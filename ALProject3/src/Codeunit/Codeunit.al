codeunit 90000 "My Codeunit" // 
{
    trigger OnRun()
    begin
        // num1 := 2;
        // num2 := 3;
        // add(num1, num2);
        // RPO()
    end;


    procedure CreateProdOrder("Document No": Code[20]) // ส่ง Document No ของ Header
    var
        productgradesortingline: Record "product grade sorting line";
        ProductionOrder: Record "Production Order";
        NoSeriesLine: Record "No. Series Line";

    begin
        productgradesortingline.Reset();
        productgradesortingline.SetRange("Document No", "Document No"); // หาค่า Document No ที่เหมือนกัน F-QC
        productgradesortingline.SetFilter("References Production order", '%1', ''); // หาค่า ถ้า References Production order 

        if productgradesortingline.FindSet() then begin
            repeat
                ProductionOrder.Reset();
                ProductionOrder.SetRange("References Document No", productgradesortingline."Document No"); // หาค่า F-QC
                ProductionOrder.SetRange("References Line No", productgradesortingline."Line No"); // หาค่า บรรทัดไลน์ 10000,20000,..


                if not ProductionOrder.FindSet() then begin // ถ้าไม่เจอใบสั้งผลิต ให้ทำการสร้างใบสั้งผลิต
                    ProductionOrder.Init();
                    ProductionOrder.Status := ProductionOrder.Status::Released;
                    ProductionOrder."No." := NoSeriesLine."Last No. Used";
                    ProductionOrder."References Document No" := "Document No";
                    ProductionOrder."Source No." := productgradesortingline."Defact item No.";
                    ProductionOrder."Creation Date" := Today;
                    ProductionOrder."Description" := productgradesortingline.Description;
                    ProductionOrder."Search Description" := productgradesortingline.Description;
                    ProductionOrder.Quantity := productgradesortingline."Defact Qty";
                    ProductionOrder."References Document No" := productgradesortingline."Document No";
                    ProductionOrder."References Line No" := productgradesortingline."Line No";
                    ProductionOrder."Defact Daecription" := productgradesortingline."Defact Daecription";
                    ProductionOrder.Insert(true);
                    productgradesortingline."References Production order" := ProductionOrder."No.";
                    productgradesortingline.Modify();
                end else begin // ถ้าเจอใบสั้งผลิต ให้้ ERROR ว่ามีใบสั้งผลิตอยู๋แล้ว
                    Error('เอกสาร %1 อยู่ในใบสั่งผลิต %2', productgradesortingline."Document No", ProductionOrder."No.");
                end;
            until productgradesortingline.Next() = 0;
            Message('เอกสาร %1 ใบสั้งผลิตที่ %2 \\ เอกสารถูกสร้างเรียบร้อย', productgradesortingline."Document No", ProductionOrder."No.");
        end;
    end;

}