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

function CompareDate(Date1, Date2: string): Boolean;
function SearchFirstFree(WHead:WPointer):Integer;
function ChooseList: Byte;
function PGetPrev(PHead, ToFind: PPointer): PPointer;
function WGetPrev(WHead, ToFind: WPointer): WPointer;
procedure PSwap(PHead, Temp1, Temp2: PPointer);
procedure WSwap(WHead, Temp1, Temp2: WPointer);
procedure PDelete(PHead, ToDelete: PPointer);
procedure WDelete(WHead, ToDelete: WPointer);
procedure DisposeAll(WHead: WPointer; PHead: PPointer);
procedure WriteToFile(PHead: PPointer; WHead: WPointer);
procedure ReadFromFile(PHead: PPointer; WHead: WPointer);
procedure EnterWorker(WHead: WPointer);                     //Ввод
procedure EnterWorkers(WHead: WPointer);
procedure EnterProject(PHead: PPointer);                    //Ввод
procedure EnterProjects(PHead: PPointer);
procedure PrintWorker(WHead: WPointer);
procedure PrintWorkers(WHead: WPointer);
procedure PrintProject(PHead: PPointer);
procedure PrintProjects(PHead: PPointer);
procedure MenuPrint(PHead: PPointer; WHead: WPointer);
procedure MenuEnter(PHead: PPointer; WHead: WPointer);
function GetQuery:string;
function WSearchField:Byte;
function PSearchField:Byte;
procedure WSearch(WHead: WPointer; Field: Byte; Query: string);
procedure PSearch(PHead: PPointer; Field: Byte; Query: string);
procedure Search(PHead:PPointer; WHead:WPointer);
function WSortField: Byte;
function PSortField: Byte;
function WCompare(Temp1, Temp2: WPointer; Field: Byte): Boolean;
function PCompare(Temp1, Temp2: PPointer; Field: Byte): Boolean;
procedure WSort(WHead: WPointer; WField: Byte);
procedure PSort(PHead: PPointer; PField: Byte);
procedure Sort(PHead: PPointer; WHead: WPointer);


implementation

uses System.SysUtils;

function CompareDate(Date1, Date2: string): Boolean;
var
  y1, y2, m1, m2, d1, d2: Integer;
begin
  y1 := StrToInt(Copy(Date1, 7, 4));
  y2 := StrToInt(Copy(Date2, 7, 4));
  if y1 = y2 then
  begin
    m1 := StrToInt(Copy(Date1, 4, 2));
    m2 := StrToInt(Copy(Date2, 4, 2));
    if m1 = m2 then
    begin
      d1 := StrToInt(Copy(Date1, 1, 2));
      d2 := StrToInt(Copy(Date2, 1, 2));
      Result := d1 > d2;
    end
    else
      Result := m1 > m2;
  end
  else
    Result := y1 > y2;
end;

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
  Menu: string;
  isCorrect: Boolean;
begin
  isCorrect := False;
  repeat
    Writeln('1. Список сотрудников');
    Writeln('2. Список проектов');
    Writeln;
    Readln(Menu);
    Writeln;
    isCorrect := (Menu = '1') or (Menu = '2');
    if not isCorrect then
      Writeln('Ошибка. Введите еще раз:');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
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

procedure DisposeAll(WHead: WPointer; PHead: PPointer);
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
  PCurrent := PHead;
  while PCurrent <> nil do
  begin
    PTemp := PCurrent;
    PCurrent := PCurrent^.Next;
    Dispose(PTemp);
  end;
end;

procedure EnterWorker(WHead: WPointer);
begin
  WHead^.Data.Code := SearchFirstFree(WHead);
  Writeln('Фамилия:');
  Readln(WHead^.Data.Surname);
  Writeln('Имя:');
  Readln(WHead^.Data.Name);
  Writeln('Отчество:');
  Readln(WHead^.Data.MiddleName);
  Writeln('Должность:');
  Readln(WHead^.Data.Position);
  Writeln('Количество часов в сутки:'); // Проверка на BYTE
  Readln(WHead^.Data.Hours);
  Writeln('Код руководителя:'); // Проверка на Integer
  Readln(WHead^.Data.ManagerCode);
  Writeln;
end;

procedure EnterWorkers(WHead: WPointer);
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
      WHead^.Next := Temp;
      WHead := Temp;
    end
    else if Menu <> '2' then
      Writeln('Ошибка');
  until Menu = '2';
  WHead^.Next := nil;
end;

