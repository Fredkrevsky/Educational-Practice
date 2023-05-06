program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  EPfunctions;
// ��������� �������� ������
// ����� ��������� ����� ���� Integer, ��� �������������� �� ������ � ����� � ���� ������
// ������� ��������� ����������, �������������� � �������� ������� �� ������, � ��� �� ������������� ���� ������
// ����� �����������, ���� ���������� ������


procedure WorkerTasks(PHead: PPointer; ProjectName: string; Code: Integer);

  procedure AddTask(TempCurrent, Current: PPointer);
  begin
    New(TempCurrent^.Next);
    TempCurrent := TempCurrent^.Next;
    TempCurrent^.Next := nil;
    TempCurrent^.Data := Current^.Data;
  end;

  procedure PrintWorkerTasks(TempPHead: PPointer);
  begin
    if TempPHead^.Next = nil then
    begin
    Writeln('��� �������.');
    writeln;
    end
    else
    begin
      Writeln('�������:');
      writeln;
      PSort(TempPHead, 5);
      TempPHead:=TempPHead^.Next;
      while TempPHead <> nil do
      begin
        PrintProject(TempPHead);
        TempPHead:=TempPHead^.Next;
      end;
    end;
  end;
// ��������
var
  TempPHead, TempCurrent, Current: PPointer;

begin
  New(TempPHead);
  TempPHead^.Next := nil;
  Current := PHead^.Next;
  TempCurrent := TempPHead;
  while Current <> nil do
  begin
    if (Current^.Data.Name = ProjectName) and (Current^.Data.ExecCode = Code) then
    begin
      AddTask(TempCurrent, Current);
      TempCurrent := TempCurrent^.Next;
    end;
    Current := Current^.Next;
  end;
  PrintWorkerTasks(TempPHead);
end;

procedure SFMenu2(WHead: WPointer; PHead: PPointer);
var
  ProjectName: string;
  Code: Integer;
  isCorrect: Boolean;
begin
  isCorrect := False;
  Writeln('������� �������� �������:');
  Readln(ProjectName);
  Writeln;
  repeat
    Writeln('������� ��� ����������:');
    try
      Readln(Code);
      Writeln;
      isCorrect := True;
    except
      Writeln('������. ������� ��� ���:');
    end;
    Writeln;
  until isCorrect;

  WorkerTasks(PHead, ProjectName, Code);
 { Writeln;
  Writeln('�������� ����� ����:');
  Writeln('1. ');
  Writeln('2. '); }
end;

procedure ProjectsAndTasks(WHead: WPointer; PHead: PPointer);
var
  Menu: string;
  isCorrect: Boolean;
begin
  isCorrect := False;
  repeat
    Writeln('�������� ����� ����:');
    Writeln('1. ������ ������ ���� �������� ������������');
    Writeln('2. ������ ������ ���� ����� ���������� � ������ ����������� �������');
    Readln(Menu);
    isCorrect := (Menu = '1') or (Menu = '2');
  until isCorrect;
  if Menu = '1' then
    SearchBySurname(WHead, PHead)
  else
    SFMenu2(WHead, PHead);
end;

procedure Menu;
var
  isCorrect: Boolean;
  PunktOfMenu: string;
  PHead: PPointer;
  WHead: WPointer;
begin
  New(PHead);
  New(WHead);
  PHead^.Next := nil;
  WHead^.Next := nil;
  repeat
    isCorrect := False;
    Writeln('�������� ����� ����');
    Writeln('1. ������ ������ �� �����');
    Writeln('2. �������� ����� ������');
    Writeln('3. ���������� ������');
    Writeln('4. ����� ������ � ��������');
    Writeln('5. ���������� ������ � ������');
    Writeln('6. �������� ������ �� ������');
    Writeln('7. �������������� ������');
    Writeln('8. ��'); // ������� 8 �����
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
          Sort(PHead, WHead);
        4:
          Search(PHead, WHead, 'P');
        5:
          MenuEnter(PHead, WHead);
        6:
          Search(PHead, WHead, 'D');
        7:
          Search(PHead, WHead, 'E');
        8:
          ProjectsAndTasks(WHead, PHead);
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
