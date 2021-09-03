{******************************************************************************}
{                                                                              }
{       FExplorer: Shell extensions per Fattura Elettronica                    }
{       (Preview Panel, Thumbnail Icon, F.E.Viewer)                            }
{                                                                              }
{       Copyright (c) 2021 (Ethea S.r.l.)                                      }
{       Author: Carlo Barazzetta                                               }
{                                                                              }
{       https://github.com/EtheaDev/FExplorer                                  }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit FExplorer.ViewerMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ImgList, Contnrs,
  SynEdit, ActnList, Menus, ToolWin,
  StdActns, SynEditHighlighter,
  FExplorer.Resources, SynEditPrint, SynEditOptionsDialog, ActnCtrls, ActnMan,
  ActnMenus, SynCompletionProposal, SynEditTypes, SynEditMiscClasses,
  SynEditSearch, XPStyleActnCtrls, System.Actions, SVGIconImage, Vcl.Buttons,
  Vcl.CategoryButtons, Vcl.WinXCtrls, System.ImageList, Vcl.VirtualImageList,
  FExplorer.Settings
  , System.Generics.Collections
  , FExplorer.ThumbnailResources
  , Vcl.PlatformVclStylesActnCtrls
  , Vcl.Styles.Fixes
  , Vcl.Styles.FormStyleHooks
  , Vcl.Styles.NC
  , Vcl.Styles.OwnerDrawFix
  , Vcl.Styles.Utils.ScreenTips
  , Vcl.Styles.Utils.SysStyleHook
  , Vcl.Styles.Utils
  , Vcl.Styles.Utils.SysControls
  , Vcl.Styles.UxTheme
//  {$IFDEF WIN32}
  , Vcl.Styles.Hooks
  , Vcl.Styles.Utils.Forms
  , Vcl.Styles.Utils.ComCtrls
  , Vcl.Styles.Utils.StdCtrls
//  {$ENDIF}
  , Vcl.Styles.Ext
  , HTMLUn2
  , HtmlView
  , uDragDropUtils
  ;

const
  SET_FILE_NAME = 'HiglightSettings';

resourcestring
  PAGE_HEADER_FIRST_LINE_LEFT = '$TITLE$';
  PAGE_HEADER_FIRST_LINE_RIGHT = 'Tot. Pagine: $PAGECOUNT$';
  PAGE_FOOTER_FIRST_LINE_LEFT = 'Data di stampa: $DATE$. Ora: $TIME$';
  PAGE_FOOTER_FIRST_LINE_RIGHT = 'Pagina $PAGENUM$ di $PAGECOUNT$';
  FILE_NOT_FOUND = 'File "%s" non trovato!';
  SMODIFIED = 'Modificato';
  SUNMODIFIED = 'Non modificato';
  STATE_READONLY = 'Sola lettura';
  STATE_INSERT = 'Inserimento';
  STATE_OVERWRITE = 'Sovrascrittura';
  CLOSING_PROBLEMS = 'Problemi in chiusura!';
  CONFIRM_ABANDON = 'File "%s" non salvato! Si voglionoi abbandonare le modifiche fatte?';
  FILE_SAVED = 'File "%s" salvato correttamente: vuoi aprirlo subito?';
  SVG_PARSING_OK = 'Il parsing SVG è corretto.';

type
  TEditingFile = class
  private
    FIcon : TIcon;
    FFileName : string;
    FName : string;
    FExtension: string;
    FShowXMLText: Boolean;
    FInvoice: TLegalInvoice;
    FAllegatiButtons: TObjectList<TToolButton>;
    FFileContentType: TFileContentType;
    procedure ReadFromFile;
    procedure SaveToFile;
    function GetFileName: string;
    function GetName: string;
    procedure SetFileName(const Value: string);
    procedure RenderAllegati;
    procedure AllegatoButtonClick(Sender: TObject);
    procedure UpdateContentType;
    function GetImageName: string;
  public
    EditFileType: TEditFileType;
    SynEditor: TSynEdit;
    HTMLViewer: THTMLViewer;
    ToolbarAllegati: TToolBar;
    TabSheet: TTabSheet;
    Splitter: TSplitter;
    Constructor Create(const EditFileName : string);
    Destructor Destroy; override;
    procedure MostraFatturaXML(const ASettings: TEditorSettings);
    procedure MostraFatturaForStyleSheet(const ASettings: TEditorSettings;
      const ASourceXMLInvoice: string; const AStyleSheet: string = '');
    property FileName: string read GetFileName write SetFileName; //with full path
    property Name: string read GetName; //only name of file
    property ImageName: string read GetImageName;
    property Extension: string read FExtension;
    property ContentType: TFileContentType read FFileContentType;
  end;

  TfrmMain = class(TForm, IDragDrop)
    OpenDialog: TOpenDialog;
    ActionList: TActionList;
    acOpenFile: TAction;
    acSave: TAction;
    SaveDialog: TSaveDialog;
    acEditCut: TEditCut;
    acEditCopy: TEditCopy;
    acEditPaste: TEditPaste;
    acEditSelectAll: TEditSelectAll;
    acEditUndo: TEditUndo;
    popEditor: TPopupMenu;
    CopyMenuItem: TMenuItem;
    CutMenuItem: TMenuItem;
    PasteMenuItem: TMenuItem;
    Sep2MenuItem: TMenuItem;
    acSearch: TAction;
    acReplace: TAction;
    SearchMenuItem: TMenuItem;
    ReplaceMenuItem: TMenuItem;
    acQuit: TAction;
    acNewFile: TAction;
    acAbout: TAction;
    acClose: TAction;
    acCloseAll: TAction;
    acSaveAll: TAction;
    acSearchAgain: TAction;
    actnPrint: TAction;
    PrinterSetupDialog: TPrinterSetupDialog;
    PrintDialog: TPrintDialog;
    SynEditPrint: TSynEditPrint;
    actnPrinterSetup: TAction;
    actnPrintPreview: TAction;
    actnPageSetup: TAction;
    actnEditOptions: TAction;
    actnEnlargeFont: TAction;
    actnReduceFont: TAction;
    actnSaveAs: TAction;
    StatusBar: TStatusBar;
    actnColorSettings: TAction;
    actnFormatXML: TAction;
    SynEditSearch: TSynEditSearch;
    ImagePanel: TPanel;
    SVGIconImage: TSVGIconImage;
    RightSplitter: TSplitter;
    panelPreview: TPanel;
    SV: TSplitView;
    catMenuItems: TCategoryButtons;
    panlTop: TPanel;
    lblTitle: TLabel;
    SettingsToolBar: TToolBar;
    ColorSettingsToolButton: TToolButton;
    EditOptionsToolButton: TToolButton;
    VirtualImageList: TVirtualImageList;
    actMenu: TAction;
    MenuButtonToolbar: TToolBar;
    ToolButton1: TToolButton;
    PageSetupToolButton: TToolButton;
    PrinterSetupToolButton: TToolButton;
    AboutToolButton: TToolButton;
    QuitToolButton: TToolButton;
    ToolButton9: TToolButton;
    FlowPanel: TFlowPanel;
    SVGIconImage16: TSVGIconImage;
    SVGIconImage32: TSVGIconImage;
    SVGIconImage48: TSVGIconImage;
    SVGIconImage96: TSVGIconImage;
    BackgroundTrackBar: TTrackBar;
    BackgroundGrayScaleLabel: TLabel;
    OpenRecentAction: TAction;
    RecentPopupMenu: TPopupMenu;
    SaveMenuItem: TMenuItem;
    CloseMenuItem: TMenuItem;
    Sep1MenuItem: TMenuItem;
    SelectAllMenuItem: TMenuItem;
    Reformattext1: TMenuItem;
    ImagePreviewPanel: TPanel;
    N1: TMenuItem;
    StatusPanel: TPanel;
    StatusImage: TSVGIconImage;
    StatusStaticText: TStaticText;
    StatusSplitter: TSplitter;
    CloseAll1: TMenuItem;
    ClientPanel: TPanel;
    PageControl: TPageControl;
    PopHTMLViewer: TPopupMenu;
    acZoomIn: TAction;
    acZoomOut: TAction;
    Zoom1: TMenuItem;
    Zoom2: TMenuItem;
    acSaveHTMLFile: TAction;
    SaveHTMLfile1: TMenuItem;
    acSavePDFFile: TAction;
    SavePDFfile1: TMenuItem;
    Chiudi1: TMenuItem;
    Chiuditutto1: TMenuItem;
    PopHTMLSep: TMenuItem;
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure acOpenFileExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShowSRDialog(aReplace: boolean);
    procedure DoSearchReplaceText(AReplace: boolean;
      ABackwards: boolean);
    procedure acSearchExecute(Sender: TObject);
    procedure acReplaceExecute(Sender: TObject);
    procedure acQuitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acNewFileExecute(Sender: TObject);
    procedure acSearchUpdate(Sender: TObject);
    procedure acReplaceUpdate(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure acCloseAllUpdate(Sender: TObject);
    procedure acCloseAllExecute(Sender: TObject);
    procedure acSaveAllUpdate(Sender: TObject);
    procedure acSaveAllExecute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure acSearchAgainExecute(Sender: TObject);
    procedure acSearchAgainUpdate(Sender: TObject);
    procedure actnPrinterSetupExecute(Sender: TObject);
    procedure actnPrintPreviewExecute(Sender: TObject);
    procedure actnPrintExecute(Sender: TObject);
    procedure actnPageSetupExecute(Sender: TObject);
    procedure actnEditOptionsExecute(Sender: TObject);
    procedure actnEditingUpdate(Sender: TObject);
    procedure actnFontExecute(Sender: TObject);
    procedure actnSaveAsExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actnColorSettingsExecute(Sender: TObject);
    procedure actnColorSettingsUpdate(Sender: TObject);
    procedure actnFormatXMLExecute(Sender: TObject);
    procedure actionForFileUpdate(Sender: TObject);
    procedure HistoryListClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actMenuExecute(Sender: TObject);
    procedure BackgroundTrackBarChange(Sender: TObject);
    procedure acEditUndoExecute(Sender: TObject);
    procedure SVOpened(Sender: TObject);
    procedure SVClosed(Sender: TObject);
    procedure SVClosing(Sender: TObject);
    procedure SVOpening(Sender: TObject);
    procedure ActionListExecute(Action: TBasicAction; var Handled: Boolean);
    procedure catMenuItemsMouseLeave(Sender: TObject);
    procedure catMenuItemsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure catMenuItemsGetHint(Sender: TObject; const Button: TButtonItem;
      const Category: TButtonCategory; var HintStr: string;
      var Handled: Boolean);
    procedure RecentPopupMenuPopup(Sender: TObject);
    procedure OpenRecentActionExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
      NewDPI: Integer);
    procedure FormBeforeMonitorDpiChanged(Sender: TObject; OldDPI,
      NewDPI: Integer);
    procedure acEditCutExecute(Sender: TObject);
    procedure acEditCopyExecute(Sender: TObject);
    procedure acEditPasteExecute(Sender: TObject);
    procedure acEditSelectAllExecute(Sender: TObject);
    procedure acEditUndoUpdate(Sender: TObject);
    procedure SVGIconImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acZoomExecute(Sender: TObject);
    procedure acEditCopyUpdate(Sender: TObject);
    procedure acSaveHTMLFileExecute(Sender: TObject);
    procedure acSavePDFFileExecute(Sender: TObject);
  private
    MinFormWidth, MinFormHeight, MaxFormWidth, MaxFormHeight: Integer;
    FThumbnailResource: TdmThumbnailResources;
    FProcessingFiles: Boolean;
    FEditorSettings: TEditorSettings;
    currentDir: string;
    EditFileList: TObjectList;
    fSearchFromCaret: boolean;
    gbSearchBackwards: boolean;
    gbSearchCaseSensitive: boolean;
    gbSearchFromCaret: boolean;
    gbSearchSelectionOnly: boolean;
    gbSearchTextAtCaret: boolean;
    gbSearchWholeWords: boolean;
    gsSearchText: string;
    gsSearchTextHistory: string;
    gsReplaceText: string;
    gsReplaceTextHistory: string;
    FEditorOptions: TSynEditorOptionsContainer;
    FXMLFontSize: Integer;
    FHTMLFontSize: Integer;
    FXMLInvoice: TEditingFile;
    FXSLForInvoice: TEditingFile;
    FXSLForIconFile: TEditingFile;
    FDropTarget: TDropTarget;
    // implement IDragDrop
    function DropAllowed(const FileNames: array of string): Boolean;
    procedure Drop(const FileNames: array of string);
    procedure CloseSplitViewMenu;
    procedure UpdateHighlighters;
    procedure UpdateFromSettings(AEditor: TSynEdit);
    function DialogPosRect: TRect;
    procedure AdjustCompactWidth;
    function OpenFile(const FileName: string;
      const ARaiseError: Boolean = True): Boolean;
    function AddEditingFile(EditingFile: TEditingFile): Integer;
    procedure RemoveEditingFile(EditingFile: TEditingFile);
    function CurrentEditFile: TEditingFile;
    function CurrentEditor: TSynEdit;
    function ModifiedCount: integer;
    procedure InitSynEditPrint;
    procedure InitEditorOptions;
    procedure SetSynEditPrintProperties(SynEditPrint : TSynEditPrint);
    procedure UpdateEditorsOptions;
    function CurrentEditorState : string;
    procedure UpdateStatusBarPanels;
    procedure AddOpenedFile(const AFileName: string);
    procedure UpdateInvoiceViewer;
    procedure SynEditChange(Sender: TObject);
    procedure SynEditEnter(Sender: TObject);
    procedure UpdateHighlighter(ASynEditor: TSynEdit);
    procedure SetXMLFontSize(const Value: Integer);
    procedure LoadOpenedFiles;
    procedure SetHTMLFontSize(const Value: Integer);
    procedure UpdateContentType;
    procedure HTMLToPDF(const APDFFileName: TFileName);
    procedure FileSavedAskToOpen(const AFileName: string);
    function CanAcceptFileName(const AFileName: string): Boolean;
    function AcceptedExtensions: string;
    property XMLFontSize: Integer read FXMLFontSize write SetXMLFontSize;
    property HTMLFontSize: Integer read FHTMLFontSize write SetHTMLFontSize;
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure DestroyWindowHandle; override;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Vcl.Themes
  , System.IOUtils
  , System.StrUtils
  , System.UITypes
  , Winapi.ShellAPI
  , uMisc
  , Xml.XMLDoc
  , dlgReplaceText
  , dlgSearchText
  , dlgConfirmReplace
  , FExplorer.About
  , DPageSetup
  , FSynHighlightProp
  , Math
  , Winapi.SHFolder
  , FExplorer.SettingsForm
  , BegaHtmlPrintPreviewForm
  , BegaPreview
  , SynPDF
  , vmHtmlToPdf
  , PKCS7Extractor
  ;

{$R *.dfm}

const
  STATUSBAR_PANEL_FONTNAME = 0;
  STATUSBAR_PANEL_FONTSIZE = 1;
  STATUSBAR_PANEL_CARET = 2;
  STATUSBAR_PANEL_MODIFIED = 3;
  STATUSBAR_PANEL_STATE = 4;
  STATUSBAR_MESSAGE = 5;

function DoubleQuote(const AValue: string): string;
begin
  Result := '"'+AValue+'"';
end;

procedure UpdateApplicationStyle(const VCLStyleName: string);
begin
  if StyleServices.Enabled then
    TStyleManager.SetStyle(VCLStyleName);
end;

{ TEditingFile }

procedure TEditingFile.MostraFatturaForStyleSheet(const ASettings: TEditorSettings;
  const ASourceXMLInvoice: string; const AStyleSheet: string = '');
var
  LStream: TStringStream;
begin
  try
    FInvoice := TLegalInvoice.Create(ASourceXMLInvoice, False);
    if AStyleSheet <> '' then
    begin
      dmResources.EditingTemplate.LoadFromXML(AStyleSheet);
      FInvoice.StylesheetName := TLegalInvoice.EDITING_XSLT;
    end
    else
    begin
      FInvoice.StylesheetName := ASettings.StylesheetName;
    end;

    FInvoice.Parse;

    //Carica il contenuto HTML trasformato dentro l'HTML-Viewer
    HtmlViewer.DefFontSize := ASettings.HTMLFontSize;
    HtmlViewer.DefFontName := ASettings.HTMLFontName;
    LStream := TStringStream.Create(FInvoice.HTML);
    try
      HtmlViewer.LoadFromStream(LStream);
      HtmlViewer.Visible := True;
    finally
      LStream.Free;
    end;

    RenderAllegati;
  except
    on E: Exception do
    begin
      Raise
    end;
  end;
end;

procedure TEditingFile.MostraFatturaXML(const ASettings: TEditorSettings);
var
  LStream: TStringStream;
begin
  try
    FInvoice := TLegalInvoice.Create(SynEditor.Lines.Text, False);
    FInvoice.StylesheetName := ASettings.StylesheetName;

    FInvoice.Parse;

    //Carica il contenuto HTML trasformato dentro l'HTML-Viewer
    HtmlViewer.DefFontSize := ASettings.HTMLFontSize;
    HtmlViewer.DefFontName := ASettings.HTMLFontName;
    LStream := TStringStream.Create(FInvoice.HTML);
    try
      HtmlViewer.LoadFromStream(LStream);
      HtmlViewer.Visible := True;
    finally
      LStream.Free;
    end;

    RenderAllegati;
  except
    on E: Exception do
    begin
      Raise
    end;
  end;
end;

procedure TEditingFile.RenderAllegati;
var
  LIndex: Integer;
  LAllegato: TLinkedDoc;
  LButton: TToolButton;
begin
  FAllegatiButtons.Clear;

  for LIndex := 0 to Length(FInvoice.Allegati) -1 do
  begin
    LAllegato := FInvoice.Allegati[LIndex];

    LButton := TToolButton.Create(nil);
    try
      LButton.Cursor := crHandPoint;
      LButton.AutoSize := True;
      LButton.Caption := LAllegato.FileName;
      LButton.ImageIndex := 41;
      LButton.ImageName := 'attachment';
      LButton.Tag := LIndex;
      LButton.OnClick := AllegatoButtonClick;
      ToolbarAllegati.InsertControl(LButton);
      FAllegatiButtons.Add(LButton);
    except
      LButton.Free;
      raise;
    end
  end;

  ToolbarAllegati.Visible := Length(FInvoice.Allegati) > 0;
end;

procedure TEditingFile.ReadFromFile;
begin
  TLegalInvoiceLoader.LoadFromFile(FFileName,
    SynEditor);
end;

procedure TEditingFile.AllegatoButtonClick(Sender: TObject);
var
  LButton: TToolButton;
  LAllegato: TLinkedDoc;
begin
  LButton := Sender as TToolButton;
  LAllegato := FInvoice.Allegati[LButton.Tag];
  LAllegato.DumpAndOpen;
end;

constructor TEditingFile.Create(const EditFileName: string);
var
  Filter : Word;
begin
  inherited Create;
  FShowXMLText := False;
  FAllegatiButtons := TObjectList<TToolButton>.Create(True);

  if not IsStyleHookRegistered(TCustomSynEdit, TScrollingStyleHook) then
    TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TScrollingStyleHook);

  FileName := EditFileName;
  Fextension := ExtractFileExt(FileName);
  FIcon := TIcon.Create;
  if FileExists(FileName) then
    FIcon.Handle := ExtractAssociatedIcon(hInstance, PChar(DoubleQuote(FileName)),Filter);