procedure EnterProject(PHead: PPointer);
begin
  Writeln('Название проекта: ');
  Readln(PHead^.Data.Name);
  Writeln('Задания проекта:');
  Readln(PHead^.Data.Task);
  Writeln('Код исполнителя:');
  Readln(PHead^.Data.ExecCode); // Проверка на Integer
  Writeln('Код руководителя:');
  Readln(PHead^.Data.ManagerCode); // Проверка на Integer
  Writeln('Дата выдачи:');
  Readln(PHead^.Data.IssDate);
  Writeln('Срок выполнения:');
  Readln(PHead^.Data.Term);
  Writeln;
end;

procedure EnterProjects(PHead: PPointer);

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
      PHead^.Next := Temp;
      PHead := Temp;
    end
    else if Menu <> '2' then
      Writeln('Ошибка');
  until Menu = '2';
  PHead^.Next := nil;
end;

procedure PrintWorker(WHead: WPointer);
begin
  Writeln('Код сотрудника: ', WHead^.Data.Code);
  Writeln('Фамилия: ', WHead^.Data.Surname);
  Writeln('Имя: ', WHead^.Data.Name);
  Writeln('Отчество: ', WHead^.Data.MiddleName);
  Writeln('Должность: ', WHead^.Data.Position);
  Writeln('Количество часов в сутки: ', WHead^.Data.Hours);
  Writeln('Код руководителя: ', WHead^.Data.ManagerCode);
  Writeln;
end;

procedure PrintWorkers(WHead: WPointer);

begin
  WHead := WHead^.Next;
  if WHead = nil then
    Writeln('Нет информации о сотрудниках')
  else
  begin
    Writeln('Данные о сотрудниках:');
    while WHead <> nil do
    begin
      PrintWorker(WHead);
      WHead := WHead^.Next;
    end;
  end;
end;

procedure PrintProject(PHead: PPointer);
begin
  Writeln('Название проекта: ', PHead^.Data.Name);
  Writeln('Задания проекта: ', PHead^.Data.Task);
  Writeln('Код исполнителя: ', PHead^.Data.ExecCode);
  Writeln('Код руководителя: ', PHead^.Data.ManagerCode);
  Writeln('Дата выдачи: ', PHead^.Data.IssDate);
  Writeln('Срок выполнения: ', PHead^.Data.Term);
  Writeln;
end;

procedure PrintProjects(PHead: PPointer);

begin
  PHead := PHead^.Next;
  if PHead = nil then
    Writeln('Нет информации о проектах')
  else
  begin
    Writeln('Данные о проектах:');
    while PHead <> nil do
    begin
      PrintProject(PHead);
      PHead := PHead^.Next;
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
  Writeln('Выберите, что будете заполнять:');
  case ChooseList of
    1:
      EnterWorkers(WHead);
    2:
      EnterProjects(PHead);
  end;
end;

function GetQuery:string;
begin
  Writeln;
  Writeln('Введите запрос:');
  Writeln;
  Readln(Result);
  Writeln;
end;

function WSearchField:Byte;
  var
  Menu: string;
  isCorrect: Boolean;
begin
  isCorrect:=False;
  repeat
    Writeln('Выберите поле для поиска:');
    Writeln('1. Код сотрудника');
    Writeln('2. Фамилия');
    Writeln('3. Имя');
    Writeln('4. Отчество');
    Writeln('5. Должность');
    Writeln('6. Количество рабочих часов в день');
    Writeln('7. Код руководителя');
    Writeln;
    Readln(Menu);
    Writeln;
    isCorrect:=(Length(Menu) = 1) and (Menu>='1') and (Menu<='7');
    if not isCorrect then
    Writeln('Ошибка. Введите ещё раз');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
end;

function PSearchField:Byte;
  var
  Menu: string;
  isCorrect: Boolean;
begin
  isCorrect:=False;
  repeat
    Writeln('Выберите поле для поиска:');
    Writeln('1. Имя проекта');
    Writeln('2. Задание проекта');
    Writeln('3. Код исполнителя');
    Writeln('4. Код руководителя');
    Writeln('5. Дата получения');
    Writeln('6. Срок сдачи');
    Writeln;
    Readln(Menu);
    Writeln;
    isCorrect:= (Length(Menu) = 1) and (Menu>='1') and (Menu<='6');
    if not isCorrect then
    Writeln('Ошибка. Введите ещё раз');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
end;

procedure WSearch(WHead: WPointer; Field: Byte; Query: string);
var
  Exist, Match: Boolean;
begin
  Exist := False;
  WHead := WHead^.Next;
  Writeln('Результаты поиска:');
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
    Writeln('Ничего не найдено');
end;

procedure PSearch(PHead: PPointer; Field: Byte; Query: string);
var
  Exist, Match: Boolean;
begin
  Exist := False;
  PHead := PHead^.Next;
  Writeln('Результаты поиска:');
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
    Writeln('Ничего не найдено');
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

function WSortField: Byte;
var
  Menu: Char;
