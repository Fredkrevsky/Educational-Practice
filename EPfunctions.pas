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
    Hours: Byte;
    ManagerCode: Integer;
  end;

  TWorker = record
    Data: TWorkerData;
    Next: Pointer;
  end;

  FP = file of TProjectData;
  FW = file of TWorkerData;

function ChooseList:Byte;
function PGetPrev(PHead, ToFind: PPointer): PPointer;
function WGetPrev(WHead, ToFind: WPointer): WPointer;
procedure PSwap(PHead, Temp1, Temp2: PPointer);
procedure WSwap(WHead, Temp1, Temp2: WPointer);
procedure PDelete(PHead, ToDelete: PPointer);
procedure WDelete(WHead, ToDelete: WPointer);
procedure DisposeAll(var WHead: WPointer; var PHead: PPointer);
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

uses System.SysUtils;

function ChooseList:Byte;
var Menu:Char;
  begin
    repeat
      Writeln('1. Список сотрудников');
      Writeln('2. Список проектов');
      Writeln;
      Readln(Menu);
      Writeln;
    until (Menu = '1') or (Menu = '2');
    Result:=Ord(Menu)-Ord('0');
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
    'C:\Users\User\Desktop\УПОзн\Educational-Practice\ProjectsFile');
  AssignFile(W, 'C:\Users\User\Desktop\УПОзн\Educational-Practice\WorkersFile');
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
    'C:\Users\User\Desktop\УПОзн\Educational-Practice\ProjectsFile');
  AssignFile(W, 'C:\Users\User\Desktop\УПОзн\Educational-Practice\WorkersFile');
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

procedure EnterWorker(Head: WPointer);
begin
  Writeln('Код сотрудника:');
  Readln(Head^.Data.Code); // Сделать процедуру генерации
  Writeln('Фамилия:');
  Readln(Head^.Data.Surname);
  Writeln('Имя:');
  Readln(Head^.Data.Name);
  Writeln('Отчество:');
  Readln(Head^.Data.MiddleName);
  Writeln('Должность:');
  Readln(Head^.Data.Position);
  Writeln('Количество часов в сутки:'); // Проверка на BYTE
  Readln(Head^.Data.Hours);
  Writeln('Код руководителя:'); // Проверка на Integer
  Readln(Head^.Data.ManagerCode);
  Writeln;
end;

procedure EnterWorkers(Head: WPointer);
var
  Menu: string;
  Temp: WPointer;
begin
  repeat
    Writeln('Выберите пункт меню:');
    Writeln('1. Ввести данные о сотруднике');
    Writeln('2. Выход');
    Readln(Menu);
    if Menu = '1' then
    begin
      New(Temp);
      EnterWorker(Temp);
      Head^.Next := Temp;
      Head := Temp;
    end
    else if Menu <> '2' then
      Writeln('Ошибка');
  until Menu = '2';
  Head^.Next := nil;
end;

procedure EnterProject(Head: PPointer);
begin
  Writeln('Название проекта: ');
  Readln(Head^.Data.Name);
  Writeln('Задания проекта:');
  Readln(Head^.Data.Task);
  Writeln('Код исполнителя:');
  Readln(Head^.Data.ExecCode); // Проверка на Integer
  Writeln('Код руководителя:');
  Readln(Head^.Data.ManagerCode); // Проверка на Integer
  Writeln('Дата выдачи:');
  Readln(Head^.Data.IssDate);
  Writeln('Срок выполнения:');
  Readln(Head^.Data.Term);
  Writeln;
end;

procedure EnterProjects(Head: PPointer);

var
  Menu: string;
  Temp: PPointer;
begin
  repeat
    Writeln('Выберите пункт меню:');
    Writeln('1. Ввести данные о проекте');
    Writeln('2. Выход');
    Readln(Menu);
    if Menu = '1' then
    begin
      New(Temp);
      EnterProject(Temp);
      Head^.Next := Temp;
      Head := Temp;
    end
    else if Menu <> '2' then
      Writeln('Ошибка');
  until Menu = '2';
  Head^.Next := nil;
end;

procedure PrintWorker(Head: WPointer);
begin
  Writeln('Код сотрудника: ', Head^.Data.Code);
  Writeln('Фамилия: ', Head^.Data.Surname);
  Writeln('Имя: ', Head^.Data.Name);
  Writeln('Отчество: ', Head^.Data.MiddleName);
  Writeln('Должность: ', Head^.Data.Position);
  Writeln('Количество часов в сутки: ', Head^.Data.Hours);
  Writeln('Код руководителя: ', Head^.Data.ManagerCode);
  Writeln;
end;

procedure PrintWorkers(Head: WPointer);

begin
  Head := Head^.Next;
  if Head = nil then
    Writeln('Нет информации о сотрудниках')
  else
  begin
    Writeln('Данные о сотрудниках:');
    while Head <> nil do
    begin
      PrintWorker(Head);
      Head := Head^.Next;
    end;
  end;
end;

procedure PrintProject(Head: PPointer);
begin
  Writeln('Название проекта: ', Head^.Data.Name);
  Writeln('Задания проекта: ', Head^.Data.Task);
  Writeln('Код исполнителя: ', Head^.Data.ExecCode);
  Writeln('Код руководителя: ', Head^.Data.ManagerCode);
  Writeln('Дата выдачи: ', Head^.Data.IssDate);
  Writeln('Срок выполнения: ', Head^.Data.Term);
  Writeln;
end;

procedure PrintProjects(Head: PPointer);

begin
  Head := Head^.Next;
  if Head = nil then
    Writeln('Нет информации о проектах')
  else
  begin
    Writeln('Данные о проектах:');
    while Head <> nil do
    begin
      PrintProject(Head);
      Head := Head^.Next;
    end;
  end;
end;

procedure MenuPrint(PHead: PPointer; WHead: WPointer);
begin
    Writeln('Выберите, что выводить:');
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
    Writeln('Выберите, что будете заполнять:');
    case ChooseList of
      1:
        EnterWorkers(WHead);
      2:
        EnterProjects(PHead);
    end;
  end;
end;

end.
