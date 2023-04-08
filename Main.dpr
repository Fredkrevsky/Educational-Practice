program Main;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  WPointer = ^TWorker;

  TWorkerData = record
    Code: Integer;
    LastName: string;
    Name: string;
    MiddleName: string;
    Dolzh: string; // ������������� �����
    Hours: Byte;
    ManagerCode: Integer;
  end;

  TWorker = record
    Previous: Pointer;
    Data: TWorkerData;
    Next: Pointer;
  end;

  PPointer = ^TProject;

  TProjectData = record
    Name: string;
    Task: string;
    IspCode: Integer;
    ManagerCode: string;
    VydDate: string;
    Srok: string;
  end;

  TProject = record
    Previous: PPointer;
    Data: TProjectData;
    Next: PPointer;
  end;

procedure PrintWorkers(Head: WPointer);
begin
  Writeln('��� ����������: ', Head^.Data.Code);
  Writeln('�������: ', Head^.Data.LastName);
  Writeln('���: ', Head^.Data.Name);
  Writeln('��������: ', Head^.Data.MiddleName);
  Writeln('���������: ', Head^.Data.Dolzh);
  Writeln('���������� ����� � �����: ', Head^.Data.Hours);
  Writeln('��� ������������: ', Head^.Data.ManagerCode);
  Writeln;
end;

procedure PrintProject(Head: PPointer);
begin
  Writeln('�������� �������: ', Head^.Data.Name);
  Writeln('������� �������: ', Head^.Data.Task);
  Writeln('��� �����������: ', Head^.Data.IspCode);
  Writeln('��� ������������: ', Head^.Data.ManagerCode);
  Writeln('���� ������: ', Head^.Data.VydDate);
  Writeln('���� ����������: ', Head^.Data.Srok);
  Writeln;
end;

begin

end.