begin
  repeat
    Writeln('Выберите поле для сортировки:');
    Writeln('1. Код сотрудника');
    Writeln('2. ФИО');
    Writeln('3. Должность');
    Writeln('4. Количество рабочих часов в день');
    Writeln('5. Код руководителя');
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
    Writeln('Выберите поле для сортировки:');
    Writeln('1. Имя проекта');
    Writeln('2. Код исполнителя');
    Writeln('3. Код руководителя');
    Writeln('4. Дата получения');
    Writeln('5. Срок сдачи');
    Writeln;
    Readln(Menu);
    Writeln;
    isCorrect := (Length(Menu) = 1) and (Menu >= '1') and (Menu <= '5');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
end;

function WCompare(Temp1, Temp2: WPointer; Field: Byte): Boolean;
begin
  case Field of
    1:
      Result := Temp1^.Data.Code > Temp2^.Data.Code;
    2:
      begin
        if AnsiUpperCase(Temp1^.Data.Surname) <>
          AnsiUpperCase(Temp2^.Data.Surname) then
          Result := AnsiUpperCase(Temp1^.Data.Surname) >
            AnsiUpperCase(Temp2^.Data.Surname)
        else if AnsiUpperCase(Temp1^.Data.Name) <>
          AnsiUpperCase(Temp2^.Data.Name) then
          Result := AnsiUpperCase(Temp1^.Data.Name) >
            AnsiUpperCase(Temp2^.Data.Name)
        else
          Result := AnsiUpperCase(Temp1^.Data.MiddleName) >
            AnsiUpperCase(Temp2^.Data.MiddleName);
      end;
    3:
      Result := AnsiUpperCase(Temp1^.Data.Position) >
        AnsiUpperCase(Temp2^.Data.Position);
    4:
      Result := Temp1^.Data.Hours > Temp2^.Data.Hours;
    5:
      Result := Temp1^.Data.ManagerCode > Temp2^.Data.ManagerCode;
  end;
end;

function PCompare(Temp1, Temp2: PPointer; Field: Byte): Boolean;

begin
  case Field of
    1:
      Result := AnsiUpperCase(Temp1^.Data.Name) >
        AnsiUpperCase(Temp2^.Data.Name);
    2:
      Result := Temp1^.Data.ExecCode > Temp2^.Data.ExecCode;
    3:
      Result := Temp1^.Data.ManagerCode > Temp2^.Data.ManagerCode;
    4:
      Result := CompareDate(Temp1^.Data.IssDate, Temp2^.Data.IssDate);
    5:
      Result := CompareDate(Temp1^.Data.Term, Temp2^.Data.Term);
  end;
end;

procedure WSort(WHead: WPointer; WField: Byte);
var
  Swapped: Boolean;
  NextNode, Temp, PrevNode, Current: WPointer;
begin
  repeat
    Swapped := False;
    PrevNode := WHead;
    Current := WHead^.Next;
    while Current^.Next <> nil do
    begin
      NextNode := Current^.Next;
      if WCompare(Current, NextNode, WField) then
      begin
        Swapped := True;
        Temp := NextNode^.Next;
        NextNode^.Next := Current;
        Current^.Next := Temp;
        if PrevNode <> nil then
          PrevNode^.Next := NextNode;
        PrevNode := NextNode;
        NextNode := Current^.Next;
      end
      else
      begin
        PrevNode := Current;
        Current := NextNode;
      end;
    end;
  until not Swapped;
end;

procedure PSort(PHead: PPointer; PField: Byte);
var
  Swapped: Boolean;
  NextNode, Temp, PrevNode, Current: PPointer;
begin
  repeat
    Swapped := False;
    PrevNode := PHead;
    Current := PHead^.Next;
    while Current^.Next <> nil do
    begin
      NextNode := Current^.Next;
      if PCompare(Current, NextNode, PField) then
      begin
        Swapped := True;
        Temp := NextNode^.Next;
        NextNode^.Next := Current;
        Current^.Next := Temp;
        if PrevNode <> nil then
          PrevNode^.Next := NextNode;
        PrevNode := NextNode;
        NextNode := Current^.Next;
      end
      else
      begin
        PrevNode := Current;
        Current := NextNode;
      end;
    end;
  until not Swapped;
end;

procedure Sort(PHead: PPointer; WHead: WPointer);
var
  WField, PField: Byte;
begin
  Writeln('Выберите список для сортировки:');
  case ChooseList of
    1:
      begin
        if WHead^.Next = nil then
          Write('Нет информации о сотрудниках', #13#10)
        else
        begin
          WField := WSortField;
          WSort(WHead, WField);
        end;
      end;
    2:
      begin
        if PHead^.Next = nil then
          Write('Нет информации о проектах', #13#10)
        else
        begin
          PField := PSortField;
          PSort(PHead, PField);
        end;
      end;
  end;
end;

end.