end;

function TEditingFile.GetFileName: string;
begin
  Result := FFileName;
end;

function TEditingFile.GetImageName: string;
begin
  Result := AImageNames[FFileContentType];
end;

function TEditingFile.GetName: string;
begin
  Result := FName;
end;

procedure TEditingFile.SetFileName(const Value: string);
var
  Ext : string;
begin
  FFileName := Value;
  FName := ExtractFileName(FFileName);
  Ext := ExtractFileExt(FFileName);
  EditFileType := dmResources.GetEditFileType(Ext);
  if TabSheet <> nil then
    TabSheet.Caption := Name;
end;

destructor TEditingFile.Destroy;
begin
  FreeAndNil(FAllegatiButtons);
  FreeAndNil(FIcon);
  FreeAndNil(HTMLViewer);
  FreeAndNil(SynEditor);
  inherited;
end;

procedure TEditingFile.UpdateContentType;
var
  LContent: string;
begin
  FFileContentType := fcGenericFile;
  LContent := SynEditor.Lines.Text;
  if SameText(Fextension,'.xml') or SameText(Fextension,'.p7m') then
  begin
    if pos(':FatturaElettronica', LContent) > 0 then
      FFileContentType := fcLegalInvoice
    else
      FFileContentType := fcGenericXML;
  end
  else if SameText(Fextension,'.xsl') then
  begin
    if pos(':FatturaElettronica', LContent) > 0 then
    begin
      if pos('<svg', LContent) > 0 then
        FFileContentType := fcStyleSheetSVGIcon
      else
        FFileContentType := fcStyleSheetLegalInvoice;
    end
    else
      FFileContentType := fcGenericXSL;
  end;
