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
{                                                                              }
{  The Initial Developer of the Original Code is Rodrigo Ruz V.                }
{  Portions created by Rodrigo Ruz V. are Copyright 2011-2021 Rodrigo Ruz V.   }
{  All Rights Reserved.                                                        }
{******************************************************************************}

unit FExplorer.PreviewForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SynEdit,
  System.Generics.Collections,
  SynEditHighlighter,
  ComCtrls, ToolWin, ImgList, SynHighlighterXML,
  Vcl.Menus, SynEditExport,
  SynExportHTML, SynExportRTF, SynEditMiscClasses,
  FExplorer.Settings, System.ImageList, SynEditCodeFolding,
  SVGIconImageList, SVGIconImageListBase, SVGIconImage, Vcl.VirtualImageList,
  Vcl.OleCtrls, SHDocVw, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc;

type
  TAllegato = record
    FileName: string;
    FileType: string;
    Compressione: string;
    Data: string;
    Button: TButton;
    procedure DumpAndOpen;
    procedure Clear;
  end;
  TFrmPreview = class(TForm)
    SynEdit: TSynEdit;
    PanelTop: TPanel;
    PanelEditor: TPanel;
    StatusBar: TStatusBar;
    SVGIconImageList: TVirtualImageList;
    ToolButtonZoomIn: TToolButton;
    ToolButtonZommOut: TToolButton;
    ToolBar: TToolBar;
    ToolButtonSettings: TToolButton;
    ToolButtonAbout: TToolButton;
    SeparatorEditor: TToolButton;
    ToolButtonShowText: TToolButton;
    ToolButtonReformat: TToolButton;
    Splitter: TSplitter;
    WebBrowser: TWebBrowser;
    gbAllegati: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure ToolButtonZoomInClick(Sender: TObject);
    procedure ToolButtonZommOutClick(Sender: TObject);
    procedure ToolButtonSettingsClick(Sender: TObject);
    procedure ToolButtonAboutClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButtonSelectModeClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ToolButtonShowTextClick(Sender: TObject);
    procedure ToolButtonReformatClick(Sender: TObject);
    procedure ToolButtonMouseEnter(Sender: TObject);
    procedure ToolButtonMouseLeave(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
      NewDPI: Integer);
    procedure WebBrowserDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure FormShow(Sender: TObject);
  private
    FEditorFontSize: Integer;
    FSimpleText: string;
    FFileName: string;
    FPreviewSettings: TPreviewSettings;
    FAllegati: TArray<TAllegato>;

    class var FExtensions: TDictionary<TSynCustomHighlighterClass, TStrings>;
    class var FAParent: TWinControl;

    function DialogPosRect: TRect;
    procedure AppException(Sender: TObject; E: Exception);
    procedure UpdateGUI;
    procedure UpdateFromSettings;
    procedure SaveSettings;
    procedure SetEditorFontSize(const Value: Integer);
    procedure UpdateHighlighter;

    //Visualizzatore Fattura
    function SetOpticalZoom(Value: integer): integer;
    procedure MostraFatturaXML;
    procedure ParseAllegati(const AXMLDoc: IXMLDocument);
    procedure AllegatoButtonClick(Sender: TObject);
  protected
  public
    procedure ScaleControls(const ANewPPI: Integer);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class property Extensions: TDictionary<TSynCustomHighlighterClass, TStrings> read FExtensions write FExtensions;
    class property AParent: TWinControl read FAParent write FAParent;
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromStream(const AStream: TStream);
    property EditorFontSize: Integer read FEditorFontSize write SetEditorFontSize;
  end;


implementation

uses
  SynEditTypes
  , Vcl.Clipbrd
{$IFNDEF DISABLE_STYLES}
  , Vcl.Themes
{$ENDIF}
  , WinApi.ActiveX
  , uLogExcept
  , System.Types
  , System.NetEncoding
  , Registry
  , uMisc
  , IOUtils
  , ShellAPI
  , ComObj
  , IniFiles
  , GraphUtil
  , FExplorer.About
  , FExplorer.SettingsForm
  , FExplorer.Resources
  ;

