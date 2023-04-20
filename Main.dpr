program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  EPfunctions;

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
      Result := Temp1^.Data.Name > Temp2^.Data.Name; // Сравнение по дате выдачи
    5:
      Result := Temp1^.Data.Name > Temp2^.Data.Name; // Сравнение по дате сдачи
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

{TWorkerData = record
    Code: Integer;
    Surname: string[30];
    Name: string[20];
    MiddleName: string[20];
    Position: string[50];
    Hours: Byte;
    ManagerCode: Integer;
  end;}

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
        PSwap(PHead, Current, Current^.Next);
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
        WSwap(WHead, Current, Current^.Next);
      Current := Current^.Next;
    end;
    Left := Left^.Next;
  end;
end;

function WField:Byte;
var
Menu:Char;
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
  until (Menu>='1') and (Menu<='5');
  Result:=Ord(Menu)-Ord('0');
end;

function PField:Byte;
var
Menu:Char;
begin
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
  until (Menu>='1') and (Menu<='5');
  Result:=Ord(Menu)-Ord('0');
end;

procedure Sort(PHead:PPointer; WHead:WPointer);
var
  Field:Byte;
begin
  Writeln('Выберите список дя сортировки:');
  case ChooseList of
      1:
        WSort(WHead, WField);
      2:
        PSort(PHead, PField);
    end;
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
    Writeln('Выберите пункт меню');
    Writeln('1. Чтение данных из файла');
    Writeln('2. Просмотр всего списка');
    Writeln('3. Сортировка списка');
    Writeln('4. Поиск данных с фильтром');
    Writeln('5. Добавление данных в список');
    Writeln('6. Удаление данных из списка');
    Writeln('7. Редактирование данных');
    Writeln('8. Сф');
    Writeln('9. Выйти из программы без сохранения');
    Writeln('10. Выход с сохранением изменений');
    Writeln;
    Readln(Menu);
    Writeln;
    case Menu of
      1:
        ReadFromFile(PHead, WHead);
      2:
        MenuPrint(PHead, WHead);
      3:
        Sort(PHead, WHead);
      4:
        Writeln('Поиск с фильтром...');
      5:
        MenuEnter(PHead, WHead);
      6:
        Writeln('Удаление...');
      7:
        Writeln('Редактирование...');
      8:
        Writeln('СФ...');
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