end;

procedure TEditingFile.SaveToFile;
begin
  SynEditor.Lines.SaveToFile(Self.FileName);
  SynEditor.Modified := False;
  SynEditor.OnChange(SynEditor);
end;

{ TfrmMain }

procedure TfrmMain.acOpenFileExecute(Sender: TObject);
var
  i : integer;
begin
  if OpenDialog.Execute then
  begin
    for i := 0 to OpenDialog.Files.Count -1 do
      OpenFile(OpenDialog.Files[i], False);
  end;
  UpdateInvoiceViewer;
end;

function TfrmMain.CanAcceptFileName(const AFileName: string): Boolean;
begin
  Result := pos(ExtractFileExt(AFileName), AcceptedExtensions) <> 0;
end;

function TfrmMain.AcceptedExtensions: string;
begin
  //Verifico l'estensione del file
  Result := '.xml;.p7m';
  if FEditorSettings.AllowXSL then
    Result := Result + ';.xsl';
end;

function TfrmMain.OpenFile(const FileName : string;
  const ARaiseError: Boolean = True): Boolean;
var
  EditingFile: TEditingFile;
  I, J: Integer;
begin
  Screen.Cursor := crHourGlass;
  Try
    FProcessingFiles := True;
    if FileExists(FileName) then
    begin
      if not CanAcceptFileName(FileName) then
        raise Exception.CreateFmt('Impossibile caricare un file che non abbia estensione "%s"',
        [AcceptedExtensions]);

      //ciclo per cercare se il file è già aperto
      EditingFile := nil;
      I := -1;
      for J := 0 to EditFileList.Count -1 do
      begin
        if SameText(FileName, TEditingFile(EditFileList.Items[J]).FileName) then
        begin
          EditingFile := TEditingFile(EditFileList.Items[J]);
          I := J;
          PageControl.ActivePageIndex := I;
          break;
        end;
      end;
      //Creo l'oggetto EditingFile
      Try
        if not Assigned(EditingFile) then
        begin
          EditingFile := TEditingFile.Create(FileName);
          //Aggiungo il file alla lista
          I := AddEditingFile(EditingFile);
        end;

        //Apro il file
        EditingFile.ReadFromFile;

        UpdateContentType;

        Result := True;
      Except
        if I >= 0 then
          RemoveEditingFile(EditingFile)
        else
          EditingFile.Free;
        raise;
      End;
      AddOpenedFile(FileName);
    end
    else
    begin
      Result := False;
      if ARaiseError then
        Raise EFilerError.CreateFmt(FILE_NOT_FOUND,[FileName]);
    end;
  Finally
    FProcessingFiles := False;
    Screen.Cursor := crDefault;
  End;
end;

procedure TfrmMain.OpenRecentActionExecute(Sender: TObject);
var
  LRect: TRect;
  LPoint: TPoint;
begin
  LRect := catMenuItems.Categories[0].Items[2].Bounds;
  LPoint.X := LRect.Right;
  LPoint.Y := LRect.Bottom+LRect.Height;
  LPoint   := ClientToScreen(LPoint);
  RecentPopupMenu.Popup(LPoint.X, LPoint.Y);
end;

procedure TfrmMain.acSaveExecute(Sender: TObject);
begin
  CurrentEditFile.SaveToFile;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FThumbnailResource);
  FreeAndNil(EditFileList);
  FreeAndNil(SynEditPrint);
  FreeAndNil(FEditorSettings);
  FreeAndNil(FEditorOptions);
  inherited;
end;

procedure TfrmMain.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [ssCtrl] then
  begin
    actnReduceFont.Execute;
    Handled := True;
  end;
end;

procedure TfrmMain.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [ssCtrl] then
  begin
    actnEnlargeFont.Execute;
    Handled := True;
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  AdjustCompactWidth;
end;

procedure TfrmMain.ShowSRDialog(aReplace: boolean);
var
  dlg: TTextSearchDialog;
