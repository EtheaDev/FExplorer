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
  Vcl.OleCtrls, SHDocVw, Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc,
  FExplorer.Resources, HTMLUn2, HtmlView
  ;

type
  TFrmPreview = class(TForm)
    SynEdit: TSynEdit;
    PanelTop: TPanel;
    PanelXML: TPanel;
    StatusBar: TStatusBar;
    SVGIconImageList: TVirtualImageList;
    ToolButtonZoomIn: TToolButton;
    ToolButtonZoomOut: TToolButton;
    ToolBar: TToolBar;
    ToolButtonSettings: TToolButton;
    ToolButtonAbout: TToolButton;
    SeparatorEditor: TToolButton;
    ToolButtonShowText: TToolButton;
    ToolButtonReformat: TToolButton;
    Splitter: TSplitter;
    ToolBarAllegati: TToolBar;
    HtmlViewer: THtmlViewer;
    procedure FormCreate(Sender: TObject);
    procedure ToolButtonZoomInClick(Sender: TObject);
    procedure ToolButtonZoomOutClick(Sender: TObject);
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
  private
    FXMLFontSize: Integer;
    FHTMLFontSize: Integer;
    FSimpleText: string;
    FFileName: string;
    FPreviewSettings: TPreviewSettings;
    FInvoice: TLegalInvoice;
    FAllegatiButtons: TObjectList<TToolButton>;

    class var FExtensions: TDictionary<TSynCustomHighlighterClass, TStrings>;
    class var FAParent: TWinControl;

    function DialogPosRect: TRect;
    procedure AppException(Sender: TObject; E: Exception);
    procedure UpdateGUI;
    procedure UpdateFromSettings(const Preview: Boolean);
    procedure SaveSettings;
    procedure SetXMLFontSize(const Value: Integer);
    procedure SetHTMLFontSize(const Value: Integer);
    procedure UpdateHighlighter;

    //Visualizzatore Fattura
    procedure MostraFatturaXML;
    procedure RenderAllegati;
    procedure AllegatoButtonClick(Sender: TObject);
    procedure AdjustZoom(AValue: Integer);
  protected
  public
    procedure ScaleControls(const ANewPPI: Integer);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class property Extensions: TDictionary<TSynCustomHighlighterClass, TStrings> read FExtensions write FExtensions;
    class property AParent: TWinControl read FAParent write FAParent;
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromStream(const AStream: TStream);
    property XMLFontSize: Integer read FXMLFontSize write SetXMLFontSize;
    property HTMLFontSize: Integer read FHTMLFontSize write SetHTMLFontSize;
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
  ;

{$R *.dfm}
  { TFrmEditor }

procedure TFrmPreview.AllegatoButtonClick(Sender: TObject);
var
  LButton: TToolButton;
  LAllegato: TLinkedDoc;
begin
  LButton := Sender as TToolButton;
  LAllegato := FInvoice.Allegati[LButton.Tag];
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
  LStream: TStringStream;
begin
  try
    FInvoice := TLegalInvoice.Create(SynEdit.Lines.Text, False);
    FInvoice.StylesheetName := FPreviewSettings.StylesheetName;
    FInvoice.Parse;

    //Se la trasformazione ha prodotto un "div" vuoto significa che il file
    //di orgine non è una fattura elettronica o non è riuscito a trasformarla:
    //Nascondo il viewer e nostro solo il testo XML
    if pos('<div id="fattura-container"></div>', FInvoice.HTML) > 0 then
    begin
      PanelXML.Visible := True;
      HtmlViewer.Visible := False;
      PanelXML.Align := alClient;
      UpdateGUI;
    end
    else
    begin
      PanelXML.Visible := FPreviewSettings.ShowXML;
      PanelXML.Align := alTop;
      HtmlViewer.Visible := True;

      //Carica il contenuto HTML trasformato dentro l'HTML-Viewer
      LStream := TStringStream.Create(FInvoice.HTML);
      try
        HtmlViewer.LoadFromStream(LStream);
      finally
        LStream.Free;
      end;

      RenderAllegati;

    end;

    // dump HTML to temp folder (DEBUG ONLY!)
    //TFile.WriteAllText('c:\temp\' +  ChangeFileExt(FFileName, '.html'), FInvoice.HTML, TEncoding.UTF8);

  except
    on E: Exception do
      ; //non solleva eccezioni
  end;
end;

procedure TFrmPreview.RenderAllegati;
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
      LButton.ImageIndex := 11;
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

constructor TFrmPreview.Create(AOwner: TComponent);
begin
  inherited;
  FPreviewSettings := TPreviewSettings.CreateSettings(SynEdit.Highlighter);
  dmResources := TdmResources.Create(nil);
  FAllegatiButtons := TObjectList<TToolButton>.Create(True);
end;

destructor TFrmPreview.Destroy;
begin
  FreeAndNil(FAllegatiButtons);
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
  if PanelXML.Visible then
  begin
    Splitter.Top := PanelXML.Top + PanelXML.Height;
    Splitter.Visible := True;
    ToolButtonShowText.Caption := 'Nascondi XML';
    ToolButtonShowText.Hint := 'Nascondi il contenuto XML del file';
    ToolButtonShowText.ImageName := 'hide-text';
  end
  else
  begin
    Splitter.Visible := False;
    ToolButtonShowText.Caption := 'Mostra XML';
    ToolButtonShowText.Hint := 'Mostra il contenuto XML del file';
    ToolButtonShowText.ImageName := 'show-text';
  end;
  ToolButtonShowText.Visible := True;
  ToolButtonAbout.Visible := True;
  ToolButtonSettings.Visible := True;
  ToolButtonReformat.Visible := PanelXML.Visible;
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