{$R *.dfm}
  { TFrmEditor }

procedure TFrmPreview.AllegatoButtonClick(Sender: TObject);
var
  LButton: TButton;
  LAllegato: TAllegato;
begin
  LButton := Sender as TButton;
  LAllegato := FAllegati[LButton.Tag];
  LAllegato.DumpAndOpen;
end;

procedure TFrmPreview.AppException(Sender: TObject; E: Exception);
begin
  // log unhandled exceptions (TSynEdit, etc)
  TLogPreview.Add('AppException');
  TLogPreview.Add(E);
end;

procedure TFrmPreview.MostraFatturaXML;
var
  LXML: IXMLDocument;
  LOutput: WideString;
  LStream: TStringStream;
  Stream : IStream;
  LPersistStreamInit : IPersistStreamInit;
begin
  try
    //Inizializza il Documento XML dal testo caricato dentro synedit
    LXML := LoadXMLData(SynEdit.Lines.Text);
    //Usa il template disponibile nel datamodule
    dmResources.AssoSoftwareTemplate.Active := True;
    LXML.Node.TransformNode(dmResources.AssoSoftwareTemplate.DocumentElement, LOutput);
    //Carica il contenuto HTML trasformato dentro il WebBrowser
    LStream := TStringStream.Create(LOutput);
    try
      (WebBrowser.Document as IPersistStreamInit).Load(
        TStreamAdapter.Create(LStream, soReference));
    finally
      LStream.Free;
    end;
    ParseAllegati(LXML);
  except
    on E: Exception do
    begin
      Raise
    end;
  end;
end;

procedure TFrmPreview.ParseAllegati(const AXMLDoc: IXMLDocument);
var
  LAllegati: IDOMNodeList;
  LAllegato: TAllegato;
  LButton: TButton;
  LAllegatoNode: IDOMNode;
  LAllegatoElement: IDOMElement;
  LList: IDOMNodeList;
  LIndex: Integer;
  LNomeAttachment: string;
  LFormatoAttachment: string;
  LAlgoritmoCompressione: string;
  LData: string;
begin
  LAllegati := AXMLDoc.DOMDocument.getElementsByTagName('Allegati');
  for LAllegato in  FAllegati do
    LAllegato.Button.Free;
  FAllegati := [];
  for LIndex := 0 to LAllegati.length - 1 do
  begin
    LAllegato.Clear;
    LAllegatoNode := LAllegati.item[LIndex];
    LAllegatoElement := LAllegatoNode as IDOMElement;
    if Assigned(LAllegatoElement) then
    begin
      LList := LAllegatoElement.getElementsByTagName('NomeAttachment');
      LNomeAttachment := '';
      if (LList.length = 1) and (LList.item[0].hasChildNodes) then
        LNomeAttachment := LList.item[0].firstChild.nodeValue;
      LList := LAllegatoElement.getElementsByTagName('FormatoAttachment');
      LFormatoAttachment := '';
      if (LList.length = 1) and (LList.item[0].hasChildNodes) then
        LFormatoAttachment := LList.item[0].firstChild.nodeValue;
      LList := LAllegatoElement.getElementsByTagName('AlgoritmoCompressione');
      LAlgoritmoCompressione := '';
      if (LList.length = 1) and (LList.item[0].hasChildNodes) then
        LAlgoritmoCompressione := LList.item[0].firstChild.nodeValue;
      LList := LAllegatoElement.getElementsByTagName('Attachment');
      LData := '';
      if (LList.length = 1) and (LList.item[0].hasChildNodes) then
        LData := LList.item[0].firstChild.nodeValue;

      LAllegato.FileName := LNomeAttachment;
      LAllegato.FileType := LFormatoAttachment;
      LAllegato.Compressione := LAlgoritmoCompressione;
      LAllegato.Data := LData;
      LButton := TButton.Create(Self);
      try
        LButton.Caption := LNomeAttachment;
        gbAllegati.InsertControl(LButton);
        LButton.Align := TAlign.alTop;
        FAllegati := FAllegati + [LAllegato];
        LButton.Tag := Length(FAllegati) -1;
        LButton.OnClick := AllegatoButtonClick;
      except
        LButton.Free;
        raise;
      end;
    end;
  end;
  gbAllegati.Visible := Length(FAllegati) > 0;