begin
  if AReplace then
    dlg := TTextReplaceDialog.Create(Self)
  else
    dlg := TTextSearchDialog.Create(Self);
  with dlg do
  try
    // assign search options
    SearchBackwards := gbSearchBackwards;
    SearchCaseSensitive := gbSearchCaseSensitive;
    SearchFromCursor := gbSearchFromCaret;
    SearchInSelectionOnly := gbSearchSelectionOnly;
    // start with last search text
    SearchText := gsSearchText;
    if gbSearchTextAtCaret then
    begin
      // if something is selected search for that text
      if CurrentEditor.SelAvail and (CurrentEditor.BlockBegin.Line = CurrentEditor.BlockEnd.Line) then
        SearchText := CurrentEditor.SelText
      else
        SearchText := CurrentEditor.GetWordAtRowCol(CurrentEditor.CaretXY);
    end;
    SearchTextHistory := gsSearchTextHistory;
    if AReplace then
      with dlg as TTextReplaceDialog do
      begin
        ReplaceText := gsReplaceText;
        ReplaceTextHistory := gsReplaceTextHistory;
      end;
    SearchWholeWords := gbSearchWholeWords;
    if ShowModal = mrOK then
    begin
      gbSearchBackwards := SearchBackwards;
      gbSearchCaseSensitive := SearchCaseSensitive;
      gbSearchFromCaret := SearchFromCursor;
      gbSearchSelectionOnly := SearchInSelectionOnly;
      gbSearchWholeWords := SearchWholeWords;
      gsSearchText := SearchText;
      gsSearchTextHistory := SearchTextHistory;
      if AReplace then
        with dlg as TTextReplaceDialog do
        begin
          gsReplaceText := ReplaceText;
          gsReplaceTextHistory := ReplaceTextHistory;
        end;
      fSearchFromCaret := gbSearchFromCaret;
      if gsSearchText <> '' then
      begin
        DoSearchReplaceText(AReplace, gbSearchBackwards);
        fSearchFromCaret := TRUE;
      end;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TfrmMain.SVClosed(Sender: TObject);
begin
  // When TSplitView is closed, adjust ButtonOptions and Width
  catMenuItems.ButtonOptions := catMenuItems.ButtonOptions - [boShowCaptions];
  actMenu.Hint := 'Espandi';
end;

procedure TfrmMain.SVClosing(Sender: TObject);
begin
  if SV.Opened then
    SV.OpenedWidth := SV.Width;
end;

procedure TfrmMain.SVGIconImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  LSize: Integer;
begin
  LSize := Min(SVGIconImage.Width, SVGIconImage.Height);
  SVGIconImage.Hint := Format('%dx%d',[LSize, LSize]);
end;

procedure TfrmMain.SVOpened(Sender: TObject);
begin
  // When not animating, change size of catMenuItems when TSplitView is opened
  catMenuItems.ButtonOptions := catMenuItems.ButtonOptions + [boShowCaptions];
  actMenu.Hint := 'Collassa';
end;

procedure TfrmMain.SVOpening(Sender: TObject);
begin
  // When animating, change size of catMenuItems at the beginning of open
  catMenuItems.ButtonOptions := catMenuItems.ButtonOptions + [boShowCaptions];
end;

procedure TfrmMain.DestroyWindowHandle;
begin
  FreeAndNil(FDropTarget);
  inherited;
end;

function TfrmMain.DialogPosRect: TRect;
begin
  GetWindowRect(Self.Handle, Result);
end;

procedure TfrmMain.DoSearchReplaceText(AReplace: boolean;
  ABackwards: boolean);
var
  Options: TSynSearchOptions;
begin
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not fSearchFromCaret then
    Include(Options, ssoEntireScope);
  if gbSearchSelectionOnly then
    Include(Options, ssoSelectedOnly);
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);
  if CurrentEditor.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    if ssoBackwards in Options then
      CurrentEditor.BlockEnd := CurrentEditor.BlockBegin
    else
      CurrentEditor.BlockBegin := CurrentEditor.BlockEnd;
    CurrentEditor.CaretXY := CurrentEditor.BlockBegin;
  end;

  if ConfirmReplaceDialog <> nil then
    ConfirmReplaceDialog.Free;
end;

procedure TfrmMain.Drop(const FileNames: array of string);
var
  i: Integer;
begin
  for i := 0 to Length(FileNames)-1 do
  begin
    if CanAcceptFileName(FileNames[i]) then
      OpenFile(FileNames[i], False);
  end;
  UpdateInvoiceViewer;
end;

function TfrmMain.DropAllowed(const FileNames: array of string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Length(FileNames)-1 do
  begin
    Result := CanAcceptFileName(FileNames[i]);
    if Result then
      Break;
  end;
end;

procedure TfrmMain.acSearchExecute(Sender: TObject);
begin
  ShowSRDialog(false);
end;

procedure TfrmMain.acReplaceExecute(Sender: TObject);
begin
  ShowSRDialog(true);
end;

procedure TfrmMain.acQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  LFileList: TStringList;
  I: Integer;
  LCurrentFileName: string;
  LEditingFile: TEditingFile;
begin
  LFileList := TStringList.Create;
  try
    for I := 0 to EditFileList.Count -1 do
    begin
      LEditingFile := TEditingFile(EditFileList.Items[I]);
      if LEditingFile.SynEditor.Modified and
        (MessageDlg(Format(CONFIRM_ABANDON,[LEditingFile.FileName]),
          mtWarning, [mbYes, mbNo], 0) = mrNo) then
          Abort;
      LFileList.Add(LEditingFile.FileName);
    end;
    if CurrentEditFile <> nil then
      LCurrentFileName := CurrentEditFile.FileName
    else
      LCurrentFileName := '';
    FEditorSettings.UpdateOpenedFiles(LFileList, LCurrentFileName);
    FEditorSettings.WriteSettings(nil, FEditorOptions);
  finally
    LFileList.Free;
  end;
end;

procedure TfrmMain.LoadOpenedFiles;
var
  I: Integer;
  LFileName: string;
  LIndex: Integer;
begin
  LIndex := -1;
  for I := 0 to FEditorSettings.OpenedFileList.Count-1 do
  begin
    LFileName := FEditorSettings.OpenedFileList.Strings[I];
    if OpenFile(LFileName, False) and SameText(LFileName, FEditorSettings.CurrentFileName) then
      LIndex := I;
  end;
  if LIndex <> -1 then
    PageControl.ActivePageIndex := LIndex;
  UpdateInvoiceViewer;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  InitialDir : string;
  FileVersionStr: string;
begin
  FThumbnailResource := TdmThumbnailResources.Create(nil);
  //creo la lista dei files aperti
  EditFileList := TObjectList.Create(True);
  FEditorOptions := TSynEditorOptionsContainer.create(self);
  FEditorSettings := TEditorSettings.CreateSettings(nil, FEditorOptions);
  if not IsStyleHookRegistered(TCustomSynEdit, TScrollingStyleHook) then
    TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TScrollingStyleHook);

  if (Trim(FEditorSettings.StyleName) <> '') and not SameText('Windows', FEditorSettings.StyleName) then
    TStyleManager.TrySetStyle(FEditorSettings.StyleName, False);

  //Double font for title
  lblTitle.Font.Size := lblTitle.Font.Size * 2;

  //Bold font for image preview panel
  ImagePreviewPanel.Font.Style := ImagePreviewPanel.Font.Style + [fsBold];

  //Versione
  FileVersionStr := uMisc.GetFileVersion(GetModuleLocation());
  Application.Title := Application.Title + ' (Ver.'+FileVersionStr+')';
  Caption := Application.Title;

  WindowState := wsMaximized;

  UpdateFromSettings(nil);

  //Aggancia l'imagelist che si sgancia
  ActionList.Images := VirtualImageList;

  //directory di partenza
  CurrentDir := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath);

  //Inizializza output di stampa
  InitSynEditPrint;

  //Carico i files che erano rimasti aperti
  LoadOpenedFiles;

  //Inizializza Open e Save Dialog dalla Dir di lancio del programma
  if ParamStr(1) <> '' then
  begin
    //Carico l'eventuale file esterno
    InitialDir := ParamStr(1);
    OpenFile(ParamStr(1));
    UpdateInvoiceViewer;
  end
  else
    InitialDir := '.';

  OpenDialog.InitialDir := InitialDir;
  SaveDialog.InitialDir := InitialDir;

  //Aggiorna le impostazioni di tutti gli editor aperti
  UpdateEditorsOptions;
end;

procedure TfrmMain.acNewFileExecute(Sender: TObject);
var
  NewExt : string;
  EditingFile : TEditingFile;
  NewFileType : TEditFileType;
begin
  //Chiedo che tipo di file vuoto voglio aggiungere
  NewExt := 'svg';
  NewFileType := dmResources.GetEditFileType(NewExt);

  //Aggiungo un file vuoto
  EditingFile := TEditingFile.Create(CurrentDir+'New.'+NewExt);
  Try
    AddEditingFile(EditingFile);
    if EditingFile.SynEditor.CanFocus then
      EditingFile.SynEditor.SetFocus;
  Except
    EditingFile.Free;
    raise;
  End;
end;

procedure TfrmMain.acSearchUpdate(Sender: TObject);
begin
  acSearch.Enabled := (CurrentEditor <> nil) and (CurrentEditor.Text <> '');
end;

