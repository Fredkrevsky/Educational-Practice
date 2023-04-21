unit EPfunctions;

interface

type

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

  WPointer = ^TWorker;

  TWorkerData = record
    Code: Integer;
    Surname: string[30];
    Name: string[20];
    MiddleName: string[20];
    Position: string[50];
    Hours: Integer;
    ManagerCode: Integer;
  end;

  TWorker = record
    Data: TWorkerData;
    Next: Pointer;
  end;

  FP = file of TProjectData;
  FW = file of TWorkerData;

function ChooseList: Byte;
function PGetPrev(PHead, ToFind: PPointer): PPointer;
function WGetPrev(WHead, ToFind: WPointer): WPointer;
procedure PSwap(PHead, Temp1, Temp2: PPointer);
procedure WSwap(WHead, Temp1, Temp2: WPointer);
procedure PDelete(PHead, ToDelete: PPointer);
procedure WDelete(WHead, ToDelete: WPointer);
procedure DisposeAll(var WHead: WPointer; var PHead: PPointer);
procedure WriteToFile(PHead: PPointer; WHead: WPointer);
procedure ReadFromFile(PHead: PPointer; WHead: WPointer);
procedure EnterWorker(WHead: WPointer); // ��������
procedure EnterWorkers(WHead: WPointer); //
procedure EnterProject(PHead: PPointer); //
procedure EnterProjects(PHead: PPointer); //
procedure PrintWorker(WHead: WPointer);
procedure PrintWorkers(WHead: WPointer);
procedure PrintProject(PHead: PPointer);
procedure PrintProjects(PHead: PPointer);
procedure MenuPrint(PHead: PPointer; WHead: WPointer);
procedure MenuEnter(PHead: PPointer; WHead: WPointer); //

implementation

uses System.SysUtils;

function SearchFirstFree(WHead:WPointer):Integer;
var
  Max:Integer;
begin
  Max:=0;
  WHead:=WHead^.Next;
  while Whead<>nil do
  begin
    if WHead^.Data.Code>Max then
    Max:=WHead^.Data.Code;
  end;
  Result:=Max+1;
end;

function ChooseList: Byte;
var
  Menu: Char;
  isCorrect: Boolean;
begin
  isCorrect := False;
  repeat
    Writeln('1. ������ �����������');
    Writeln('2. ������ ��������');
    Writeln;
    Readln(Menu);
    Writeln;
    isCorrect := (Menu = '1') or (Menu = '2');
    if not isCorrect then
      Writeln('������. ������� ��� ���:');
  until isCorrect;
  Result := Ord(Menu) - Ord('0');
end;

function PGetPrev(PHead, ToFind: PPointer): PPointer;
begin
  Result := PHead;
  while Result^.Next <> ToFind do
    Result := Result^.Next;
end;

function WGetPrev(WHead, ToFind: WPointer): WPointer;
begin
  Result := WHead;
  while Result^.Next <> ToFind do
    Result := Result^.Next;
end;

procedure PSwap(PHead, Temp1, Temp2: PPointer);
var
  p1, n1: PPointer;
  p2, n2: PPointer;
begin

  p1 := PGetPrev(PHead, Temp1);
  n1 := Temp1^.Next;
  p2 := PGetPrev(PHead, Temp2);
  n2 := Temp2^.Next;

  p1^.Next := Temp2;
  Temp2^.Next := n1;
  p2^.Next := Temp1;
  Temp1^.Next := n2;
end;

procedure WSwap(WHead, Temp1, Temp2: WPointer);
var
  p1, n1: WPointer;
  p2, n2: WPointer;
begin

  p1 := WGetPrev(WHead, Temp1);
  n1 := Temp1^.Next;
  p2 := WGetPrev(WHead, Temp2);
  n2 := Temp2^.Next;

  p1^.Next := Temp2;
  Temp2^.Next := n1;
  p2^.Next := Temp1;
  Temp1^.Next := n2;
end;

procedure PDelete(PHead, ToDelete: PPointer);
var
  Temp: PPointer;
begin
  Temp := PGetPrev(PHead, ToDelete);
  Temp^.Next := ToDelete^.Next;
  Dispose(ToDelete);
end;

procedure WDelete(WHead, ToDelete: WPointer);
var
  Temp: WPointer;
begin
  Temp := WGetPrev(WHead, ToDelete);
  Temp^.Next := ToDelete^.Next;
  Dispose(ToDelete);
end;

procedure ReadFromFile(PHead: PPointer; WHead: WPointer);
var
  P: FP;
  W: FW;
  PTemp: PPointer;
  WTemp: WPointer;
  PTempInf: TProjectData;
  WTempInf: TWorkerData;
begin
  AssignFile(P,
    'C:\Users\User\Desktop\�����\Educational-Practice\ProjectsFile');
  AssignFile(W, 'C:\Users\User\Desktop\�����\Educational-Practice\WorkersFile');
  Reset(P);
  Reset(W);
  while not EoF(P) do
  begin
    New(PTemp);
    Read(P, PTempInf);
    PTemp^.Data := PTempInf;
    PTemp^.Next := nil;
    PHead.Next := PTemp;
    PHead := PTemp;
  end;
  while not EoF(W) do
  begin
    New(WTemp);
    Read(W, WTempInf);
    WTemp^.Data := WTempInf;
    WTemp^.Next := nil;
    WHead^.Next := WTemp;
    WHead := WTemp;
  end;
  CloseFile(P);
  CloseFile(W);
