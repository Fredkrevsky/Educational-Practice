program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  EPfunctions;
// Дебильные названия файлов

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
    Writeln('Выберите пункт меню:');
    Writeln('1. Чтение данных из файла');
    Writeln('2. Просмотр всего списка');
    Writeln('3. Сортировка списка');
    Writeln('4. Поиск данных с фильтром');
    Writeln('5. Добавление данных в список');
    Writeln('6. Удаление данных из списка');
    Writeln('7. Редактирование данных');
    Writeln('8. Руководителю/сотруднику');
    Writeln('9. Выйти из программы без сохранения');
    Writeln('10. Выход с сохранением изменений');
    Writeln;
    Readln(PunktOfMenu);
    Writeln;
    isCorrect := (Length(PunktOfMenu) = 1) and (PunktOfMenu >= '1') and
      (PunktOfMenu <= '9') or (PunktOfMenu = '10');
    if isCorrect then
    begin
      case StrToInt(PunktOfMenu) of
        1:
          ReadFromFile(WHead, PHead);
        2:
          MenuPrint(WHead, PHead);
        3:
          Sort(WHead, PHead);
        4:
          Search(WHead, PHead, 'P');
        5:
          MenuEnter(WHead, PHead);
        6:
          Search(WHead, PHead, 'D');
        7:
          Search(WHead, PHead, 'E');
        8:
          ProjectsAndTasks(WHead, PHead);
        10:
          WriteToFile(WHead, PHead);
      end;
      Writeln;
    end
    else
    begin
      Writeln('Ошибка. Введите ещё раз:');
      Writeln;
    end;
  until (PunktOfMenu = '10') or (PunktOfMenu = '9');
  DisposeAll(WHead, PHead);
end;

begin
  Menu;

end.
