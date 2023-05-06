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
function SearchFirstFree(WHead: WPointer): Integer;
function ChooseList: Byte;
function PGetPrev(PHead, ToFind: PPointer): PPointer;
function WGetPrev(WHead, ToFind: WPointer): WPointer;
procedure DisposeAll(WHead: WPointer; PHead: PPointer);
procedure WriteToFile(PHead: PPointer; WHead: WPointer);
procedure ReadFromFile(PHead: PPointer; WHead: WPointer);
procedure EnterWorker(WHead, Current: WPointer);
procedure EnterWorkers(WHead: WPointer);
procedure EnterProject(Current: PPointer);
procedure EnterProjects(PHead: PPointer);
procedure PrintWorker(Current: WPointer);
procedure PrintWorkers(WHead: WPointer);
procedure PrintProject(Current: PPointer);
procedure PrintProjects(PHead: PPointer);
procedure MenuPrint(PHead: PPointer; WHead: WPointer);
procedure MenuEnter(PHead: PPointer; WHead: WPointer);
function WSearchField: Byte;
function PSearchField: Byte;
procedure WSearch(WHead: WPointer; Field: Byte; Query: string; Mode: Char);
procedure PSearch(PHead: PPointer; Field: Byte; Query: string; Mode: Char);
procedure Search(PHead: PPointer; WHead: WPointer; Mode: Char);
function WSortField: Byte;
function PSortField: Byte;
function WCompare(Temp1, Temp2: WPointer; Field: Byte): Boolean;
function PCompare(Temp1, Temp2: PPointer; Field: Byte): Boolean;
procedure WSort(WHead: WPointer; WField: Byte);
procedure PSort(PHead: PPointer; PField: Byte);
procedure Sort(PHead: PPointer; WHead: WPointer);
function IntCheck(ToCheck: string): Boolean;
function CheckDate(ToCheck: string): Boolean;
procedure SearchBySurname(WHead: WPointer; PHead: PPointer);

implementation

uses System.SysUtils;

function CheckDate(ToCheck: string): Boolean;
const
  TMonth: array [1 .. 12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30,
    31, 30, 31);
var
  d, m, y: Integer;
  isCorrect: Boolean;
begin
  isCorrect := (Length(ToCheck) = 10) and (ToCheck[3] = '.') and
    (ToCheck[6] = '.');
  if isCorrect then
  begin
    try
      y := StrToInt(Copy(ToCheck, 7, 4));
      m := StrToInt(Copy(ToCheck, 4, 2));
      d := StrToInt(Copy(ToCheck, 1, 2));
      isCorrect := (y > 0) and (m >= 1) and (m <= 12);
      if isCorrect then
      begin
        if m = 2 then
        begin
          if (y mod 400 = 0) or (y mod 4 = 0) and (y mod 100 <> 0) then
            isCorrect := (d >= 1) and (d <= 29)
          else
            isCorrect := (d >= 1) and (d <= 28);
        end
        else
          isCorrect := (d >= 1) and (d <= TMonth[m]);
      end;
    except
      isCorrect := False;
    end;
  end;
  Result := isCorrect;
end;

function IntCheck(ToCheck: string): Boolean;
begin
  Result := True;
  try
    StrToInt(ToCheck);
  except
    Result := False;
  end;
end;

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

function SearchFirstFree(WHead: WPointer): Integer;
var
  Max: Integer;
begin
  Max := 0;
  WHead := WHead^.Next;
  while WHead <> nil do
  begin
    if WHead^.Data.Code > Max then
      Max := WHead^.Data.Code;
    WHead := WHead^.Next;
  end;
  Result := Max + 1;
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

procedure EnterWorker(WHead, Current: WPointer);
var
  ToCheck: string;
  IntFromCheck: Integer;
  isCorrect: Boolean;