procedure TfrmMain.acReplaceUpdate(Sender: TObject);
begin
  acReplace.Enabled := (CurrentEditor <> nil) and (CurrentEditor.Text <> '')
    and not CurrentEditor.ReadOnly;
end;

procedure TfrmMain.acCloseExecute(Sender: TObject);
begin
  //Rimuovo il file da editare
  RemoveEditingFile(CurrentEditFile);
end;

procedure TfrmMain.acEditCopyExecute(Sender: TObject);
begin
 CurrentEditor.CopyToClipboard;
end;

procedure TfrmMain.acEditCopyUpdate(Sender: TObject);
begin
  acEditCopy.Enabled := (CurrentEditFile <> nil) and
    (CurrentEditFile.SynEditor.SelEnd - CurrentEditFile.SynEditor.SelStart > 0);
end;

procedure TfrmMain.acEditCutExecute(Sender: TObject);
begin
  CurrentEditor.CutToClipboard;
end;

procedure TfrmMain.acEditPasteExecute(Sender: TObject);
begin
  CurrentEditor.PasteFromClipboard;
end;

procedure TfrmMain.acEditSelectAllExecute(Sender: TObject);
begin
  CurrentEditor.SelectAll;
end;

procedure TfrmMain.acEditUndoExecute(Sender: TObject);
begin
  if CurrentEditor <> nil then
    CurrentEditor.Undo;
end;

procedure TfrmMain.acEditUndoUpdate(Sender: TObject);
begin
  acEditUndo.Enabled := (CurrentEditor <> nil) and CurrentEditor.Modified;
end;

procedure TfrmMain.UpdateContentType;
begin
  CurrentEditFile.UpdateContentType;
  if CurrentEditor.Modified then
    pageControl.ActivePage.Imagename := CurrentEditFile.ImageName
  else
    pageControl.ActivePage.Imagename := CurrentEditFile.ImageName+'-gray';

  case CurrentEditFile.ContentType of
    fcLegalInvoice: FXMLInvoice := CurrentEditFile;
    fcStyleSheetLegalInvoice: FXSLForInvoice := CurrentEditFile;
    fcStyleSheetSVGIcon: FXSLForIconFile := CurrentEditFile;
  end;
end;

procedure TfrmMain.SynEditChange(Sender: TObject);
begin
  if Sender = CurrentEditor then
  begin
    UpdateContentType;
    UpdateInvoiceViewer;
  end;
end;

procedure TfrmMain.SynEditEnter(Sender: TObject);
begin
  CloseSplitViewMenu;
end;

function TfrmMain.AddEditingFile(EditingFile: TEditingFile): Integer;
var
  LTabSheet: TTabSheet;
  LEditor: TSynEdit;
  LFEViewer: THtmlViewer;
  LToolBarAllegati: TToolbar;
  LSplitter: TSplitter;
begin
  //lo aggiungo alla lista dei file aperti
  Result := EditFileList.Add(EditingFile);
  //Appena aggiungo un'oggetto alla lista creo la pagina Associata
  LTabSheet := nil;
  LEditor := nil;
  LFEViewer := nil;
  Try
    LTabSheet := TTabSheet.Create(self);
    LTabSheet.PageControl := PageControl;
    //Attacco al TAG del tabsheet l'oggetto del file da editare
    LTabSheet.Tag := Integer(EditingFile);
    LTabSheet.Caption := EditingFile.Name;
    LTabSheet.Imagename := EditingFile.ImageName+'-gray';
    LTabSheet.Parent := PageControl;
    LTabSheet.TabVisible := True;
    EditingFile.TabSheet := LTabSheet;

    //Creo l'oggetto dell'editor all'interno della pagina con l'owner la pagina
    LEditor := TSynEdit.Create(nil);
    LEditor.OnChange := SynEditChange;
    LEditor.OnEnter := SynEditEnter;
    LEditor.MaxUndo := 5000;
    LEditor.Align := alClient;
    LEditor.Parent := LTabSheet;
    LEditor.SearchEngine := SynEditSearch;
    LEditor.PopupMenu := popEditor;
    //Assegna le preferenze dell'utente
    FEditorOptions.AssignTo(LEditor);
    LEditor.MaxScrollWidth := 3000;
    EditingFile.SynEditor := LEditor;

    LFEViewer := THtmlViewer.Create(nil);
    LFEViewer.ScrollBars := ssNone;
    LFEViewer.Align := alRight;
    LFEViewer.Width := LTabSheet.Width div 2;
    LFEViewer.Parent := LTabSheet;
    LFEViewer.PopupMenu := PopHTMLViewer;

    LToolBarAllegati := TToolbar.Create(LTabSheet);
    LToolBarAllegati.Align := alTop;
    LToolBarAllegati.List := True;
    LToolBarAllegati.ShowCaptions := True;
    LToolBarAllegati.Height := 30;
    LToolBarAllegati.Parent := LTabSheet;
    LToolBarAllegati.Images := VirtualImageList;

    LSplitter := TSplitter.Create(LTabSheet);
    LSplitter.Align := alRight;
    LSplitter.Left := LFEViewer.Left-1;
    LSplitter.AutoSnap := False;
    LSplitter.Width := 6;
    LSplitter.Parent := LTabSheet;
    LSplitter.Beveled := True;

    EditingFile.Splitter := LSplitter;
    EditingFile.ToolbarAllegati := LToolBarAllegati;
    EditingFile.HTMLViewer := LFEViewer;

    UpdateFromSettings(LEditor);
    UpdateHighlighter(LEditor);
    LEditor.Visible := True;

    //Visualizzo il tabsheet
    LTabSheet.Visible := True;
  Except
    LTabSheet.Free;
    LEditor.Free;
    LFEViewer.Free;
    raise;
  End;

  //Attivo la pagina appena creata
  PageControl.ActivePage := LTabSheet;

  //Forzo "change" della pagina
  PageControl.OnChange(PageControl);
end;

procedure TfrmMain.UpdateInvoiceViewer;

  procedure UpdateIconViewer(const ASVGText: string);
  begin
    SVGIconImage.SVGText := ASVGText;
    SVGIconImage16.SVGText := ASVGText;
    SVGIconImage32.SVGText := ASVGText;
    SVGIconImage48.SVGText := ASVGText;
    SVGIconImage96.SVGText := ASVGText;
  end;

  procedure ShowHTMLViewerPreview(AShow: Boolean);
  begin
    CurrentEditFile.HTMLViewer.Visible := AShow;
    CurrentEditFile.ToolbarAllegati.Visible := AShow;
  end;

begin
  if FProcessingFiles then
    Exit;
  try
    if (CurrentEditor <> nil) then
    begin
      StatusBar.Panels[STATUSBAR_MESSAGE].Text := CurrentEditFile.FileName;

      if CurrentEditFile.ContentType = fcLegalInvoice then
      begin
        //Mostra l'anteprima della fattura elettronica
        CurrentEditFile.MostraFatturaXML(FEditorSettings);

        //Mostra l'anteprima dell'Icona SVG
        FThumbnailResource.StylesheetName := FThumbnailResource.SVG_DEFAULT_XSLT;
        UpdateIconViewer(FThumbnailResource.GetSVGText(CurrentEditor.Lines));
      end
      else if (CurrentEditFile = FXSLForInvoice) and Assigned(FXMLInvoice) then
      begin
        if FEditorSettings.AllowXSLToInvoice then
        begin
          //Mostra l'anteprima della fattura elettronica utilizzando
          //il foglio di stile corrente e l'ultimo file della fattura caricato
          CurrentEditFile.MostraFatturaForStyleSheet(FEditorSettings,
            FXMLInvoice.SynEditor.lines.Text, CurrentEditor.Lines.Text);
        end
        else
        begin
          ShowHTMLViewerPreview(False);
        end;
      end
      else if (CurrentEditFile = FXSLForIconFile) and Assigned(FXMLInvoice) then
      begin
        if FEditorSettings.AllowXSLToSVG then
        begin
          //Mostra l'anteprima dell'icona della fattura elettronica
          CurrentEditFile.MostraFatturaForStyleSheet(FEditorSettings,
            FXMLInvoice.SynEditor.lines.Text);
          //Assegno il template con il contenuto del file corrente
          FThumbnailResource.EditingTemplate.LoadFromXML(CurrentEditFile.SynEditor.lines.Text);
          FThumbnailResource.StylesheetName := FThumbnailResource.SVG_EDITING_XSLT;
          UpdateIconViewer(FThumbnailResource.GetSVGText(FXMLInvoice.SynEditor.Lines));
        end
        else
        begin
          ShowHTMLViewerPreview(False);
          UpdateIconViewer('');
        end;
      end
      else
      begin
        ShowHTMLViewerPreview(False);
      end;
    end
    else
    begin
      //Nasconde l'anteprina dell'immagine SVG
      UpdateIconViewer('');
    end;
    StatusImage.ImageIndex := 40;
    StatusStaticText.Caption := SVG_PARSING_OK;
    StatusStaticText.Hint := SVG_PARSING_OK;
  except
    on E: Exception do
    begin
      StatusImage.ImageIndex := 39;
      StatusStaticText.Caption := E.Message;
      StatusStaticText.Hint := E.Message;
      UpdateIconViewer('');
    end;
  end;