end;

procedure WriteToFile(PHead: PPointer; WHead: WPointer);
var
  P: FP;
  W: FW;
begin
  AssignFile(P,
    'C:\Users\User\Desktop\�����\Educational-Practice\ProjectsFile');
  AssignFile(W, 'C:\Users\User\Desktop\�����\Educational-Practice\WorkersFile');
  Rewrite(P);
  Rewrite(W);
  PHead := PHead^.Next;
  WHead := WHead^.Next;
  while PHead <> nil do
  begin
    Write(P, PHead^.Data);
    PHead := PHead^.Next;
  end;
  while WHead <> nil do
  begin
    Write(W, WHead^.Data);
    WHead := WHead.Next;
  end;
  CloseFile(P);
  CloseFile(W);
end;

procedure DisposeAll(var WHead: WPointer; var PHead: PPointer);
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

procedure EnterWorker(WHead: WPointer);
begin
  WHead^.Data.Code := SearchFirstFree(WHead);
  Writeln('�������:');
  Readln(WHead^.Data.Surname);
  Writeln('���:');
  Readln(WHead^.Data.Name);
  Writeln('��������:');
  Readln(WHead^.Data.MiddleName);
  Writeln('���������:');
  Readln(WHead^.Data.Position);
  Writeln('���������� ����� � �����:'); // �������� �� BYTE
  Readln(WHead^.Data.Hours);
  Writeln('��� ������������:'); // �������� �� Integer
  Readln(WHead^.Data.ManagerCode);
  Writeln;
end;

procedure EnterWorkers(WHead: WPointer);
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
      WHead^.Next := Temp;
      WHead := Temp;
    end
    else if Menu <> '2' then
      Writeln('������');
  until Menu = '2';
  WHead^.Next := nil;
end;

procedure EnterProject(PHead: PPointer);
begin
  Writeln('�������� �������: ');
  Readln(PHead^.Data.Name);
  Writeln('������� �������:');
  Readln(PHead^.Data.Task);
  Writeln('��� �����������:');
  Readln(PHead^.Data.ExecCode); // �������� �� Integer
  Writeln('��� ������������:');
  Readln(PHead^.Data.ManagerCode); // �������� �� Integer
  Writeln('���� ������:');
  Readln(PHead^.Data.IssDate);
  Writeln('���� ����������:');
  Readln(PHead^.Data.Term);
  Writeln;
end;

procedure EnterProjects(PHead: PPointer);

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
      PHead^.Next := Temp;
      PHead := Temp;
    end
    else if Menu <> '2' then
      Writeln('������');
  until Menu = '2';
  PHead^.Next := nil;
end;

procedure PrintWorker(WHead: WPointer);
begin
  Writeln('��� ����������: ', WHead^.Data.Code);
  Writeln('�������: ', WHead^.Data.Surname);
  Writeln('���: ', WHead^.Data.Name);
  Writeln('��������: ', WHead^.Data.MiddleName);
  Writeln('���������: ', WHead^.Data.Position);
  Writeln('���������� ����� � �����: ', WHead^.Data.Hours);
  Writeln('��� ������������: ', WHead^.Data.ManagerCode);
  Writeln;
end;

procedure PrintWorkers(WHead: WPointer);

begin
  WHead := WHead^.Next;
  if WHead = nil then
    Writeln('��� ���������� � �����������')
  else
  begin
    Writeln('������ � �����������:');
    while WHead <> nil do
    begin
      PrintWorker(WHead);
      WHead := WHead^.Next;
    end;
  end;
end;

procedure PrintProject(PHead: PPointer);
begin
  Writeln('�������� �������: ', PHead^.Data.Name);
  Writeln('������� �������: ', PHead^.Data.Task);
  Writeln('��� �����������: ', PHead^.Data.ExecCode);
  Writeln('��� ������������: ', PHead^.Data.ManagerCode);
  Writeln('���� ������: ', PHead^.Data.IssDate);
  Writeln('���� ����������: ', PHead^.Data.Term);
  Writeln;
end;

procedure PrintProjects(PHead: PPointer);

begin
  PHead := PHead^.Next;
  if PHead = nil then
    Writeln('��� ���������� � ��������')
  else
  begin
    Writeln('������ � ��������:');
    while PHead <> nil do
    begin
      PrintProject(PHead);
      PHead := PHead^.Next;
    end;
  end;
end;

procedure MenuPrint(PHead: PPointer; WHead: WPointer);
begin
  Writeln('��������, ��� ��������:');
  case ChooseList of
    1:
      PrintWorkers(WHead);
    2:
      PrintProjects(PHead);
  end;
end;

procedure MenuEnter(PHead: PPointer; WHead: WPointer);
begin
  var
    Menu: Char;
  begin
    Writeln('��������, ��� ������ ���������:');
    case ChooseList of
      1:
        EnterWorkers(WHead);
      2:
        EnterProjects(PHead);
    end;
  end;
end;



end.