begin
  Current^.Data.Code := SearchFirstFree(WHead);
  Writeln('Фамилия:');
  Readln(Current^.Data.Surname);
  Writeln('Имя:');
  Readln(Current^.Data.Name);
  Writeln('Отчество:');
  Readln(Current^.Data.MiddleName);
  Writeln('Должность:');
  Readln(Current^.Data.Position);
  repeat
    Writeln('Количество часов в сутки:');
    Readln(ToCheck);
    isCorrect := False;
    try
      IntFromCheck := StrToInt(ToCheck);
      isCorrect := (IntFromCheck >= 0) and (IntFromCheck <= 24);
    finally
      if not isCorrect then
      begin
        Writeln('Ошибка. Введите ещё раз:');
        Writeln;
      end
      else
        Current^.Data.Hours := IntFromCheck;
    end;
  until isCorrect;
  repeat
    Writeln('Код руководителя:');
    Readln(ToCheck);
    isCorrect := False;
    try
      IntFromCheck := StrToInt(ToCheck);
      isCorrect := IntFromCheck > 0;
    finally
      if not isCorrect then
      begin
        Writeln('Ошибка. Введите ещё раз:');
        Writeln;
      end
      else
        Current^.Data.ManagerCode := IntFromCheck;
    end;
  until isCorrect;
  Writeln;
end;

procedure EnterWorkers(WHead: WPointer);
var
  Menu: string;
  Temp, Current: WPointer;
begin
  Current := WHead;
  while Current^.Next <> nil do
    Current := Current^.Next;
  repeat
    Writeln('Выберите пункт меню:');
    Writeln('1. Ввести данные о сотруднике');
    Writeln('2. Выход');
    Readln(Menu);
    if Menu = '1' then
    begin
      New(Temp);
      EnterWorker(WHead, Temp);
      Current^.Next := Temp;
      Current := Temp;
      Current^.Next := nil;
    end
    else if Menu <> '2' then
      Writeln('Ошибка');
  until Menu = '2';
end;

procedure EnterProject(Current: PPointer);
var
  ToCheck: string;
  IntFromCheck: Integer;
  isCorrect: Boolean;
begin
  Writeln('Название проекта: ');
  Readln(Current^.Data.Name);
  Writeln('Задания проекта:');
  Readln(Current^.Data.Task);
  repeat
    Writeln('Код исполнителя:');
    Readln(ToCheck);
    isCorrect := False;
    if IntCheck(ToCheck) then
    begin
      IntFromCheck := StrToInt(ToCheck);
      isCorrect := IntFromCheck > 0;
    end;
    if not isCorrect then
      Writeln('Ошибка. Введите ещё раз:');
  until isCorrect;
  Current^.Data.ExecCode := IntFromCheck;
  repeat
    Writeln('Код руководителя:');
    Readln(ToCheck);
    isCorrect := False;
    if IntCheck(ToCheck) then
    begin
      IntFromCheck := StrToInt(ToCheck);
      isCorrect := IntFromCheck > 0;
    end;
    if not isCorrect then
      Writeln('Ошибка. Введите ещё раз:');
  until isCorrect;
  Current^.Data.ManagerCode := IntFromCheck;
  repeat
    Writeln('Дата выдачи:');
    Readln(ToCheck);
    isCorrect := CheckDate(ToCheck);
    if not isCorrect then
      Writeln('Ошибка. Введите ещё раз:');
  until isCorrect;
  Current^.Data.IssDate := ToCheck;
  repeat
    Writeln('Срок выполнения:');
    Readln(ToCheck);
    isCorrect := CheckDate(ToCheck);
    if not isCorrect then
      Writeln('Ошибка. Введите ещё раз:');
  until isCorrect;
  Current^.Data.Term := ToCheck;
  Writeln;
end;

procedure EnterProjects(PHead: PPointer);

var
  Menu: string;
  Temp, Current: PPointer;
begin
  Current := PHead;
  while Current^.Next <> nil do
    Current := Current^.Next;
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

procedure PrintWorker(Current: WPointer);
begin
  Writeln('Код сотрудника: ', Current^.Data.Code);
  Writeln('Фамилия: ', Current^.Data.Surname);
  Writeln('Имя: ', Current^.Data.Name);
  Writeln('Отчество: ', Current^.Data.MiddleName);
  Writeln('Должность: ', Current^.Data.Position);
  Writeln('Количество часов в сутки: ', Current^.Data.Hours);
  Writeln('Код руководителя: ', Current^.Data.ManagerCode);
  Writeln;
end;

procedure PrintWorkers(WHead: WPointer);
var
  Current: WPointer;
begin
  Current := WHead^.Next;
  if Current = nil then
    Writeln('Нет информации о сотрудниках')
  else
  begin
    Writeln('Данные о сотрудниках:');
    while Current <> nil do
    begin
      PrintWorker(Current);
      Current := Current^.Next;
    end;
  end;
