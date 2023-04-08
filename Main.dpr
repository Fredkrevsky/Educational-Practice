program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  WPointer = ^TWorker;

  TWorkerData = record
    Code: Integer;
    Surname: string;
    Name: string;
    MiddleName: string;
    Position: string;
    Hours: Byte;
    ManagerCode: Integer;
  end;

  TWorker = record
    Data: TWorkerData;
    Next: Pointer;
  end;

  PPointer = ^TProject;

  TProjectData = record
    Name: string;
    Task: string;
    ExecCode: Integer;
    ManagerCode: Integer;
    IssDate: string;
    Term: string;
  end;

  TProject = record
    Data: TProjectData;
    Next: PPointer;
  end;

procedure EnterWorkers(Head: WPointer);

  procedure EnterWorker(Head: WPointer);
  begin
    Writeln('��� ����������:');
    Readln(Head^.Data.Code); // ������� ��������� ���������
    Writeln('�������:');
    Readln(Head^.Data.Surname);
    Writeln('���:');
    Readln(Head^.Data.Name);
    Writeln('��������:');
    Readln(Head^.Data.MiddleName);
    Writeln('���������:');
    Readln(Head^.Data.Position);
    Writeln('���������� ����� � �����:'); // �������� �� BYTE
    Readln(Head^.Data.Hours);
    Writeln('��� ������������:'); // �������� �� Integer
    Readln(Head^.Data.ManagerCode);
    Writeln;
  end;

var
  Menu: string;
  Temp: WPointer;
begin
  repeat
    Writeln('�������� ����� ����:');
    Writeln('1. ������ ������ � ����������');
    Writeln('2. �����');
    Readln(Menu);
    if Menu = '1' then
    begin
      Temp := Head;
      New(Head);
      EnterWorker(Head);
      Temp^.Next := Head;
    end
    else if Menu <> '2' then
      Writeln('������');
  until Menu = '2';
  Head^.Next := nil;
end;

procedure EnterProjects(Head: PPointer);

  procedure EnterProject(Head: PPointer);
  begin
    Writeln('�������� �������: ');
    Readln(Head^.Data.Name);
    Writeln('������� �������:');
    Readln(Head^.Data.Task);
    Writeln('��� �����������:');
    Readln(Head^.Data.ExecCode); // �������� �� Integer
    Writeln('��� ������������:');
    Readln(Head^.Data.ManagerCode); // �������� �� Integer
    Writeln('���� ������:');
    Readln(Head^.Data.IssDate);
    Writeln('���� ����������:');
    Readln(Head^.Data.Term);
    Writeln;
  end;

var
  Menu: string;
  Temp: PPointer;
begin
  repeat
    Writeln('�������� ����� ����:');
    Writeln('1. ������ ������ � ����������');
    Writeln('2. �����');
    Readln(Menu);
    if Menu = '1' then
    begin
      Temp := Head;
      New(Head);
      EnterProject(Head);
      Temp^.Next := Head;
    end
    else if Menu <> '2' then
      Writeln('������');
  until Menu = '2';
  Head^.Next := nil;
end;

procedure PrintWorkers(Head: WPointer);

  procedure PrintWorker(Head: WPointer);
  begin
    Writeln('��� ����������: ', Head^.Data.Code);
    Writeln('�������: ', Head^.Data.Surname);
    Writeln('���: ', Head^.Data.Name);
    Writeln('��������: ', Head^.Data.MiddleName);
    Writeln('���������: ', Head^.Data.Position);
    Writeln('���������� ����� � �����: ', Head^.Data.Hours);
    Writeln('��� ������������: ', Head^.Data.ManagerCode);
    Writeln;
  end;

begin
  Head := Head^.Next;
  if Head = nil then
    Writeln('��� ���������� � �����������')
  else
  begin
    Writeln('������ � �����������:');
    while Head <> nil do
    begin
      PrintWorker(Head);
      Head := Head^.Next;
    end;
  end;
end;

procedure PrintProjects(Head: PPointer);

  procedure PrintProject(Head: PPointer);
  begin
    Writeln('�������� �������: ', Head^.Data.Name);
    Writeln('������� �������: ', Head^.Data.Task);
    Writeln('��� �����������: ', Head^.Data.ExecCode);
    Writeln('��� ������������: ', Head^.Data.ManagerCode);
    Writeln('���� ������: ', Head^.Data.IssDate);
    Writeln('���� ����������: ', Head^.Data.Term);
    Writeln;
  end;

begin
  Head := Head^.Next;
  if Head = nil then
    Writeln('��� ���������� � ��������')
  else
  begin
    Writeln('������ � ��������:');
    while Head <> nil do
    begin
      PrintProject(Head);
      Head := Head^.Next;
    end;
  end;
end;

procedure MenuPrint(PHead: PPointer; WHead: WPointer);
var
  Menu: Char;
begin
  Writeln('��������, ��� ��������:');
  Writeln('1. ������ �����������');
  Writeln('2. ������ ��������');
  Writeln;
  Readln(Menu);
  Writeln;
  case Menu of
    '1':
      PrintWorkers(WHead);
    '2':
      PrintProjects(PHead);
  end;
end;

procedure Menu;
var
  Menu: Byte;
  PHead: PPointer;
  WHead: WPointer;
begin
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
        Writeln('������ ������ �� �����...');
      2:
        begin
          New(PHead);
          New(WHead);
          PHead^.Next := nil;
          WHead^.Next := nil;
          MenuPrint(PHead, WHead);
        end;
      3:
        Writeln('����������...');
      4:
        Writeln('����� � ��������...');
      5:
        Writeln('����������...');
      6:
        Writeln('��������...');
      7:
        Writeln('��������������...');
      8:
        Writeln('��...');
      9:
        Writeln('����� � �����������...');
      10:
        Writeln('����� ��� ����������...');

    end;
    Writeln;
  until Menu = 10;

end;

begin
  Menu;

end.
