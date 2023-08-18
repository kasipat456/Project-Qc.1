table 90011 "product grade sorting line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Defact item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Defact Reason Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
            trigger OnValidate()
            var
                ReasonCode: Record "Reason Code";
            begin
                ReasonCode.Reset();
                if ReasonCode.Get("Defact Reason Code") then begin
                    Validate("Defact Daecription", ReasonCode.Description);
                end;
            end;
        }
        field(6; "Defact Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                defactqty();
            end;
        }
        field(7; "Defact Daecription"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "References Production order"; Code[100])
        {
            Caption = 'References Production order';
            DataClassification = ToBeClassified;
        }
        field(9; "No.Series"; Code[20])
        {
            Caption = 'No.Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Document No", "Line No")
        {
            Clustered = true;
        }
    }

    var
        NoSeriesLine: Record "No. Series Line";
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;


    trigger OnInsert()
    var

    begin

    end;

    trigger OnModify() // ห้ามแก้ไขไลน์
    begin

    end;



    trigger OnDelete() // ห้ามลบ LIne 
    var
        ProductionOrder: Record "Production Order";

    begin
        ProductionOrder.Reset();
        ProductionOrder.SetRange("References Document No", "Document No");
        ProductionOrder.SetRange("References Line No", "Line No");
        if ProductionOrder.FindSet() then begin
            Error('ไม่สามรถลบไลน์ได้เพราะเอกสารถูกสร้างไปแล้ว');
            // Error('cannot be deleted because it has already been created');
        end;
    end;

    trigger OnRename()
    begin

    end;

    procedure insertNoSeries()
    var
        ProdgradesortingLn: Record "product grade sorting line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

    end;

    procedure defactqty()
    var
        ProdgradesortingLn: Record "product grade sorting line";
        ProdgradesortingHdr: Record "product grade sorting header";
        total: Decimal;
        total2: Decimal;
        totalscap: Decimal;
        totalscap2: Decimal;
    begin
        ProdgradesortingHdr.Reset();
        ProdgradesortingHdr.SetRange("Document No", Rec."Document No");
        if ProdgradesortingHdr.FindSet() then begin

            Clear(total2);
            Clear(totalscap);
            Clear(totalscap2);
            ProdgradesortingLn.Reset();
            ProdgradesortingLn.SetRange("Document No", Rec."Document No");
            if ProdgradesortingLn.FindSet() then begin

                Clear(total);
                repeat
                    if ProdgradesortingLn."Defact item No." = ProdgradesortingHdr."Item C" then begin // ดูว่า Item C มันตรงกันไหม

                        total += ProdgradesortingLn."Defact Qty"; // 
                    end;
                    if ProdgradesortingLn."Defact item No." = ProdgradesortingHdr."Item Scap" then begin
                        totalscap += ProdgradesortingLn."Defact Qty";
                    end;

                until ProdgradesortingLn.Next() = 0;

                if ProdgradesortingLn."Defact item No." = ProdgradesortingHdr."Item C" then begin
                    total2 := total + Rec."Defact Qty";
                    // Message('%1', total2);
                end;
                if ProdgradesortingLn."Defact item No." = ProdgradesortingHdr."Item Scap" then begin
                    totalscap2 := totalscap + Rec."Defact Qty";
                end;
            end;
            ProdgradesortingHdr.Reset();
            ProdgradesortingHdr.SetRange("Document No", Rec."Document No");
            if ProdgradesortingHdr.FindSet() then begin
                if total2 > ProdgradesortingHdr."Grade C number" then
                    Error('ค่าเกรด C เกิน');
            end;
            if totalscap2 > ProdgradesortingHdr."Grade Scap number" then
                Error('ค่าเกรด scap เกิน');
        end;
    end;






}