unit EPfunctions;

interface

type
  WPointer = ^TWorker;

  TWorkerData = record
    Code: Integer;
    Surname: string[30];
    Name: string[20];
    MiddleName: string[20];
    Position: string[50];
    Hours: Byte;
    ManagerCode: Integer;
  end;

  TWorker = record
    Data: TWorkerData;
    Next: Pointer;
  end;

  PPointer = ^TProject;

  TProjectData = record
    Name: string[20];
    Task: string[50];
    ExecCode: Integer;
    ManagerCode: Integer;
    IssDate: string[10];
    Term: string[10];
  end;

  TProject = record
    Data: TProjectData;
    Next: PPointer;
  end;

  FP = file of TProjectData;
  FW = file of TWorkerData;

procedure DisposeAll(var WHead:WPointer; var PHead:PPointer);
procedure WriteToFile(PHead: PPointer; WHead: WPointer);
procedure ReadFromFile(PHead: PPointer; WHead: WPointer);
procedure EnterWorker(Head: WPointer);
procedure EnterWorkers(Head: WPointer);
procedure EnterProject(Head: PPointer);
procedure EnterProjects(Head: PPointer);
procedure PrintWorker(Head: WPointer);
procedure PrintWorkers(Head: WPointer);
procedure PrintProject(Head: PPointer);
procedure PrintProjects(Head: PPointer);
procedure MenuPrint(PHead: PPointer; WHead: WPointer);
procedure MenuEnter(PHead: PPointer; WHead: WPointer);

implementation

procedure ReadFromFile(PHead: PPointer; WHead: WPointer);
var
P:FP;
W:FW;
PTemp:PPointer;
WTemp:WPointer;
PTempInf:TProjectData;
WTempInf:TWorkerData;
begin
  AssignFile(P, 'C:\Users\User\Desktop\�����\Educational-Practice\ProjectsFile');
  AssignFile(W, 'C:\Users\User\Desktop\�����\Educational-Practice\WorkersFile');
  Reset(P);
  Reset(W);
  while not EoF(P) do
  begin
    New(PTemp);
    Read(P, PTempInf);
    PTemp^.Data:=PTempInf;
    PTemp^.Next:=nil;
    PHead.Next:=PTemp;
    PHead:=PTemp;
  end;
  while not EoF(W) do
  begin
    New(WTemp);
    Read(W, WTempInf);
    WTemp^.Data:=WTempInf;
    WTemp^.Next:=nil;
    WHead^.Next:=WTemp;
    WHead:=WTemp;
  end;
  CloseFile(P);
  CloseFile(W);
end;

procedure WriteToFile(PHead: PPointer; WHead: WPointer);
var
  P: FP;
  W: FW;
begin
  AssignFile(P, 'C:\Users\User\Desktop\�����\Educational-Practice\ProjectsFile');
  AssignFile(W, 'C:\Users\User\Desktop\�����\Educational-Practice\WorkersFile');
  Rewrite(P);
  Rewrite(W);
  PHead:=PHead^.Next;
  WHead:=WHead^.Next;
  while PHead <> nil do
  begin
    Write(P, PHead^.Data);
    PHead:=PHead^.Next;
  end;
  while WHead <> nil do
  begin
    Write(W, WHead^.Data);
    WHead:=WHead.Next;
  end;
  CloseFile(P);
  CloseFile(W);
end;

procedure DisposeAll(var WHead:WPointer; var PHead:PPointer);
var
  WTemp, WCurrent: WPointer;
  PTemp, PCurrent: PPointer;
begin
  WCurrent := WHead;
  while WCurrent <> nil do
  begin
    WTemp := WCurrent;
    WCurrent := WCurrent^.Next;
    Dispose(WTemp);
  end;
  WHead := nil;
  PCurrent := PHead;
  while PCurrent <> nil do
  begin
    PTemp := PCurrent;
    PCurrent := PCurrent^.Next;
    Dispose(PTemp);
  end;
  PHead := nil;
end;

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

procedure EnterWorkers(Head: WPointer);
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
      New(Temp);
      EnterWorker(Temp);
      Head^.Next := Temp;
      Head:=Temp;
    end
    else if Menu <> '2' then
      Writeln('������');
  until Menu = '2';
  Head^.Next := nil;
end;

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

procedure EnterProjects(Head: PPointer);

var
  Menu: string;
  Temp: PPointer;
begin
  repeat
    Writeln('�������� ����� ����:');
    Writeln('1. ������ ������ � �������');
    Writeln('2. �����');
    Readln(Menu);
    if Menu = '1' then
    begin
      New(Temp);
      EnterProject(Temp);
      Head^.Next := Temp;
      Head:=Temp;
    end
    else if Menu <> '2' then
      Writeln('������');
  until Menu = '2';
  Head^.Next := nil;
end;

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

procedure PrintWorkers(Head: WPointer);

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

procedure PrintProjects(Head: PPointer);

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

procedure MenuEnter(PHead: PPointer; WHead: WPointer);
begin
  var
    Menu: Char;

  begin
    Writeln('��������, ��� ������ ���������:');
    Writeln('1. ������ �����������');
    Writeln('2. ������ ��������');
    Writeln;
    Readln(Menu);
    Writeln;
    case Menu of
      '1':
        EnterWorkers(WHead);
      '2':
        EnterProjects(PHead);
    end;
  end;
end;

end.