end;

procedure PrintProject(Current: PPointer);
begin
  Writeln('Название проекта: ', Current^.Data.Name);
  Writeln('Задания проекта: ', Current^.Data.Task);
  Writeln('Код исполнителя: ', Current^.Data.ExecCode);
  Writeln('Код руководителя: ', Current^.Data.ManagerCode);
  Writeln('Дата выдачи: ', Current^.Data.IssDate);
  Writeln('Срок выполнения: ', Current^.Data.Term);
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

function WSearchField: Byte;
var
  Menu: string;
  isCorrect: Boolean;
begin
  isCorrect := False;
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
    isCorrect := (Length(Menu) = 1) and (Menu >= '1') and (Menu <= '7');
    if not isCorrect then
      Writeln('Ошибка. Введите ещё раз');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
end;

function PSearchField: Byte;
var
  Menu: string;
  isCorrect: Boolean;
begin
  isCorrect := False;
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
    isCorrect := (Length(Menu) = 1) and (Menu >= '1') and (Menu <= '6');
    if not isCorrect then
      Writeln('Ошибка. Введите ещё раз');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
end;

procedure WMenuDelete(WHead, Current: WPointer);
var
  Menu: string;
  isCorrect: Boolean;
  Prev: WPointer;
begin
  repeat
    Writeln('Удалить запись?');
    Writeln('1. Да');
    Writeln('2. Нет');
    Readln(Menu);
    isCorrect := (Menu = '1') or (Menu = '2');
    if not isCorrect then
      Writeln('Ошибка. Введите ещё раз');
  until isCorrect;
  if Menu = '1' then
  begin
    Prev := WGetPrev(WHead, Current);
    Prev^.Next := Current^.Next;
    Dispose(Current);
    Writeln('Запись удалена');
  end;
  Writeln;
end;

procedure PMenuDelete(PHead, Current: PPointer);
var
  Menu: string;
  isCorrect: Boolean;
  Prev: PPointer;
begin
  repeat
    Writeln('Удалить запись?');
    Writeln('1. Да');
    Writeln('2. Нет');
    Readln(Menu);
    isCorrect := (Menu = '1') or (Menu = '2');
    if not isCorrect then
      Writeln('Ошибка. Введите ещё раз');
  until isCorrect;
  if Menu = '1' then
  begin
    Prev := PGetPrev(PHead, Current);
    Prev^.Next := Current^.Next;
    Dispose(Current);
    Writeln('Запись удалена');
  end;
  Writeln;
end;

procedure WMenuEdit(WHead, Current: WPointer);
var
  Menu: string;
  isCorrect: Boolean;
begin
  repeat
    Writeln('Изменить запись?');
    Writeln('1. Да');
    Writeln('2. Нет');
    Readln(Menu);
    isCorrect := (Menu = '1') or (Menu = '2');
    if not isCorrect then
      Writeln('Ошибка. Введите еще раз');
  until isCorrect;
  if Menu = '1' then
  begin
    EnterWorker(WHead, Current);
    Writeln('Запись изменена');
  end;
  Writeln;
end;

procedure PMenuEdit(Current: PPointer);
var
  Menu: string;
  isCorrect: Boolean;
begin
  repeat
    Writeln('Изменить запись?');
    Writeln('1. Да');
    Writeln('2. Нет');
    Readln(Menu);
    isCorrect := (Menu = '1') or (Menu = '2');
    if not isCorrect then
      Writeln('Ошибка. Введите еще раз');
  until isCorrect;
  if Menu = '1' then
  begin
    EnterProject(Current);
    Writeln('Запись изменена');
  end;
  Writeln;
end;

