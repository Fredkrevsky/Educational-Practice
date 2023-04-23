program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  EPfunctions;



procedure Menu;
var
  isCorrect: Boolean;
  PunktOfMenu: string;
  PHead: PPointer;
  WHead: WPointer;
  FileName: string;
  P: FP;
  W: FW;
begin
  isCorrect := False;
  New(PHead);
  New(WHead);
  PHead^.Next := nil;
  WHead^.Next := nil;
  repeat
    Writeln('Выберите пункт меню');
    Writeln('1. Чтение данных из файла'); // Готово
    Writeln('2. Просмотр всего списка'); // Готово
    Writeln('3. Сортировка списка');      //Готово
    Writeln('4. Поиск данных с фильтром'); // Готово
    Writeln('5. Добавление данных в список');
    Writeln('6. Удаление данных из списка');
    Writeln('7. Редактирование данных');
    Writeln('8. Сф');
    Writeln('9. Выйти из программы без сохранения'); // Готово
    Writeln('10. Выход с сохранением изменений'); // Готово
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
          Search(PHead, WHead);
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