end;

constructor TFrmPreview.Create(AOwner: TComponent);
begin
  inherited;
  FPreviewSettings := TPreviewSettings.CreateSettings(SynEdit.Highlighter);
  dmResources := TdmResources.Create(nil);
end;

destructor TFrmPreview.Destroy;
begin
  FreeAndNil(FPreviewSettings);
  FreeAndNil(dmResources);
  inherited;
end;

function TFrmPreview.DialogPosRect: TRect;
begin
  if Self.Parent <> nil then
    GetWindowRect(Self.Parent.ParentWindow, Result)
  else
    Result := TRect.Create(0,0,0,0);
end;

procedure TFrmPreview.UpdateGUI;
begin
  if PanelEditor.Visible then
  begin
    Splitter.Top := PanelEditor.Top + PanelEditor.Height;
    Splitter.Visible := True;
    ToolButtonShowText.Caption := 'Hide Text';
    ToolButtonShowText.Hint := 'Hide content of SVG file';
    ToolButtonShowText.ImageName := 'hide-text';
  end
  else
  begin
    Splitter.Visible := False;
    ToolButtonShowText.Caption := 'Show Text';
    ToolButtonShowText.Hint := 'Show content of SVG file';
    ToolButtonShowText.ImageName := 'show-text';
  end;
  ToolButtonShowText.Visible := True;
  ToolButtonAbout.Visible := True;
  ToolButtonSettings.Visible := True;
  ToolButtonReformat.Visible := PanelEditor.Visible;
end;

procedure TFrmPreview.UpdateHighlighter;
var
  LBackgroundColor: TColor;
begin
{$IFNDEF DISABLE_STYLES}
  LBackgroundColor := StyleServices.GetSystemColor(clWindow);
{$ELSE}
  LBackgroundColor := clWindow;
{$ENDIF}
  SynEdit.Highlighter := dmResources.GetSynHighlighter(
    FPreviewSettings.UseDarkStyle, LBackgroundColor);
  //Assegna i colori "custom" all'Highlighter
  FPreviewSettings.ReadSettings(SynEdit.Highlighter, nil);
  SynEdit.Gutter.Font.Name := SynEdit.Font.Name;
{$IFNDEF DISABLE_STYLES}
  SynEdit.Gutter.Font.Color := StyleServices.GetSystemColor(clWindowText);
  SynEdit.Gutter.Color := StyleServices.GetSystemColor(clBtnFace);
{$ELSE}
  SynEdit.Gutter.Font.Color := clWindowText;
  SynEdit.Gutter.Color := clBtnFace;
{$ENDIF}
end;

procedure TFrmPreview.WebBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  FPreviewSettings.OpticalZoom := SetOpticalZoom(FPreviewSettings.OpticalZoom);
end;

procedure TFrmPreview.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
  NewDPI: Integer);
begin
  TLogPreview.Add('TFrmEditor.FormAfterMonitorDpiChanged: '+
  '- Old: '+OldDPI.ToString+' - New: '+NewDPI.ToString);
end;

procedure TFrmPreview.FormCreate(Sender: TObject);
begin
  TLogPreview.Add('TFrmEditor.FormCreate');
  FAllegati := [];
  Application.OnException := AppException;
  FSimpleText := StatusBar.SimpleText;
  UpdateFromSettings;
end;

procedure TFrmPreview.FormDestroy(Sender: TObject);
begin
  HideAboutForm;
  SaveSettings;
  TLogPreview.Add('TFrmEditor.FormDestroy');
  inherited;
end;