procedure SearchBySurname(WHead: WPointer; PHead: PPointer);

  function IsItMe: Boolean;
  var
    isCorrect: Boolean;
    Menu: string;
  begin
    repeat
      Writeln(#13#10, 'Это вы?');
      Writeln('1. Да');
      Writeln('2. Нет');
      Writeln;
      Readln(Menu);
      isCorrect := (Menu = '1') or (Menu = '2');
      if not isCorrect then
        Writeln('Ошибка. Введите ещё раз');
    until isCorrect;
    Result := Menu = '1';
  end;

  procedure PrintManagerProjects(PHead: PPointer; MyCode: Integer);

  var
    Exist: Boolean;

  begin
    Exist := False;
    PHead := PHead^.Next;
    while PHead <> nil do
    begin
      if PHead^.Data.ManagerCode = MyCode then
      begin
        Exist := True;
        PrintProject(PHead);
      end;
      PHead := PHead^.Next;
    end;
    if not Exist then
      Writeln('Ничего не найдено');
    Writeln;
  end;

var
  Current: WPointer;
  ItsMe: Boolean;
  MyCode: Integer;
  Surname: string;
begin
  Writeln('Введите фамилию руководителя');
  Readln(Surname);
  Writeln;
  ItsMe := False;
  Current := WHead^.Next;
  while (Current <> nil) and not ItsMe do
  begin
    if Current^.Data.Surname = Surname then
    begin
      PrintWorker(Current);
      ItsMe := IsItMe;
    end;
    if Not ItsMe then
      Current := Current^.Next;
  end;
  if ItsMe then
  begin
    MyCode := Current^.Data.Code;
    Writeln('Ваши проекты: ', #13#10);
    PrintManagerProjects(PHead, MyCode);
  end
  else
  begin
    Writeln('Ничего не найдено');
    Writeln;
  end;

end;

procedure WSearch(WHead: WPointer; Field: Byte; Query: string; Mode: Char);
var
  Current: WPointer;
  Exist, Match: Boolean;
begin
  Exist := False;
  Current := WHead^.Next;
  Writeln('Результаты поиска:');
  while Current <> nil do
  begin
    case Field of
      1:
        Match := IntToStr(Current^.Data.Code) = Query;
      2:
        Match := Current^.Data.Surname = Query;
      3:
        Match := Current^.Data.Name = Query;
      4:
        Match := Current^.Data.MiddleName = Query;
      5:
        Match := Current^.Data.Position = Query;
      6:
        Match := IntToStr(Current^.Data.Hours) = Query;
      7:
        Match := IntToStr(Current^.Data.ManagerCode) = Query;
    end;
    if Match then
    begin
      PrintWorker(Current);
      case Mode of
        'D':
          WMenuDelete(WHead, Current);
        'E':
          WMenuEdit(WHead, Current);
      end;
      Exist := True;
    end;
    Current := Current^.Next;
  end;
  if not Exist then
    Writeln('Ничего не найдено');
end;

procedure PSearch(PHead: PPointer; Field: Byte; Query: string; Mode: Char);
var
  Current: PPointer;
  Exist, Match: Boolean;
begin
  Exist := False;
  Current := PHead^.Next;
  Writeln('Результаты поиска:');
  while Current <> nil do
  begin
    case Field of
      1:
        Match := Current^.Data.Name = Query;
      2:
        Match := Current^.Data.Task = Query;
      3:
        Match := IntToStr(Current^.Data.ExecCode) = Query;
      4:
        Match := IntToStr(Current^.Data.ManagerCode) = Query;
      5:
        Match := Current^.Data.IssDate = Query;
      6:
        Match := Current^.Data.Term = Query;
    end;
    if Match then
    begin
      PrintProject(Current);
      case Mode of
        'D':
          PMenuDelete(PHead, Current);
        'E':
          PMenuEdit(Current);
      end;
      Exist := True;
    end;
    Current := Current^.Next;
  end;
  if not Exist then
    Writeln('Ничего не найдено');
end;

procedure Search(PHead: PPointer; WHead: WPointer; Mode: Char);
var
  Field: Integer;
  Query: string;
begin

  case ChooseList of
    1:
      begin
        Field := WSearchField;
        Writeln(#13#10, 'Введите запрос:');
        Readln(Query);
        Writeln;
        WSearch(WHead, Field, Query, Mode);
      end;
    2:
      begin
        Field := PSearchField;
        Writeln(#13#10, 'Введите запрос');
        Readln(Query);
        Writeln;
        PSearch(PHead, Field, Query, Mode);
      end;
  end;
end;

function WSortField: Byte;
var
  Menu: string;
  isCorrect: Boolean;
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
    isCorrect := (Length(Menu) = 1) and (Menu >= '1') and (Menu <= '5');
  until isCorrect;
  Result := Ord(Menu[1]) - Ord('0');
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