end;

procedure TfrmMain.BackgroundTrackBarChange(Sender: TObject);
var
  LValue: byte;
begin
  LValue := BackgroundTrackBar.Position;
  BackgroundGrayScaleLabel.Caption := Format(
    Background_Grayscale_Caption,
    [LValue * 100 div 255]);
  ImagePanel.Color := RGB(LValue, LValue, LValue);
  FEditorSettings.LightBackground := BackgroundTrackBar.Position;
end;

procedure TfrmMain.PageControlChange(Sender: TObject);
begin
  CloseSplitViewMenu;
  //Imposto la caption dell'Editor
  if CurrentEditFile <> nil then
  begin
    Caption := Application.Title+' - '+CurrentEditFile.FileName;
    if (CurrentEditFile.ContentType = fcLegalInvoice) then
      FXMLInvoice := CurrentEditFile;
  end;
  UpdateInvoiceViewer;
end;

procedure TfrmMain.acSaveUpdate(Sender: TObject);
begin
  acSave.Enabled := (CurrentEditor <> nil) and (CurrentEditor.Modified);
end;

procedure TfrmMain.CloseSplitViewMenu;
begin
  SV.Close;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;
  FDropTarget := TDropTarget.Create(WindowHandle, Self);
end;

function TfrmMain.CurrentEditFile: TEditingFile;
begin
  if (PageControl.ActivePage <> nil) then
    Result := TEditingFile(PageControl.ActivePage.Tag)
  else
    Result := nil;
end;

function TfrmMain.CurrentEditor: TSynEdit;
begin
  if CurrentEditFile <> nil then
    Result := CurrentEditFile.SynEditor else
    Result := nil;
end;

procedure TfrmMain.RemoveEditingFile(EditingFile: TEditingFile);
var
  i : integer;
  pos : integer;
begin
  pos := -1;
  for i := 0 to EditFileList.Count -1 do
  begin
    if EditFileList.Items[i] = EditingFile then
    begin
      pos := i;
      break;
    end;
  end;
  if pos = -1 then
    raise EComponentError.Create(CLOSING_PROBLEMS);

  //Richiesta di abbandono delle modifiche pendenti
  if EditingFile.SynEditor.Modified then
  begin
    if MessageDlg(Format(CONFIRM_ABANDON,[EditingFile.FileName]),
      mtWarning, [mbYes, mbNo], 0) = mrNo then
      Abort;
  end;

  //Rimuovo il riferimento
  if FXMLInvoice = EditingFile then
    FXMLInvoice := nil
  else if FXSLForInvoice = EditingFile then
    FXSLForInvoice := nil
  else if FXSLForIconFile = EditingFile then
    FXSLForIconFile := nil;

  //Elimino il file dalla lista
  EditFileList.Delete(pos);

  //Elimino la pagina
  PageControl.Pages[pos].Free;

  //Attivo la pagina nuova che ha preso il posto della precedente
  if pos > 0 then
    PageControl.ActivePageIndex := pos-1;

  //Forzo "change" della pagina
  PageControl.OnChange(PageControl);
end;

procedure TfrmMain.acCloseAllUpdate(Sender: TObject);
begin
  acCloseAll.Enabled := EditFileList.Count > 0;
end;

procedure TfrmMain.acCloseAllExecute(Sender: TObject);
begin
  FProcessingFiles := True;
  try
    while EditFileList.Count > 0 do
      RemoveEditingFile(TEditingFile(EditFileList.items[0]));
  finally
    FProcessingFiles := False;
  end;
end;

procedure TfrmMain.acSaveAllUpdate(Sender: TObject);
begin
  acSaveAll.Enabled := ModifiedCount > 0;
end;

function TfrmMain.ModifiedCount: integer;
var
  i : integer;
begin
  Result := 0;
  for i := 0 to EditFileList.Count -1 do
  begin
    if TEditingFile(EditFileList.items[i]).SynEditor.Modified then
    begin
      Inc(Result);
    end;
  end;
end;