procedure TFrmPreview.FormResize(Sender: TObject);
begin
  PanelEditor.Height := Round(Self.Height * (FPreviewSettings.SplitterPos / 100));
  Splitter.Top := PanelEditor.Height;
  if Self.Width < (550 * Self.ScaleFactor) then
    ToolBar.ShowCaptions := False
  else
    Toolbar.ShowCaptions := True;
  UpdateGUI;
end;

procedure TFrmPreview.FormShow(Sender: TObject);
begin
  //Load blank doc into Browser
  WebBrowser.Navigate('about:blank', EmptyParam, EmptyParam, EmptyParam, EmptyParam);
end;

procedure TFrmPreview.LoadFromFile(const AFileName: string);
begin
  TLogPreview.Add('TFrmEditor.LoadFromFile Init');
  FFileName := AFileName;
  SynEdit.Lines.LoadFromFile(FFileName);
  MostraFatturaXML;
  TLogPreview.Add('TFrmEditor.LoadFromFile Done');
end;

procedure TFrmPreview.LoadFromStream(const AStream: TStream);
var
  LStringStream: TStringStream;
begin
  TLogPreview.Add('TFrmEditor.LoadFromStream Init');
  AStream.Position := 0;
  LStringStream := TStringStream.Create('',TEncoding.UTF8);
  try
    LStringStream.LoadFromStream(AStream);
    SynEdit.Lines.Text := LStringStream.DataString;
    MostraFatturaXML;
  finally
    LStringStream.Free;
  end;
  TLogPreview.Add('TFrmEditor.LoadFromStream Done');
end;

procedure TFrmPreview.SaveSettings;
begin
  if Assigned(FPreviewSettings) then
  begin
    FPreviewSettings.UpdateSettings(SynEdit.Font.Name,
      EditorFontSize,
      PanelEditor.Visible);
    FPreviewSettings.WriteSettings(SynEdit.Highlighter, nil);
  end;
end;

procedure TFrmPreview.ScaleControls(const ANewPPI: Integer);
var
  LCurrentPPI: Integer;
  LNewSize: Integer;
begin
  LCurrentPPI := FCurrentPPI;
  if ANewPPI <> LCurrentPPI then
  begin
    LNewSize := MulDiv(SVGIconImageList.Width, ANewPPI, LCurrentPPI);
    SVGIconImageList.SetSize(LNewSize, LNewSize);
  end;
end;

procedure TFrmPreview.SetEditorFontSize(const Value: Integer);
var
  LScaleFactor: Single;
begin
  if (Value >= MinfontSize) and (Value <= MaxfontSize) then
  begin
    TLogPreview.Add('TFrmEditor.SetEditorFontSize'+
      ' CurrentPPI: '+Self.CurrentPPI.ToString+
      ' ScaleFactor: '+ScaleFactor.ToString+
      ' Value: '+Value.ToString);
    if FEditorFontSize <> 0 then
      LScaleFactor := SynEdit.Font.Size / FEditorFontSize
    else
      LScaleFactor := 1;
    FEditorFontSize := Value;
    SynEdit.Font.Size := Round(FEditorFontSize * LScaleFactor);
    SynEdit.Gutter.Font.Size := SynEdit.Font.Size;
  end;
end;

function TFrmPreview.SetOpticalZoom(Value: integer): Integer;
var
  vaIn, vaOut : OleVariant;
begin
  vaIn := null;
  vaOut := null;
  WebBrowser.ExecWB(OLECMDID_OPTICAL_GETZOOMRANGE,OLECMDEXECOPT_DONTPROMPTUSER,vaIn,vaOut);
  if Value < LoWord(DWORD(vaOut)) then
      vaIn := LoWord(DWORD(vaOut))
    else
      if Value > HiWord(DWORD(vaOut)) then
        vaIn := HiWord(DWORD(vaOut))
      else
        vaIn := Value;
  WebBrowser.ExecWB(OLECMDID_OPTICAL_ZOOM,OLECMDEXECOPT_DONTPROMPTUSER,vaIn,vaOut);
  Result := vaIn;
end;