procedure TFrmPreview.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
  NewDPI: Integer);
begin
  TLogPreview.Add('TFrmEditor.FormAfterMonitorDpiChanged: '+
  '- Old: '+OldDPI.ToString+' - New: '+NewDPI.ToString);
end;

procedure TFrmPreview.FormCreate(Sender: TObject);
begin
  TLogPreview.Add('TFrmEditor.FormCreate');
  Application.OnException := AppException;
  FSimpleText := StatusBar.SimpleText;
  UpdateFromSettings(False);
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
  PanelXML.Height := Round(Self.Height * (FPreviewSettings.SplitterPos / 100));
  Splitter.Top := PanelXML.Height;
  if Self.Width < (550 * Self.ScaleFactor) then
    ToolBar.ShowCaptions := False
  else
    Toolbar.ShowCaptions := True;
  UpdateGUI;
end;

procedure TFrmPreview.LoadFromFile(const AFileName: string);
begin
  TLogPreview.Add('TFrmEditor.LoadFromFile Init');
  FFileName := AFileName;
  TLegalInvoiceLoader.LoadFromFile(AFileName, SynEdit);
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
    TLegalInvoiceLoader.LoadFromStream(AStream, LStringStream);
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
      HtmlViewer.DefFontName,
      XMLFontSize, HTMLFontSize,
      (PanelXML.Visible and HtmlViewer.Visible));
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

procedure TFrmPreview.SetXMLFontSize(const Value: Integer);
var
  LScaleFactor: Single;
begin
  if (Value >= MinfontSize) and (Value <= MaxfontSize) then
  begin
    TLogPreview.Add('TFrmEditor.SetXMLFontSize'+
      ' CurrentPPI: '+Self.CurrentPPI.ToString+
      ' ScaleFactor: '+ScaleFactor.ToString+
      ' Value: '+Value.ToString);
    if FXMLFontSize <> 0 then
      LScaleFactor := SynEdit.Font.Size / FXMLFontSize
    else
      LScaleFactor := 1;
    FXMLFontSize := Value;
    SynEdit.Font.Size := Round(FXMLFontSize * LScaleFactor);
    SynEdit.Gutter.Font.Size := SynEdit.Font.Size;
  end;
end;

procedure TFrmPreview.SetHTMLFontSize(const Value: Integer);
var
  LScaleFactor: Single;
begin
  if (Value >= MinfontSize) and (Value <= MaxfontSize) then
  begin
    TLogPreview.Add('TFrmEditor.SetXMLFontSize'+
      ' CurrentPPI: '+Self.CurrentPPI.ToString+
      ' ScaleFactor: '+ScaleFactor.ToString+
      ' Value: '+Value.ToString);
    if FHTMLFontSize <> 0 then
      LScaleFactor := HtmlViewer.DefFontSize / FHTMLFontSize
    else
      LScaleFactor := 1;
    FHTMLFontSize := Value;
    HtmlViewer.DefFontSize := Round(FHTMLFontSize * LScaleFactor);
  end;
end;

procedure TFrmPreview.SplitterMoved(Sender: TObject);
begin
  FPreviewSettings.SplitterPos := splitter.Top * 100 div
    (Self.Height - Toolbar.Height);
  SaveSettings;
end;

procedure TFrmPreview.ToolButtonShowTextClick(Sender: TObject);
begin
  PanelXML.Visible := not PanelXML.Visible;
  if not PanelXML.Visible and HTMLViewer.CanFocus then
    HTMLViewer.SetFocus;
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

procedure TFrmPreview.UpdateFromSettings(const Preview: Boolean);
begin
  FPreviewSettings.ReadSettings(SynEdit.Highlighter, nil);
  if FPreviewSettings.XMLFontSize >= MinfontSize then
    XMLFontSize := FPreviewSettings.XMLFontSize
  else
    XMLFontSize := MinfontSize;
  SynEdit.Font.Name := FPreviewSettings.XMLFontName;

  if FPreviewSettings.HTMLFontSize >= MinfontSize then
    HTMLFontSize := FPreviewSettings.HTMLFontSize
  else
    HTMLFontSize := 12;
  HtmlViewer.DefFontName := FPreviewSettings.HTMLFontName;

  PanelXML.Visible := FPreviewSettings.ShowXML;
{$IFNDEF DISABLE_STYLES}
  TStyleManager.TrySetStyle(FPreviewSettings.StyleName, False);
{$ENDIF}
  //BackgroundTrackBar.Position := FPreviewSettings.LightBackground;
  UpdateHighlighter;
  UpdateGUI;
  if Preview then
    MostraFatturaXML;
end;

procedure TFrmPreview.ToolButtonSettingsClick(Sender: TObject);
begin
  if ShowSettings(DialogPosRect, Title_SVGPreview, SynEdit, FPreviewSettings, True) then
  begin
    FPreviewSettings.WriteSettings(SynEdit.Highlighter, nil);
    UpdateFromSettings(True);
  end;
end;

procedure TFrmPreview.ToolButtonSelectModeClick(Sender: TObject);
begin
  TToolButton(Sender).CheckMenuDropdown;
end;

procedure TFrmPreview.ToolButtonZoomOutClick(Sender: TObject);
begin
  AdjustZoom(-1);
end;

procedure TFrmPreview.ToolButtonZoomInClick(Sender: TObject);
begin
  AdjustZoom(1);
end;

procedure TFrmPreview.AdjustZoom(AValue: Integer);
begin
  if Synedit.Focused then
    XMLFontSize := XMLFontSize + AValue
  else
  begin
    HTMLFontSize := HTMLFontSize + AValue;
    MostraFatturaXML;
  end;
  SaveSettings;
end;

end.