procedure TfrmMain.acSaveAllExecute(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to EditFileList.Count -1 do
  with TEditingFile(EditFileList.items[i]) do
  begin
    if SynEditor.Modified then
    begin
      SaveToFile;
    end;
  end;
end;

procedure TfrmMain.acAboutExecute(Sender: TObject);
begin
  ShowAboutForm(DialogPosRect, Title_FEViewer);
end;

procedure TfrmMain.acSearchAgainExecute(Sender: TObject);
begin
  gbSearchFromCaret := True;
  DoSearchReplaceText(False, gbSearchBackwards);
end;

procedure TfrmMain.acSearchAgainUpdate(Sender: TObject);
begin
  acSearchAgain.Enabled := gsSearchText <> '';
end;

procedure TfrmMain.InitSynEditPrint;
var
  AFont: TFont;
begin
  AFont := TFont.Create;
  Try
    with SynEditPrint.Header do begin
        {First line, default font, left aligned}
      Add(PAGE_HEADER_FIRST_LINE_LEFT, nil, taLeftJustify, 1);
        {First line, default font, right aligned}
      Add(PAGE_HEADER_FIRST_LINE_RIGHT, nil, taRightJustify, 1);
      AFont.Assign(DefaultFont);
      AFont.Size := 6;
    end;
    with SynEditPrint.Footer do begin
      AFont.Assign(DefaultFont);
      Add(PAGE_FOOTER_FIRST_LINE_LEFT, nil, taRightJustify, 1);
      AFont.Size := 6;
      Add(PAGE_FOOTER_FIRST_LINE_RIGHT, AFont, taLeftJustify, 1);
    end;
  Finally
    AFont.Free;
  End;
end;

procedure TfrmMain.actnPrinterSetupExecute(Sender: TObject);
begin
  PrinterSetupDialog.Execute;
end;

procedure TfrmMain.actnPrintPreviewExecute(Sender: TObject);
var
  PreviewForm: TBegaHtmlPrintPreviewForm;
begin
  PreviewForm := TBegaHtmlPrintPreviewForm.Create(nil);
  try
    PreviewForm.HtmlViewer := CurrentEditFile.HTMLViewer;
    PreviewForm.ShowModal;
  finally
    PreviewForm.free;
  end;
end;

procedure TfrmMain.actnPrintExecute(Sender: TObject);
begin
  SetSynEditPrintProperties(SynEditPrint);
  if PrintDialog.Execute then
  begin
    SynEditPrint.Print;
  end;
end;

procedure TfrmMain.actnPageSetupExecute(Sender: TObject);
begin
  SetSynEditPrintProperties(PageSetupDlg.SynEditPrint);
  PageSetupDlg.SetValues(SynEditPrint);
  if PageSetupDlg.ShowModal = mrOk then
    PageSetupDlg.GetValues(SynEditPrint);
end;

procedure TfrmMain.SetXMLFontSize(const Value: Integer);
var
  LScaleFactor: Single;
begin
  if (CurrentEditor <> nil) and (Value >= MinfontSize) and (Value <= MaxfontSize) then
  begin
    if FXMLFontSize <> 0 then
      LScaleFactor := CurrentEditor.Font.Size / FXMLFontSize
    else
      LScaleFactor := 1;
    CurrentEditor.Font.Size := Round(Value * LScaleFactor);
    FEditorSettings.XMLFontSize := Value;
  end;
  FXMLFontSize := Value;
end;

procedure TfrmMain.FileSavedAskToOpen(const AFileName: string);
begin
  if MessageDlg(Format(FILE_SAVED,[AFileName]),
    TMsgDlgType.mtInformation, [mbYes, MbNo], 0) = mrYes then
  begin
    ShellExecute(handle, 'open', PChar(AFilename), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TfrmMain.acSaveHTMLFileExecute(Sender: TObject);
var
  LStream: TStringStream;
begin
  SaveDialog.FileName := ChangeFileExt(CurrentEditFile.FileName, '.htm');
  SaveDialog.Filter := 'Fattura Elettronica in HTML (*.htm)|*.htm';
  if SaveDialog.Execute then
  begin
    LStream := TStringStream.Create(CurrentEditFile.HTMLViewer.Text,
      TEncoding.UTF8);
    try
      LStream.SaveToFile(SaveDialog.FileName);
      FileSavedAskToOpen(SaveDialog.FileName);
    finally
      LStream.Free;
    end;
  end;
end;

procedure TfrmMain.acSavePDFFileExecute(Sender: TObject);
begin
  SaveDialog.FileName := ChangeFileExt(CurrentEditFile.FileName, '.pdf');
  SaveDialog.Filter := 'Fattura Elettronica in PDF (*.pdf)|*.pdf';
  if SaveDialog.Execute then
  begin
    Screen.Cursor := crHourGlass;
    try
      HTMLToPDF(SaveDialog.FileName);
      FileSavedAskToOpen(SaveDialog.FileName);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmMain.SetHTMLFontSize(const Value: Integer);
var
  LScaleFactor: Single;
begin
  if (CurrentEditor <> nil) and (Value >= MinfontSize) and (Value <= MaxfontSize) then
  begin
    if FHTMLFontSize <> 0 then
      LScaleFactor := CurrentEditFile.HTMLViewer.DefFontSize / FXMLFontSize
    else
      LScaleFactor := 1;
    CurrentEditFile.HTMLViewer.DefFontSize := Round(Value * LScaleFactor);
    FEditorSettings.HTMLFontSize := Value;
  end;
  FHTMLFontSize := Value;
end;

procedure TfrmMain.SetSynEditPrintProperties(SynEditPrint : TSynEditPrint);
begin
  SynEditPrint.SynEdit := CurrentEditor;
  SynEditPrint.Title := CurrentEditFile.FFileName;
  SynEditPrint.Highlighter := dmResources.SynXMLSyn;
end;

procedure TfrmMain.actnEditOptionsExecute(Sender: TObject);
var
  LEditOptionsDialog: TSynEditOptionsDialog;
begin
  if CurrentEditor <> nil then
    FEditorOptions.Assign(CurrentEditor);
  LEditOptionsDialog := TSynEditOptionsDialog.Create(nil);
  try
    if LEditOptionsDialog.Execute(FEditorOptions) then
    begin
      UpdateEditorsOptions;
    end;
  finally
    LEditOptionsDialog.Free;
  end;
end;

procedure TfrmMain.UpdateEditorsOptions;
var
  i : integer;
  EditingFile : TEditingFile;
begin
  FEditorSettings.XMLFontName := FEditorOptions.Font.Name;
  XMLFontSize := FEditorOptions.Font.Size;

  for i := 0 to EditFileList.Count -1 do
  begin
    EditingFile := TEditingFile(EditFileList.items[i]);
    FEditorOptions.AssignTo(EditingFile.SynEditor);
    EditingFile.HTMLViewer.DefFontName := FEditorSettings.HTMLFontName;
    EditingFile.HTMLViewer.DefFontSize := FEditorSettings.HTMLFontSize;
  end;
  Statusbar.Panels[STATUSBAR_PANEL_FONTNAME].Text := FEditorOptions.Font.Name;
  Statusbar.Panels[STATUSBAR_PANEL_FONTSIZE].Text := IntToStr(FEditorOptions.Font.Size);
end;

procedure TfrmMain.UpdateFromSettings(AEditor: TSynEdit);
begin
  if AEditor <> nil then
  begin
    FEditorSettings.ReadSettings(AEditor.Highlighter, self.FEditorOptions);
    AEditor.ReadOnly := not FEditorSettings.AllowEdit;
  end
  else
    FEditorSettings.ReadSettings(nil, self.FEditorOptions);
  if FEditorSettings.XMLFontSize >= MinfontSize then
    XMLFontSize := FEditorSettings.XMLFontSize
  else
    XMLFontSize := MinfontSize;
  if FEditorSettings.HTMLFontSize >= MinfontSize then
    HTMLFontSize := FEditorSettings.HTMLFontSize
  else
    HTMLFontSize := MinfontSize;
  InitEditorOptions;
  UpdateEditorsOptions;
  UpdateApplicationStyle(FEditorSettings.StyleName);
  UpdateHighlighter(AEditor);
  BackgroundTrackBar.Position := FEditorSettings.LightBackground;
  SVGIconImage.UpdateSVGFactory;
  SVGIconImage16.UpdateSVGFactory;
  SVGIconImage32.UpdateSVGFactory;
  SVGIconImage48.UpdateSVGFactory;
  SVGIconImage96.UpdateSVGFactory;
end;

procedure TfrmMain.UpdateHighlighter(ASynEditor: TSynEdit);
var
  LBackgroundColor: TColor;
begin
  if ASynEditor = nil then
    Exit;
  LBackgroundColor := StyleServices.GetSystemColor(clWindow);
  ASynEditor.Highlighter := dmResources.GetSynHighlighter(
    FEditorSettings.UseDarkStyle, LBackgroundColor);
  //Assegna i colori "custom" all'Highlighter
  FEditorSettings.ReadSettings(ASynEditor.Highlighter, self.FEditorOptions);
end;

procedure TfrmMain.UpdateHighlighters;
var
  LEditingFile: TEditingFile;
  I: Integer;
begin
  for i := 0 to EditFileList.Count -1 do
  begin
    LEditingFile := EditFileList.Items[i] as TEditingFile;
    UpdateHighlighter(LEditingFile.SynEditor);
  end;
end;

procedure TfrmMain.actnEditingUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := CurrentEditFile <> nil;
end;

procedure TfrmMain.actnFontExecute(Sender: TObject);
begin
  if Sender = actnEnlargeFont then
    XMLFontSize := FEditorOptions.Font.Size+1
  else if Sender = actnReduceFont then
    XMLFontSize := FEditorOptions.Font.Size-1
  else
    Exit;
  FEditorOptions.Font.Size := XMLFontSize;
  UpdateEditorsOptions;
end;

procedure TfrmMain.InitEditorOptions;
begin
  with FEditorOptions do
  begin
    Font.Name := FEditorSettings.XMLFontName;
    Font.Size := XMLFontSize;
    TabWidth := 2;
    WantTabs := False;
    Options := Options - [eoSmartTabs];
    Gutter.Font.Name := Font.Name;
    Gutter.Font.Size := Font.Size;
  end;
end;

procedure TfrmMain.actnSaveAsExecute(Sender: TObject);
begin
  SaveDialog.FileName := ChangeFileExt(CurrentEditFile.FileName, '.xml');
  SaveDialog.Filter := 'File Fattura Elettronica (*.xml;*.p7m)|*.xml;*.p7m|Fogli di Stile (*.xsl)|*.xsl';

  SaveDialog.FileName := CurrentEditFile.FileName;
  if SaveDialog.Execute then
  begin
    if CurrentEditFile.FileName <> SaveDialog.FileName then
    begin
      CurrentEditFile.FileName := SaveDialog.FileName;
    end;
    CurrentEditFile.SaveToFile;

    //Forzo "change" della pagina
    PageControl.OnChange(PageControl);
  end;
end;

procedure TfrmMain.acZoomExecute(Sender: TObject);
var
  LValue: Integer;
begin
  if Sender = acZoomIn then
    LValue := 1
  else
    LValue := -1;
  FEditorSettings.HTMLFontSize := FEditorSettings.HTMLFontSize + LValue;
  CurrentEditFile.MostraFatturaXML(FEditorSettings);
end;

procedure TfrmMain.RecentPopupMenuPopup(Sender: TObject);
var
  I: Integer;
  LMenuItem: TMenuItem;
  LFileName: string;
begin
  RecentPopupMenu.Items.Clear;
  for I := 0 to FEditorSettings.HistoryFileList.Count -1 do
  begin
    LFileName := FEditorSettings.HistoryFileList.Strings[I];
    LMenuItem := TMenuItem.Create(nil);
    if Length(LFileName) > 100 then
      LMenuItem.Caption := Copy(LFileName,1,20)+'...'+RightStr(LFileName, 80)
    else
      LMenuItem.Caption := LFileName;
    LMenuItem.Hint := LFileName;
    LMenuItem.OnClick := HistoryListClick;
    RecentPopupMenu.Items.Add(LMenuItem);
  end;
end;

function TfrmMain.CurrentEditorState: string;
begin
  if CurrentEditor = nil then
    Result := ''
  else if CurrentEditor.ReadOnly then
    Result := STATE_READONLY
  else if CurrentEditor.InsertMode then
    Result := STATE_INSERT
  else
    Result := STATE_OVERWRITE;
end;

procedure TfrmMain.UpdateStatusBarPanels;
var
  ptCaret: TBufferCoord;
begin
  if CurrentEditor <> nil then
  begin
    ptCaret := CurrentEditor.CaretXY;
    StatusBar.Panels[STATUSBAR_PANEL_CARET].Text := Format(' %6d:%3d ', [ptCaret.Line, ptCaret.Char]);
    if CurrentEditor.Modified then
      StatusBar.Panels[STATUSBAR_PANEL_MODIFIED].Text := SMODIFIED
    else
      StatusBar.Panels[STATUSBAR_PANEL_MODIFIED].Text := SUNMODIFIED;
    StatusBar.Panels[STATUSBAR_PANEL_STATE].Text := CurrentEditorState;
  end
  else
  begin
    StatusBar.Panels[STATUSBAR_PANEL_CARET].Text := '';
    StatusBar.Panels[STATUSBAR_PANEL_MODIFIED].Text := '';
    StatusBar.Panels[STATUSBAR_PANEL_STATE].Text := '';
  end;
end;

procedure TfrmMain.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
var
  LMinMaxInfo: PMinMaxInfo;
begin
  if not (csReading in ComponentState) then
  begin
    LMinMaxInfo := Message.MinMaxInfo;
    with LMinMaxInfo^ do
    begin
      with ptMinTrackSize do
      begin
        if MinFormWidth > 0 then X := MinFormWidth;
        if MinFormHeight > 0 then Y := MinFormHeight;
      end;
      with ptMaxTrackSize do
      begin
        if MaxFormWidth > 0 then X := MaxFormWidth;
        if MaxFormHeight > 0 then Y := MaxFormHeight;
      end;
      ConstrainedResize(ptMinTrackSize.X, ptMinTrackSize.Y, ptMaxTrackSize.X,
        ptMaxTrackSize.Y);
    end;
  end;
  inherited;
end;

procedure TfrmMain.ActionListExecute(Action: TBasicAction;
  var Handled: Boolean);
begin
  if (Action <> actMenu) and (Action <> OpenRecentAction) then
    CloseSplitViewMenu;
  Handled := False;
end;

procedure TfrmMain.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  UpdateStatusBarPanels;
end;

procedure TfrmMain.actMenuExecute(Sender: TObject);
begin
  if SV.Opened then
    CloseSplitViewMenu
  else
    SV.Open;
end;

procedure TfrmMain.actnColorSettingsExecute(Sender: TObject);
begin
  if ShowSettings(DialogPosRect,
    Title_FEViewer,
    CurrentEditor, FEditorSettings, True) then
  begin
    if CurrentEditor <> nil then
      FEditorSettings.WriteSettings(CurrentEditor.Highlighter, FEditorOptions)
    else
      FEditorSettings.WriteSettings(nil, FEditorOptions);
    UpdateFromSettings(CurrentEditor);
    UpdateInvoiceViewer;
    UpdateHighlighters;
  end;
end;

procedure TfrmMain.actnColorSettingsUpdate(Sender: TObject);
begin
  actnColorSettings.Enabled := True;
end;

procedure TfrmMain.actnFormatXMLExecute(Sender: TObject);
var
  OldText, NewText : string;
begin
  //formatta XML
  OldText := CurrentEditor.Text;
  NewText := Xml.XMLDoc.FormatXMLData(OldText);
  if OldText <> NewText then
  begin
    CurrentEditor.Lines.Text := NewText;
    CurrentEditor.Modified := True;
    SynEditChange(CurrentEditor);
  end;
end;

procedure TfrmMain.actionForFileUpdate(Sender: TObject);
begin
  (Sender As TAction).Enabled := (CurrentEditor <> nil)
    and not CurrentEditor.ReadOnly;
end;

procedure TfrmMain.AddOpenedFile(const AFileName: string);
var
  i : integer;
begin
  //se esiste già la voce la cancello
  i := FEditorSettings.HistoryFileList.IndexOf(AFileName);
  if i >= 0 then
    FEditorSettings.HistoryFileList.Delete(i);
  //massimo 15 voci
  if FEditorSettings.HistoryFileList.Count > 15 then
    FEditorSettings.HistoryFileList.Delete(14);
  //Aggiungo la voce in prima posizione
  FEditorSettings.HistoryFileList.Insert(0, AFileName);
end;

procedure TfrmMain.AdjustCompactWidth;
begin
  //Change size of compact because Scrollbars appears
  if (Height / ScaleFactor) > 900 then
    SV.CompactWidth := Round(44 * ScaleFactor)
  else
    SV.CompactWidth := Round(66 * ScaleFactor);
end;

procedure TfrmMain.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
  NewDPI: Integer);
begin
  LockWindowUpdate(0);
end;

procedure TfrmMain.FormBeforeMonitorDpiChanged(Sender: TObject; OldDPI,
  NewDPI: Integer);
begin
  LockWindowUpdate(Handle);
end;

procedure TfrmMain.catMenuItemsGetHint(Sender: TObject;
  const Button: TButtonItem; const Category: TButtonCategory;
  var HintStr: string; var Handled: Boolean);
var
  LActionDisabled: Boolean;
begin
  inherited;
  if not Assigned(Button) then
    Exit;
  if Button.Action is TAction then
    LActionDisabled := not TAction(Button.Action).Enabled
  else if Button.Action is TFileAction then
    LActionDisabled := not TFileAction(Button.Action).Enabled
  else
    LActionDisabled := False;
  if LActionDisabled then
  begin
    HintStr := '';
    Handled := True;
  end;
end;

procedure TfrmMain.catMenuItemsMouseLeave(Sender: TObject);
begin
  inherited;
  Screen.cursor := crDefault;
end;

procedure TfrmMain.catMenuItemsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  LButton: TButtonItem;
begin
  inherited;

  LButton := catMenuItems.GetButtonAt(X,Y)  ;
  if Assigned(LButton) and Assigned(LButton.Action) then
  begin
    if (LButton.Action is TAction) then
    begin
      TAction(LButton.Action).Update;
      if TAction(LButton.Action).Enabled then
        Screen.Cursor := crHandPoint
      else
        Screen.Cursor := crNo;
    end
    else if LButton.Action is TFileAction then
    begin
      TFileAction(LButton.Action).Update;
      if TFileAction(LButton.Action).Enabled then
        Screen.Cursor := crHandPoint
      else
        Screen.Cursor := crNo;
    end;
  end
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmMain.HistoryListClick(Sender: TObject);
var
  LFileName : string;
begin
  LFilename := (Sender as TMenuItem).Hint;
  //Carico il file selezionato
  OpenFile(LFileName);
  UpdateInvoiceViewer;
  if (CurrentEditor <> nil) and (CurrentEditor.CanFocus) then
    (CurrentEditor.SetFocus);
  CloseSplitViewMenu;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  BackgroundTrackBarChange(nil);
end;

procedure TfrmMain.HTMLToPDF(const APDFFileName: TFileName);
var
  lHtmlToPdf: TvmHtmlToPdfGDI;
  LOldColor: TColor;
begin
  lHtmlToPdf := TvmHtmlToPdfGDI.Create();
  try
    lHtmlToPdf.PDFMarginLeft := FEditorSettings.PDFPageSettings.MarginLeft;
    lHtmlToPdf.PDFMarginTop := FEditorSettings.PDFPageSettings.MarginTop;
    lHtmlToPdf.PDFMarginRight := FEditorSettings.PDFPageSettings.MarginRight;
    lHtmlToPdf.PDFMarginBottom := FEditorSettings.PDFPageSettings.MarginBottom;
    lHtmlToPdf.PDFScaleToFit := True;
    lHtmlToPdf.PrintOrientation := FEditorSettings.PDFPageSettings.PrintOrientation;
    lHtmlToPdf.DefaultPaperSize := TPDFPaperSize(FEditorSettings.PDFPageSettings.PaperSize);

    //Cambio il background dell'HTML Viewer per creare un PDF con sfondo bianco
    //anche quando sto usando un tema scuro
    LOldColor := CurrentEditFile.HTMLViewer.DefBackground;
    try
      SendMessage(CurrentEditFile.HTMLViewer.Handle, WM_SETREDRAW, WPARAM(False), 0);
      CurrentEditFile.HTMLViewer.DefBackground := clWhite;
      lHtmlToPdf.SrcViewer := CurrentEditFile.HTMLViewer;

      lHtmlToPdf.PrintPageNumber := False;
      lHtmlToPdf.TextPageNumber := 'Page %d/%d';
      lHtmlToPdf.PageNumberPositionPrint := ppBottom;

      lHtmlToPdf.Execute;
      lHtmlToPdf.SaveToFile(APDFFileName);
    finally
      CurrentEditFile.HTMLViewer.DefBackground := LOldColor;
    end;
  finally
    SendMessage(CurrentEditFile.HTMLViewer.Handle, WM_SETREDRAW, WPARAM(True), 0);
    lHtmlToPdf.Free;
  end;
end;

initialization
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

end.

