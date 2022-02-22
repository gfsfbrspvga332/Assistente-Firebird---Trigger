unit unitPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Spin;

type

  { TformPrincipal }

  TformPrincipal = class(TForm)
    Button1: TButton;
    CheckGroup1: TCheckGroup;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    SpinEdit1: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  formPrincipal: TformPrincipal;

implementation

{$R *.lfm}

{ TformPrincipal }

//configura a execução inicial
procedure TformPrincipal.FormShow(Sender: TObject);
begin
  Edit1.Text := 'NOME';
  Edit2.Text := 'TABELA';
  RadioGroup1.ItemIndex := 0;
  CheckGroup1.Checked[0] := false;
  CheckGroup1.Checked[1] := false;
  CheckGroup1.Checked[2] := false;
  SpinEdit1.Value := 0;
  Memo1.Lines.Clear;
  Edit2.SetFocus;
end;

//programação que gera o trigger
procedure TformPrincipal.Button1Click(Sender: TObject);
var
  linha, linha2: String;
  acao: Integer;
begin
  //limpa o memo
  Memo1.Lines.Clear;
  acao := 0;

  //termo inicial
  Memo1.Lines.Add('SET TERM ^ ;');
  Memo1.Lines.Add('');

  //configura as linhas
  linha := 'CREATE TRIGGER '+Edit2.Text+'_';
  linha2 := 'ACTIVE ';

  //configura antes/depois
  if RadioGroup1.ItemIndex = 0 then
    begin
      linha += 'B';
      linha2 += 'BEFORE ';
    end
  else
    begin
      linha += 'A';
      linha2 += 'AFTER ';
    end;

  //configura modo de uso
  if CheckGroup1.Checked[0] = True then
    begin
      linha += 'I';
      if acao = 0 then
        begin
          linha2 += 'INSERT ';
          acao += 1;
        end;
    end;
  if CheckGroup1.Checked[1] = True then
    begin
      linha += 'U';
      if acao = 0 then
        begin
          linha2 += 'UPDATE ';
          acao += 1;
        end
      else
        begin
          linha2 += 'OR UPDATE ';
          acao += 1;
        end;
    end;
  if CheckGroup1.Checked[2] = True then
    begin
      linha += 'D';
      if acao = 0 then
        begin
          linha2 += 'DELETE ';
          acao += 1;
        end
      else
        begin
          linha2 += 'OR DELETE ';
          acao += 1;
        end;
    end;

  //configura a posicao
  linha2 += 'POSITION '+IntToStr(SpinEdit1.Value);

  //configura o campo
  linha += '_'+Edit3.Text+' FOR '+Edit2.Text;

  //salva as linha
  Memo1.Lines.Add(linha);
  Memo1.Lines.Add(linha2);

  //as
  Memo1.Lines.Add('AS');

  //begin
  Memo1.Lines.Add('BEGIN');

  //configura o conteudo do trigger
  acao := 0;
  if CheckGroup1.Checked[0] = True then
    begin
      Memo1.Lines.Add('  IF (INSERTING) THEN');
      Memo1.Lines.Add('  BEGIN');
      Memo1.Lines.Add('');
      Memo1.Lines.Add('    /*programação para a inserção...*/');
      Memo1.Lines.Add('');
      Memo1.Lines.Add('  END');
      acao += 1;
    end;
  if CheckGroup1.Checked[1] = True then
    begin
      if acao = 0 then
        begin
          Memo1.Lines.Add('  IF (UPDATING) THEN');
          Memo1.Lines.Add('  BEGIN');
          Memo1.Lines.Add('');
          Memo1.Lines.Add('    /*programação para a atualização...*/');
          Memo1.Lines.Add('');
          Memo1.Lines.Add('  END');
          acao += 1;
        end
      else
        begin
          Memo1.Lines.Add('  ELSE');
          Memo1.Lines.Add('    IF (UPDATING) THEN');
          Memo1.Lines.Add('    BEGIN');
          Memo1.Lines.Add('');
          Memo1.Lines.Add('      /*programação para a atualização...*/');
          Memo1.Lines.Add('');
          Memo1.Lines.Add('    END');
          acao += 1;
        end;
    end;
  if CheckGroup1.Checked[2] = True then
    begin
      if acao = 0 then
        begin
          Memo1.Lines.Add('  IF (DELETING) THEN');
          Memo1.Lines.Add('  BEGIN');
          Memo1.Lines.Add('');
          Memo1.Lines.Add('    /*programação para a delete...*/');
          Memo1.Lines.Add('');
          Memo1.Lines.Add('  END');
          acao += 1;
        end
      else
        begin
          if acao = 1 then
            begin
              Memo1.Lines.Add('  ELSE');
              Memo1.Lines.Add('    IF (DELETING) THEN');
              Memo1.Lines.Add('    BEGIN');
              Memo1.Lines.Add('');
              Memo1.Lines.Add('      /*programação para a delete...*/');
              Memo1.Lines.Add('');
              Memo1.Lines.Add('    END');
              acao += 1;
            end
          else
            if acao = 2 then
              begin
                Memo1.Lines.Add('    ELSE');
                Memo1.Lines.Add('      IF (DELETING) THEN');
                Memo1.Lines.Add('      BEGIN');
                Memo1.Lines.Add('');
                Memo1.Lines.Add('        /*programação para a delete...*/');
                Memo1.Lines.Add('');
                Memo1.Lines.Add('      END');
                acao += 1;
              end;
        end;
    end;

  //ultimo end
  Memo1.Lines.Add('END');
  Memo1.Lines.Add('^');
  Memo1.Lines.Add('');
  Memo1.Lines.Add('SET TERM ; ^');

  Memo1.SetFocus;
  Memo1.SelectAll;
  Memo1.CopyToClipboard;
end;

end.

