program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  EPfunctions;

function CompareProjects(P, q: PPointer; Field: Byte): Boolean;
begin
  case Field of
    1:
      Result := P^.Data.Name > q^.Data.Name;
    2:
      Result := P^.Data.ExecCode > q^.Data.ExecCode;
    3:
      Result := P^.Data.ManagerCode > q^.Data.ManagerCode;
    4:
      Result := P^.Data.Name > q^.Data.Name; // ��������� �� ���� ������
    5:
      Result := P^.Data.Name > q^.Data.Name; // ��������� �� ���� �����
  end;
end;

procedure PSwap(P, q: PPointer);
var
  Temp: PPointer;
begin
  New(Temp);
  Temp^.Data := P^.Data;
  P^.Data := q^.Data;
  q^.Data := Temp^.Data;
  Dispose(Temp);
end;

procedure WSwap(P, q: WPointer);
var
  Temp: WPointer;
begin
  New(Temp);
  Temp^.Data := P^.Data;
  P^.Data := q^.Data;
  q^.Data := Temp^.Data;
  Dispose(Temp);
end;

procedure PSort(Head: PPointer; Field: Byte);
var
  Temp: PPointer;
begin
  while Head^.Next <> nil do
  begin
    Temp := Head^.Next;
    while Temp <> nil do
    begin
      if CompareProjects(Head, Temp, Field) then
        PSwap(Head, Temp);
      Temp := Temp^.Next
    end;
    Head := Head^.Next;
  end;
end;

Procedure Delete_Project(Previous: PPointer);
var
  Temp: PPointer;
begin
  Temp := Previous^.Next;
  Previous^.Next := Previous^.Next^.Next;
  Dispose(Temp);
end;



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
        Writeln('����������...');
      4:
        Writeln('����� � ��������...');
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
