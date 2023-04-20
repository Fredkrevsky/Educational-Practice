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

function PGetPrev(PHead, ToFind: PPointer): PPointer;
begin
  Result:=PHead;
  while Result<>ToFind do
    Result:=Result^.Next;
end;

procedure PSwap(PHead, Temp1, Temp2: PPointer);
var
  p1, n1: PPointer;
  p2, n2: PPointer;
begin

  p1:=PGetPrev(PHead, Temp1);
  n1:=Temp1^.Next;
  p2:=PGetPrev(PHead, Temp2);
  n2:=Temp2^.Next;

  p1^.next:=Temp2;
  Temp2^.Next:=n1;
  p2^.Next:=Temp1;
  Temp1^.Next:=n2;
end;

function WGetPrev(WHead, ToFind: WPointer): WPointer;
begin
  Result:=WHead;
  while Result<>ToFind do
    Result:=Result^.Next;
end;

procedure WSwap(WHead, Temp1, Temp2: WPointer);
var
  p1, n1: WPointer;
  p2, n2: WPointer;
begin

  p1:=WGetPrev(WHead, Temp1);
  n1:=Temp1^.Next;
  p2:=WGetPrev(WHead, Temp2);
  n2:=Temp2^.Next;

  p1^.next:=Temp2;
  Temp2^.Next:=n1;
  p2^.Next:=Temp1;
  Temp1^.Next:=n2;
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