procedure TFrmPreview.SplitterMoved(Sender: TObject);
begin
  FPreviewSettings.SplitterPos := splitter.Top * 100 div
    (Self.Height - Toolbar.Height);
  SaveSettings;
end;

procedure TFrmPreview.ToolButtonShowTextClick(Sender: TObject);
begin
  PanelEditor.Visible := not PanelEditor.Visible;
  UpdateGUI;
  SaveSettings;
end;

procedure TFrmPreview.ToolButtonAboutClick(Sender: TObject);
begin
  ShowAboutForm(DialogPosRect, Title_SVGPreview);
end;

procedure TFrmPreview.ToolButtonMouseEnter(Sender: TObject);
begin
  StatusBar.SimpleText := (Sender as TToolButton).Hint;
end;

procedure TFrmPreview.ToolButtonMouseLeave(Sender: TObject);
begin
  StatusBar.SimpleText := FSimpleText;
end;

procedure TFrmPreview.ToolButtonReformatClick(Sender: TObject);
begin
  SynEdit.Lines.Text := Xml.XMLDoc.FormatXMLData(SynEdit.Lines.Text);
end;

procedure TFrmPreview.UpdateFromSettings;
begin
  FPreviewSettings.ReadSettings(SynEdit.Highlighter, nil);
  if FPreviewSettings.FontSize >= MinfontSize then
    EditorFontSize := FPreviewSettings.FontSize
  else
    EditorFontSize := MinfontSize;
  SynEdit.Font.Name := FPreviewSettings.FontName;
  PanelEditor.Visible := FPreviewSettings.ShowEditor;
{$IFNDEF DISABLE_STYLES}
  TStyleManager.TrySetStyle(FPreviewSettings.StyleName, False);
{$ENDIF}
  //BackgroundTrackBar.Position := FPreviewSettings.LightBackground;
  UpdateHighlighter;
  UpdateGUI;
end;

procedure TFrmPreview.ToolButtonSettingsClick(Sender: TObject);
begin
  if ShowSettings(DialogPosRect, Title_SVGPreview, SynEdit, FPreviewSettings, True) then
  begin
    FPreviewSettings.WriteSettings(SynEdit.Highlighter, nil);
    UpdateFromSettings;
  end;
end;

procedure TFrmPreview.ToolButtonSelectModeClick(Sender: TObject);
begin
  TToolButton(Sender).CheckMenuDropdown;
end;

procedure TFrmPreview.ToolButtonZommOutClick(Sender: TObject);
begin
  FPreviewSettings.OpticalZoom := SetOpticalZoom(FPreviewSettings.OpticalZoom - 10);
  SaveSettings;
end;

procedure TFrmPreview.ToolButtonZoomInClick(Sender: TObject);
begin
  FPreviewSettings.OpticalZoom := SetOpticalZoom(FPreviewSettings.OpticalZoom + 10);
  SaveSettings;
end;

{ TAllegato }

procedure TAllegato.Clear;
begin
  FileName := '';
  FileType := '';
  Compressione := '';
  Data := '';
  if Assigned(Button) then
    FreeAndNil(Button);
end;
procedure TAllegato.DumpAndOpen;
var
  LTempFileName: string;
  LBytes: TBytes;
  LBytesStream: TBytesStream;
begin
  if Compressione <> '' then
    raise Exception.Create('Compressione ' + Compressione + ' non supportata, allegato: ' + FileName);
  LTempFileName := TPath.Combine(TPath.GetTempPath, ExtractFileName(FileName));
  LBytes := TNetEncoding.Base64.DecodeStringToBytes(Data);
  LBytesStream := TBytesStream.Create(LBytes);
  try
    LBytesStream.SaveToFile(LTempFileName);
    ShellExecute(0, nil
      , PWideChar(LTempFileName)
      , nil // PWideChar(TPath.Combine(BASE_FOLDER, FatturePassiveNomeFile.AsString))
      , nil, SW_NORMAL);
  finally
    LBytesStream.Free;
  end;
end;
end.
