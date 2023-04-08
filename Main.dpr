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
      Temp := Head;
      New(Head);
      EnterWorker(Head);
      Temp^.Next := Head;
    end
    else if Menu <> '2' then
      Writeln('Ошибка');
  until Menu = '2';
  Head^.Next := nil;
end;

procedure EnterProjects(Head: PPointer);

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

var
  Menu: string;
  Temp: PPointer;
begin
  repeat
    Writeln('Выберите пункт меню:');
    Writeln('1. Ввести данные о сотруднике');
    Writeln('2. Выход');
    Readln(Menu);
    if Menu = '1' then
    begin
      Temp := Head;
      New(Head);
      EnterProject(Head);
      Temp^.Next := Head;
    end
    else if Menu <> '2' then
      Writeln('Ошибка');
  until Menu = '2';
  Head^.Next := nil;
end;

procedure PrintWorkers(Head: WPointer);

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

procedure PrintProjects(Head: PPointer);

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
var
  Menu: Char;
begin
  Writeln('Выберите, что выводить:');
  Writeln('1. Список сотрудников');
  Writeln('2. Список проектов');
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
        Writeln('Чтение данных из файла...');
      2:
        begin
          New(PHead);
          New(WHead);
          PHead^.Next := nil;
          WHead^.Next := nil;
          MenuPrint(PHead, WHead);
        end;
      3:
        Writeln('Сортировка...');
      4:
        Writeln('Поиск с фильтром...');
      5:
        Writeln('Добавление...');
      6:
        Writeln('Удаление...');
      7:
        Writeln('Редактирование...');
      8:
        Writeln('СФ...');
      9:
        Writeln('Выход с сохранением...');
      10:
        Writeln('Выход без сохранения...');

    end;
    Writeln;
  until Menu = 10;

end;

begin
  Menu;

end.
