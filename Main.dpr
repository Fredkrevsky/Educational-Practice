program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  EPfunctions;

procedure DeleteRecord(WHead:WPointer; PHead:PPointer);
begin

end;

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
    Writeln('�������� ����� ����');
    Writeln('1. ������ ������ �� �����'); // ������
    Writeln('2. �������� ����� ������'); // ������
    Writeln('3. ���������� ������');      //������
    Writeln('4. ����� ������ � ��������'); // ������
    Writeln('5. ���������� ������ � ������');  //������
    Writeln('6. �������� ������ �� ������');   //������
    Writeln('7. �������������� ������');       //������
    Writeln('8. ��');
    Writeln('9. ����� �� ��������� ��� ����������'); // ������
    Writeln('10. ����� � ����������� ���������'); // ������
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
          Search(PHead, WHead, 'P');
        5:
          MenuEnter(PHead, WHead);
        6:
          Search(PHead, WHead, 'D');
        7:
          Search(PHead, WHead, 'E');
        8:
          Writeln('��...');
        10:
          WriteToFile(PHead, WHead);
      end;
      Writeln;
    end
    else
    begin
      Writeln('������. ������� ��� ���:');
      Writeln;
    end;
  until (PunktOfMenu = '10') or (PunktOfMenu = '9');
  DisposeAll(WHead, PHead);
end;

begin
  Menu;

end.
