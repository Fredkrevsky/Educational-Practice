program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  EPfunctions;

procedure WSearch(WHead: WPointer; Field: Byte; Query: string);
var
  Exist, Match: Boolean;
begin
  Exist := False;
  WHead := WHead^.Next;
  Writeln('���������� ������:');
  while WHead <> nil do
  begin
    case Field of
      1:
        Match := IntToStr(WHead^.Data.Code) = Query;
      2:
        Match := WHead^.Data.Surname = Query;
      3:
        Match := WHead^.Data.Name = Query;
      4:
        Match := WHead^.Data.MiddleName = Query;
      5:
        Match := WHead^.Data.Position = Query;
      6:
        Match := IntToStr(WHead^.Data.Hours) = Query;
      7:
        Match := IntToStr(WHead^.Data.ManagerCode) = Query;
    end;
    if Match then
    begin
      PrintWorker(WHead);
      Exist := True;
    end;
    WHead := WHead^.Next;
  end;
  if not Exist then
    Writeln('������ �� �������');
end;

procedure PSearch(PHead: PPointer; Field: Byte; Query: string);
var
  Exist, Match: Boolean;
begin
  Exist := False;
  PHead := PHead^.Next;
  Writeln('���������� ������:');
  while PHead <> nil do
  begin
    case Field of
      1:
        Match := PHead^.Data.Name = Query;
      2:
        Match := PHead^.Data.Task = Query;
      3:
        Match := IntToStr(PHead^.Data.ExecCode) = Query;
      4:
        Match := IntToStr(PHead^.Data.ManagerCode) = Query;
      5:
        Match := PHead^.Data.IssDate = Query;
      6:
        Match := PHead^.Data.Term = Query;
    end;
    if Match then
    begin
      PrintProject(PHead);
      Exist := True;
    end;
    PHead := PHead^.Next;
  end;
  if not Exist then
    Writeln('������ �� �������');
end;

function PSearchField:Byte;
  var
  Menu: string;
  isCorrect: Boolean;
begin
  isCorrect:=False;
  repeat
    Writeln('�������� ���� ��� ������:');
    Writeln('1. ��� �������');
    Writeln('2. ������� �������');
    Writeln('3. ��� �����������');
    Writeln('4. ��� ������������');
    Writeln('5. ���� ���������');
    Writeln('6. ���� �����');
    Writeln;
    Readln(Menu);
    Writeln;
    isCorrect:= (Length(Menu) = 1) and (Menu>='1') and (Menu<='6');
    if not isCorrect then
    Writeln('������. ������� ��� ���');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
end;

function WSearchField:Byte;
  var
  Menu: string;
  isCorrect: Boolean;
begin
  isCorrect:=False;
  repeat
    Writeln('�������� ���� ��� ������:');
    Writeln('1. ��� ����������');
    Writeln('2. �������');
    Writeln('3. ���');
    Writeln('4. ��������');
    Writeln('5. ���������');
    Writeln('6. ���������� ������� ����� � ����');
    Writeln('7. ��� ������������');
    Writeln;
    Readln(Menu);
    Writeln;
    isCorrect:=(Length(Menu) = 1) and (Menu>='1') and (Menu<='7');
    if not isCorrect then
    Writeln('������. ������� ��� ���');
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
  isCorrect:=False;
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
    isCorrect:=(Length(Menu) = 1) and (Menu>='1') and (Menu <= '5');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
end;

function GetQuery:string;
begin
  Writeln;
  Writeln('������� ������:');
  Writeln;
  Readln(Result);
  Writeln;
end;

procedure Search(PHead:PPointer; WHead:WPointer);
var Field:Integer;
Query:string;
begin
  case ChooseList of
    1:
    begin
      Field:=WSearchField;
      Query:=GetQuery;
      WSearch(WHead, Field, Query);
    end;
    2:
    begin
      Field:=PSearchField;
      Query:=GetQuery;
      PSearch(PHead, Field, Query);
    end;
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
  Menu: Byte;
  PHead: PPointer;
  WHead: WPointer;
  FileName: string;
  P: FP;
  W: FW;
begin
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
    Readln(Menu);
    Writeln;
    case Menu of
      1:
        ReadFromFile(PHead, WHead);
      2:
        MenuPrint(PHead, WHead);
      3:
        Writeln('Sort');//Sort(PHead, WHead);
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
  until (Menu = 10) or (Menu = 9);
  DisposeAll(WHead, PHead);
end;

begin
  Menu;

end.
