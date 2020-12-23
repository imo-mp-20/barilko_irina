unit uLists;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGrids, Buttons, StdCtrls, ExtCtrls, DB, sqldb, Menus,
  MaskEdit, IBCustomDataSet, IBStoredProc{, Mask};

type

  { TfLists }

  TfLists = class(TForm)
    Panel1: TPanel;
    btEdit: TButton;
    btNew: TButton;
    btDelete: TButton;
    DBGrid1: TDBGrid;
    ds: TDataSource;
    qID_LIST: TIBIntegerField;
    qLIST_MASS: TFloatField;
    qLIST_NAME: TIBStringField;
    sp: TIBStoredProc;
    btFind: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    MaskEdit1: TMaskEdit;
    q: TIBDataSet;
    procedure FormActivate(Sender: TObject);
    procedure btEditClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btNewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btFindClick(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  fLists: TfLists;

implementation

uses uDm, uListsEd;

{$R *.lfm}

procedure TfLists.FormActivate(Sender: TObject);
// При активации формы
begin
  dbGrid1.ReadOnly := true;
  if ds.DataSet.Active then ds.DataSet.Close;
  ds.DataSet.Open;
end;

procedure TfLists.btEditClick(Sender: TObject);
// Вызов формы редактирования и корректировка строки
var
  Id_List: integer;
begin
  Id_List := ds.DataSet.FieldByName( 'Id_List' ).AsInteger;
  fListsEd.txtList_Mass.Text := ds.DataSet.FieldByName( 'List_Mass' ).AsString;
  fListsEd.txtList_Name.Text := ds.DataSet.FieldByName( 'List_Name' ).AsString;

  if fListsEd.ShowModal = mrOK then begin
    try
      with sp do begin
        if Active then Close;
        StoredProcName := 'LISTS_UPD';
        with Params do begin
          Clear;
          CreateParam( ftInteger,'Id_List',ptInput ).AsInteger := ds.DataSet['Id_List'];
          CreateParam( ftFloat, 'List_Mass', ptInput ).AsFloat :=
            StrToFloat(fListsEd.txtList_Mass.Text);
          CreateParam( ftString, 'List_Name', ptInput ).AsString :=
            fListsEd.txtList_Name.Text;

        end; // with Params

        Prepare;
        ExecProc;
        dm.trans.Commit;
      end; // with sp

      dm.trans.StartTransaction;
        ds.DataSet.Open;
      ds.DataSet.Locate('Id_List', Id_List, [] );
    except
      ShowMessage('Ошибка редактирования!');
    end;
  end;

end;

procedure TfLists.btDeleteClick(Sender: TObject);
// Удаление строки
begin
  if MessageDlg('Удалить', mtConfirmation, mbYesNoCancel, 0) <> mrYes then
      Abort
  else
    with sp do begin
      if Active then Close;
      StoredProcName:= 'LISTS_DEL';

      with Params do begin
        Clear;
        CreateParam(ftInteger, 'Id_List', ptInput).AsInteger := ds.DataSet['Id_List'];
      end; // with Params

      try
        Prepare;
        ExecProc;

        ds.DataSet.Close;
        ds.DataSet.Open;
      except
         ShowMessage('Удаление запрещено!');
      end; // with sp
    end; // if
end;

procedure TfLists.btNewClick(Sender: TObject);
// Вызов формы редактирования и вставка строки
var
  Id_List: integer;
begin

  if fListsEd.ShowModal = mrOK then begin
    try
      with sp do begin
        if Active then Close;
        StoredProcName := 'LISTS_INS';
        with Params do begin
          Clear;
          CreateParam( ftFloat, 'List_Mass', ptInput ).AsFloat := StrToFloat(fListsEd.txtList_Mass.Text);
          CreateParam( ftString, 'List_Name', ptInput ).AsString := fListsEd.txtList_Name.Text;
          CreateParam( ftInteger, 'Id_List', ptOutput ).AsInteger;

        end; // with Params

        Prepare;
        ExecProc;
        dm.trans.Commit;
        Id_List := sp.ParamByName( 'Id_List' ).AsInteger;
      end; // with sp

      dm.trans.StartTransaction;
        //ds.DataSet.Close;
        ds.DataSet.Open;
      ds.DataSet.Locate('Id_List', Id_List, [] );
    except
      ShowMessage('Ошибка добавления!');
    end;
  end;

end;

procedure TfLists.FormClose(Sender: TObject; var Action: TCloseAction);
// При закрытии формы
begin
  ds.DataSet.Close;
end;

procedure TfLists.btFindClick(Sender: TObject);
// Поиск по названию
begin
  if ( MaskEdit1.Text <> '' ) then
    begin
      if not ds.DataSet.Locate('List_Name', MaskEdit1.Text, [loPartialKey]) then
        ShowMessage('Не найдено');
    end;
end;

end.

