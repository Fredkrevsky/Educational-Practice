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
    Dolzh: string; // Переименовать потом
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
  Writeln('Код сотрудника: ', Head^.Data.Code);
  Writeln('Фамилия: ', Head^.Data.LastName);
  Writeln('Имя: ', Head^.Data.Name);
  Writeln('Отчество: ', Head^.Data.MiddleName);
  Writeln('Должность: ', Head^.Data.Dolzh);
  Writeln('Количество часов в сутки: ', Head^.Data.Hours);
  Writeln('Код руководителя: ', Head^.Data.ManagerCode);
  Writeln;
end;

procedure PrintProject(Head: PPointer);
begin
  Writeln('Название проекта: ', Head^.Data.Name);
  Writeln('Задания проекта: ', Head^.Data.Task);
  Writeln('Код исполнителя: ', Head^.Data.IspCode);
  Writeln('Код руководителя: ', Head^.Data.ManagerCode);
  Writeln('Дата выдачи: ', Head^.Data.VydDate);
  Writeln('Срок выполнения: ', Head^.Data.Srok);
  Writeln;
end;

begin

end.
