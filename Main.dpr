program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  EPfunctions;

function WSortField: Byte;
var
  Menu: Char;
begin
  repeat
    Writeln('�������� ���� ��� ����������:');
    Writeln('1. ��� ����������');
    Writeln('2. ���');
    Writeln('3. ���������');
    Writeln('4. ���������� ������� ����� � ����');
    Writeln('5. ��� ������������');
    Writeln;
    Readln(Menu);
    Writeln;
  until (Menu >= '1') and (Menu <= '5');
  Result := Ord(Menu) - Ord('0');
end;

function PSortField: Byte;
var
  Menu: string;
  isCorrect: Boolean;
begin
  isCorrect := False;
  repeat
    Writeln('�������� ���� ��� ����������:');
    Writeln('1. ��� �������');
    Writeln('2. ��� �����������');
    Writeln('3. ��� ������������');
    Writeln('4. ���� ���������');
    Writeln('5. ���� �����');
    Writeln;
    Readln(Menu);
    Writeln;
    isCorrect := (Length(Menu) = 1) and (Menu >= '1') and (Menu <= '5');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
end;

function PCompare(Temp1, Temp2: PPointer; Field: Byte): Boolean;
begin
  case Field of
    1:
      Result := Temp1^.Data.Name > Temp2^.Data.Name;
    2:
      Result := Temp1^.Data.ExecCode > Temp2^.Data.ExecCode;
    3:
      Result := Temp1^.Data.ManagerCode > Temp2^.Data.ManagerCode;
    4:
      Result := Temp1^.Data.Name > Temp2^.Data.Name; // ��������� �� ���� ������
    5:
      Result := Temp1^.Data.Name > Temp2^.Data.Name; // ��������� �� ���� �����
  end;
end;

function WCompare(Temp1, Temp2: WPointer; Field: Byte): Boolean;
begin
  case Field of
    1:
      Result := Temp1^.Data.Code > Temp2^.Data.Code;
    2:
      begin
        if Temp1^.Data.Surname <> Temp2^.Data.Surname then
          Result := Temp1^.Data.Surname > Temp2^.Data.Surname
        else if Temp1^.Data.Name <> Temp2^.Data.Name then
          Result := Temp1^.Data.Name > Temp2^.Data.Name
        else
          Result := Temp1^.Data.MiddleName > Temp2^.Data.MiddleName;
      end;
    3:
      Result := Temp1^.Data.Position > Temp2^.Data.Position;
    4:
      Result := Temp1^.Data.Hours > Temp2^.Data.Hours;
    5:
      Result := Temp1^.Data.ManagerCode > Temp2^.Data.ManagerCode;
  end;
end;

procedure PSort(PHead: PPointer; Field: Byte);
var
  Current, Left: PPointer;
begin
  Left := PHead^.Next;
  while Left^.Next <> nil do
  begin
    Current := Left;
    while Current^.Next <> nil do
    begin
      if PCompare(Current, Current^.Next, Field) then
        PSwap(PHead, Current, Current^.Next)
      else
        Current := Current^.Next;
    end;
    Left := Left^.Next;
  end;
end;

procedure WSort(WHead: WPointer; Field: Byte);
var
  Current, Left: WPointer;
begin
  Left := WHead^.Next;
  while Left^.Next <> nil do
  begin
    Current := Left;
    while Current^.Next <> nil do
    begin
      if WCompare(Current, Current^.Next, Field) then
        WSwap(WHead, Current, Current^.Next)
      else
        Current := Current^.Next;
    end;
    Left := Left^.Next;
  end;
end;

{
  procedure Sort(PHead: PPointer; WHead: WPointer);
  var
  Field: Byte;
  begin
  Writeln('�������� ������ ��� ����������:');
  case ChooseList of
  1:
  WSort(WHead, WField);
  2:
  PSort(PHead, PField);
  end;
  end;

}

procedure Menu;
var
  isCorrect: Boolean;
  PunktOfMenu: string;
  PHead: PPointer;
  WHead: WPointer;
  FileName: string;
  P: FP;
  W: FW;
begin
  isCorrect := False;
  New(PHead);
  New(WHead);
  PHead^.Next := nil;
  WHead^.Next := nil;
  repeat
    Writeln('�������� ����� ����');
    Writeln('1. ������ ������ �� �����');
    Writeln('2. �������� ����� ������');
    Writeln('3. ���������� ������');
    Writeln('4. ����� ������ � ��������');
    Writeln('5. ���������� ������ � ������');
    Writeln('6. �������� ������ �� ������');
    Writeln('7. �������������� ������');
    Writeln('8. ��');
    Writeln('9. ����� �� ��������� ��� ����������');
    Writeln('10. ����� � ����������� ���������');
    Writeln;
    Readln(PunktOfMenu);
    Writeln;
    isCorrect := (Length(PunktOfMenu) = 1) and (PunktOfMenu >= '1') and
      (PunktOfMenu <= '9') or (PunktOfMenu = '10');
    if isCorrect then
    begin
      case StrToInt(PunktOfMenu) of
        1:
          ReadFromFile(PHead, WHead);
        2:
          MenuPrint(PHead, WHead);
        3:
          Writeln('Sort'); // Sort(PHead, WHead);
        4:
          Search(PHead, WHead);
        5:
          MenuEnter(PHead, WHead);
        6:
          Writeln('��������...');
        7:
          Writeln('��������������...');
        8:
          Writeln('��...');
        10:
          WriteToFile(PHead, WHead);
      end;
      Writeln;
    end
    else
    begin
      Writeln('������. ������� ��� ���:');
      Writeln;
    end;
  until (PunktOfMenu = '10') or (PunktOfMenu = '9');
  DisposeAll(WHead, PHead);
end;

begin
  Menu;

end.
