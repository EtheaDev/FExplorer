{******************************************************************************}
{                                                                              }
{       FExplorer: Shell extensions per Fattura Elettronica                    }
{       (Preview Panel, Thumbnail Icon, F.E.Viewer)                            }
{                                                                              }
{       Copyright (c) 2021-2025 (Ethea S.r.l.)                                 }
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
unit FExplorer.Settings;

interface

uses
  System.SysUtils
  , System.Classes
  , VCL.Graphics
  , SynEditHighlighter
  , System.Generics.Collections
  , SynEditOptionsDialog
  , System.UITypes
  , IniFiles;

const
  MaxfontSize = 30;
  MinfontSize = 8;
  default_lightactivelinecolor = 15066597;
  default_darkactivelinecolor = 0;

resourcestring
  Background_Grayscale_Caption = 'Backlight %d%%';

type
  TThemeSelection = (tsAsWindows, tsDarkTheme, tsLightTheme);
  TThemeType = (ttLight, ttDark);
  TSVGEngine = (enImage32, enDirect2D);

  //Class to register Theme attributes (like dark or light)
  TThemeAttribute = class
    StyleName: String;
    ThemeType: TThemeType;

  //function to get Theme Attributes
  class function GetStyleAttributes(const AStyleName: string;
    out AThemeAttribute: TThemeAttribute): Boolean;
  private
  end;

  TPDFPageSettings = record
    PrintOrientation: TPrinterOrientation;
    PaperSize: Integer;
    MarginTop: Double;
    MarginBottom: Double;
    MarginLeft: Double;
    MarginRight: Double;
  end;

  TSettings = class
  private
    FSplitterPos: Integer;
    FXMLFontSize: Integer;
    FStyleName: string;
    FUseDarkStyle: boolean;
    FXMLFontName: string;
    FShowXML: Boolean;
    FShowIcon: Boolean;
    FActivePageIndex: Integer;
    FThemeSelection: TThemeSelection;
    FSVGEngine: TSVGEngine;
    FStylesheetName: string;
    FHTMLFontSize: Integer;
    FHTMLFontName: string;
    FIconStylesheetName: string;
    FButtonDrawRounded: Boolean;
    FToolbarDrawRounded: Boolean;
    FMenuDrawRounded: Boolean;
    function GetUseDarkStyle: Boolean;
    procedure SetSVGEngine(const Value: TSVGEngine);
    function GetThemeSectionName: string;
    function GetButtonTextColor: TColor;
    class function GetSettingsFileName: string; static;
    procedure UpdateEngine;
    procedure SetButtonDrawRounded(const Value: Boolean);
    procedure SetToolbarDrawRounded(const Value: Boolean);
    procedure SetMenuDrawRounded(const Value: Boolean);
  protected
    FIniFile: TIniFile;
  public
    LightBackground: Integer;
    PDFPageSettings: TPDFPageSettings;
    constructor CreateSettings(const ASettingFileName: string;
      const ASynEditHighilighter: TSynCustomHighlighter;
      const ASynEditorOptions: TSynEditorOptionsContainer);
    destructor Destroy; override;

    class var FSettingsFileName: string;
    class var FSettingsPath: string;
    class property SettingsFileName: string read GetSettingsFileName;

    procedure UpdateSettings(const AXMLFontName, AHTMLFontName: string;
      AXMLFontSize, AHTMLFontSize: Integer; AEditorVisible: Boolean;  AIconVisible: Boolean);
    procedure ReadSettings(const ASynEditHighilighter: TSynCustomHighlighter;
      const ASynEditorOptions: TSynEditorOptionsContainer); virtual;
    procedure WriteSettings(const ASynEditHighilighter: TSynCustomHighlighter;
      const ASynEditorOptions: TSynEditorOptionsContainer); virtual;

    property UseDarkStyle: Boolean read GetUseDarkStyle;
    property ButtonTextColor: TColor read GetButtonTextColor;

    property XMLFontSize: Integer read FXMLFontSize write FXMLFontSize;
    property XMLFontName: string read FXMLFontName write FXMLFontName;
    property HTMLFontSize: Integer read FHTMLFontSize write FHTMLFontSize;
    property HTMLFontName: string read FHTMLFontName write FHTMLFontName;
    property StyleName: string read FStyleName write FStyleName;
    property ShowXML: Boolean read FShowXML write FShowXML;
    property ShowIcon: Boolean read FShowIcon write FShowIcon;
    property SplitterPos: Integer read FSplitterPos write FSplitterPos;
    property SVGEngine: TSVGEngine read FSVGEngine write SetSVGEngine;
    property ActivePageIndex: Integer read FActivePageIndex write FActivePageIndex;
    property ThemeSelection: TThemeSelection read FThemeSelection write FThemeSelection;
    property StylesheetName: string read FStylesheetName write FStylesheetName;
    property IconStylesheetName: string read FIconStylesheetName write FIconStylesheetName;
    property ButtonDrawRounded: Boolean read FButtonDrawRounded write SetButtonDrawRounded;
    property ToolbarDrawRounded: Boolean read FToolbarDrawRounded write SetToolbarDrawRounded;
    property MenuDrawRounded: Boolean read FMenuDrawRounded write SetMenuDrawRounded;
  end;

  TPreviewSettings = class(TSettings)
  public
    constructor CreateSettings(const ASynEditHighilighter: TSynCustomHighlighter);
  end;

  TEditorSettings = class(TSettings)
  private
    FAllowEdit: Boolean;
    FAllowXSL: Boolean;
    FAllowXSLToInvoice: Boolean;
    FAllowXSLToSVG: Boolean;
    FLightActiveLineColor: TColor;
    FDarkActiveLineColor: TColor;

    procedure WriteSynEditorOptions(
      const ASynEditorOptions: TSynEditorOptionsContainer);
    procedure ReadSynEditorOptions(
      const ASynEditorOptions: TSynEditorOptionsContainer);
  public
    HistoryFileList: TStrings;
    OpenedFileList: TStrings;
    CurrentFileName: string;
    procedure ReadSettings(const ASynEditHighilighter: TSynCustomHighlighter;
      const ASynEditorOptions: TSynEditorOptionsContainer); override;
    procedure WriteSettings(const ASynEditHighilighter: TSynCustomHighlighter;
      const ASynEditorOptions: TSynEditorOptionsContainer); override;
    constructor CreateSettings(const ASynEditHighilighter: TSynCustomHighlighter;
      const ASynEditorOptions: TSynEditorOptionsContainer);
    destructor Destroy; override;
    procedure UpdateOpenedFiles(AFileList: TStrings; const ACurrentFileName: string);

    property AllowEdit: Boolean read FAllowEdit write FAllowEdit;
    property AllowXSL: Boolean read FAllowXSL write FAllowXSL;
    property LightActiveLineColor: TColor read FLightActiveLineColor write FLightActiveLineColor;
    property DarkActiveLineColor: TColor read FDarkActiveLineColor write FDarkActiveLineColor;
    property AllowXSLToInvoice: Boolean read FAllowXSLToInvoice write FAllowXSLToInvoice;
    property AllowXSLToSVG: Boolean read FAllowXSLToSVG write FAllowXSLToSVG;
  end;

implementation

uses
  Vcl.Controls
  , SVGInterfaces
  , D2DSVGFactory
  , Image32SVGFactory
  , System.Types
  , System.TypInfo
  , System.Rtti
  , System.StrUtils
  , System.IOUtils
  , Winapi.ShlObj
  , Winapi.Windows
  , Img32.Text
{$IFNDEF DISABLE_STYLES}
  , Vcl.Themes
{$ENDIF}
  , uLogExcept
  , uRegistry
  , uMisc
  , SynEdit
  , Winapi.Messages
  ;

const
  LAST_OPENED_SECTION = 'LastOpened';
  FILES_OPENED_SECTION = 'FilesOpened';
  EDITOPTION_GUTTER = 'EditorOptions_Gutter';
  EDITOPTION_RIGHTEDGE = 'EditorOptions_RightEdge';
  EDITOPTION_LINESPACING = 'EditorOptions_LineSpacing';
  EDITOPTION_BOOKMARK = 'EditorOptions_Bookmark';
  EDITOPTION_OPTIONS = 'EditorOptions_Options';
  default_lightbackground = 200;
  default_darkbackground = 55;

var
  ThemeAttributes: TList<TThemeAttribute>;

procedure InitDefaultThemesAttributes;

  procedure RegisterThemeAttributes(
    const AVCLStyleName: string;
    const AThemeType: TThemeType);
  var
    LThemeAttribute: TThemeAttribute;

    procedure UpdateThemeAttributes;
    begin
      LThemeAttribute.StyleName := AVCLStyleName;
      LThemeAttribute.ThemeType := AThemeType;
    end;

  begin
    for LThemeAttribute in ThemeAttributes do
    begin
      if SameText(LThemeAttribute.StyleName, AVCLStyleName) then
      begin
        UpdateThemeAttributes;
        Exit; //Found: exit
      end;
    end;
    //not found
    LThemeAttribute := TThemeAttribute.Create;
    ThemeAttributes.Add(LThemeAttribute);
    UpdateThemeAttributes;
  end;

begin
  ThemeAttributes := TList<TThemeAttribute>.Create;

{$IFNDEF DISABLE_STYLES}
  if StyleServices.Enabled then
  begin
    //High-DPI Themes (Delphi 11.0)
    RegisterThemeAttributes('Windows'               ,ttLight );
    RegisterThemeAttributes('Aqua Light Slate'      ,ttLight );
    RegisterThemeAttributes('Copper'                ,ttLight );
    RegisterThemeAttributes('CopperDark'            ,ttDark  );
    RegisterThemeAttributes('Coral'                 ,ttLight );
    RegisterThemeAttributes('Diamond'               ,ttLight );
    RegisterThemeAttributes('Emerald'               ,ttLight );
    RegisterThemeAttributes('Flat UI Light'         ,ttLight );
    RegisterThemeAttributes('Glow'                  ,ttDark  );
    RegisterThemeAttributes('Iceberg Classico'      ,ttLight );
    RegisterThemeAttributes('Lavender Classico'     ,ttLight );
    RegisterThemeAttributes('Sky'                   ,ttLight );
    RegisterThemeAttributes('Slate Classico'        ,ttLight );
    RegisterThemeAttributes('Sterling'              ,ttLight );
    RegisterThemeAttributes('Tablet Dark'           ,ttDark  );
    RegisterThemeAttributes('Tablet Light'          ,ttLight );
    RegisterThemeAttributes('Windows10'             ,ttLight );
    RegisterThemeAttributes('Windows10 Blue'        ,ttDark  );
    RegisterThemeAttributes('Windows10 Dark'        ,ttDark  );
    RegisterThemeAttributes('Windows10 Green'       ,ttDark  );
    RegisterThemeAttributes('Windows10 Purple'      ,ttDark  );
    RegisterThemeAttributes('Windows10 SlateGray'   ,ttDark  );
    RegisterThemeAttributes('Glossy'                ,ttDark  );
    RegisterThemeAttributes('Windows10 BlackPearl'  ,ttDark  );
    RegisterThemeAttributes('Windows10 Blue Whale'  ,ttDark  );
    RegisterThemeAttributes('Windows10 Clear Day'   ,ttLight );
    RegisterThemeAttributes('Windows10 Malibu'      ,ttLight );
    RegisterThemeAttributes('Windows11 Modern Dark' ,ttDark  );
    RegisterThemeAttributes('Windows11 Modern Light',ttLight );
  end;
{$ELSE}
    RegisterThemeAttributes('Windows'            ,ttLight );
{$ENDIF}
end;

{ TSettings }

constructor TSettings.CreateSettings(const ASettingFileName: string;
  const ASynEditHighilighter: TSynCustomHighlighter;
  const ASynEditorOptions: TSynEditorOptionsContainer);
begin
  inherited Create;
  FIniFile := TIniFile.Create(ASettingFileName);
  FSettingsFileName := ASettingFileName;
  FSettingsPath := ExtractFilePath(ASettingFileName);
  System.SysUtils.ForceDirectories(FSettingsPath);
  ReadSettings(ASynEditHighilighter, ASynEditorOptions);
end;

destructor TSettings.Destroy;
begin
  FIniFile.UpdateFile;
  FIniFile.Free;
  inherited;
end;

function TSettings.GetButtonTextColor: TColor;
{$IFNDEF DISABLE_STYLES}
var
  LStyleServices: TCustomStyleServices;
{$ENDIF}
begin
{$IFNDEF DISABLE_STYLES}
  LStyleServices := TStyleManager.Style[Self.StyleName];
  if Assigned(LStyleServices) then
    Result := LStyleServices.GetStyleFontColor(sfButtonTextNormal)
  else
    Result := clBtnText;
{$ELSE}
  Result := clBtnText;
{$ENDIF}
end;

class function TSettings.GetSettingsFileName: string;
begin
  Result := FSettingsFileName;
end;

function TSettings.GetThemeSectionName: string;
begin
  if FUseDarkStyle then
    Result := 'Dark'
  else
    Result := 'Light';
end;

function TSettings.GetUseDarkStyle: Boolean;
begin
  Result := FUseDarkStyle;
end;

procedure TSettings.ReadSettings(const ASynEditHighilighter: TSynCustomHighlighter;
  const ASynEditorOptions: TSynEditorOptionsContainer);
var
  LThemeSection: string;
  I: Integer;
  LAttribute: TSynHighlighterAttributes;
begin
  TLogPreview.Add('ReadSettings '+SettingsFileName);
  FXMLFontSize := FIniFile.ReadInteger('Global', 'XMLFontSize', 10);
  FHTMLFontSize := FIniFile.ReadInteger('Global', 'HTMLFontSize', 12);
  FXMLFontName := FIniFile.ReadString('Global', 'XMLFontName', 'Consolas');
  FHTMLFontName := FIniFile.ReadString('Global', 'HTMLFontName', 'Arial');
  FShowXML := FIniFile.ReadInteger('Global', 'ShowXML', 0) = 1;
  FShowIcon := FIniFile.ReadInteger('Global', 'ShowIcon', 1) = 1;
  FSplitterPos := FIniFile.ReadInteger('Global', 'SplitterPos', 33);
  SVGEngine := TSVGEngine(FIniFile.ReadInteger('Global', 'SVGEngine', 0));
  FActivePageIndex := FIniFile.ReadInteger('Global', 'ActivePageIndex', 0);
  FStyleName := FIniFile.ReadString('Global', 'StyleName', DefaultStyleName);
  FStylesheetName := FIniFile.ReadString('Global', 'StylesheetName', 'Custom');
  FIconStylesheetName := FIniFile.ReadString('Global', 'IconStylesheetName', 'Default');
  FThemeSelection := TThemeSelection(FIniFile.ReadInteger('Global', 'ThemeSelection', 0));
  FToolbarDrawRounded := FIniFile.ReadBool('Global', 'ToolbarDrawRounded', false);
  FButtonDrawRounded := FIniFile.ReadBool('Global', 'ButtonDrawRounded', false);
  FMenuDrawRounded := FIniFile.ReadBool('Global', 'MenuDrawRounded', false);
  //Select Style by default on Actual Windows Theme
  if FThemeSelection = tsAsWindows then
  begin
    FUseDarkStyle := not IsWindowsAppThemeLight;
  end
  else
    FUseDarkStyle := FThemeSelection = tsDarkTheme;

  if FUseDarkStyle then
    LightBackground := FIniFile.ReadInteger('Global', 'LightBackground', default_darkbackground)
  else
    LightBackground := FIniFile.ReadInteger('Global', 'LightBackground', default_lightbackground);

  //Load Highlighter in specific section by Theme
  if Assigned(ASynEditHighilighter) then
  begin
    LThemeSection := GetThemeSectionName;
    for I := 0 to ASynEditHighilighter.AttrCount - 1 do
    begin
      LAttribute := ASynEditHighilighter.Attribute[I];
      LAttribute.Background := FIniFile.ReadInteger(LThemeSection+LAttribute.Name, 'Background',
        LAttribute.Background);
      LAttribute.Foreground := FIniFile.ReadInteger(LThemeSection+LAttribute.Name, 'Foreground',
        LAttribute.Foreground);
      LAttribute.IntegerStyle := FIniFile.ReadInteger(LThemeSection+LAttribute.Name, 'Style',
        LAttribute.IntegerStyle);
    end;
  end;
  PDFPageSettings.PrintOrientation := TPrinterOrientation(FIniFile.ReadInteger('PDFPageSettins', 'PrintOrientation', Ord(TPrinterOrientation.poPortrait)));
  PDFPageSettings.PaperSize := FIniFile.ReadInteger('PDFPageSettins', 'PaperSize', 0);
  PDFPageSettings.MarginTop := FIniFile.ReadFloat('PDFPageSettins', 'MarginTop', 1);
  PDFPageSettings.MarginBottom := FIniFile.ReadFloat('PDFPageSettins', 'MarginBottom', 1);
  PDFPageSettings.MarginLeft := FIniFile.ReadFloat('PDFPageSettins', 'MarginLeft', 1);
  PDFPageSettings.MarginRight := FIniFile.ReadFloat('PDFPageSettins', 'MarginRight', 1);
end;

procedure TSettings.UpdateEngine;
begin
  case FSVGEngine of
    enImage32: SetGlobalSvgFactory(GetImage32SVGFactory);
    enDirect2D: SetGlobalSvgFactory(GetD2DSVGFactory);
  end;
end;

procedure TSettings.SetSVGEngine(const Value: TSVGEngine);
begin
  if FSVGEngine <> Value then
  begin
    FSVGEngine := Value;
    UpdateEngine;
  end;
end;

procedure TSettings.UpdateSettings(const AXMLFontName, AHTMLFontName: string;
  AXMLFontSize, AHTMLFontSize: Integer; AEditorVisible: Boolean; AIconVisible: Boolean);
begin
  XMLFontSize := AXMLFontSize;
  XMLFontName := AXMLFontName;
  HTMLFontSize := AHTMLFontSize;
  HTMLFontName := AHTMLFontName;
  ShowXML := AEditorVisible;
  ShowIcon:= AIconVisible;
end;

procedure TSettings.WriteSettings(const ASynEditHighilighter: TSynCustomHighlighter;
  const ASynEditorOptions: TSynEditorOptionsContainer);
var
  I: Integer;
  LAttribute: TSynHighlighterAttributes;
  LThemeSection: string;
begin
  FIniFile.WriteInteger('Global', 'XMLFontSize', FXMLFontSize);
  FIniFile.WriteInteger('Global', 'HTMLFontSize', FHTMLFontSize);

  FIniFile.WriteString('Global', 'XMLFontName', FXMLFontName);
  FIniFile.WriteString('Global', 'HTMLFontName', FHTMLFontName);

  FIniFile.WriteString('Global', 'StyleName', FStyleName);
  FIniFile.WriteInteger('Global', 'ShowXML', Ord(FShowXML));
  FIniFile.WriteInteger('Global', 'ShowIcon', Ord(FShowIcon));
  FIniFile.WriteInteger('Global', 'SplitterPos', FSplitterPos);
  FIniFile.WriteInteger('Global', 'SVGEngine', Ord(FSVGEngine));
  FIniFile.WriteInteger('Global', 'ActivePageIndex', FActivePageIndex);
  FIniFile.WriteString('Global', 'StylesheetName', FStylesheetName);
  FIniFile.WriteString('Global', 'IconStylesheetName', FIconStylesheetName);

  FIniFile.WriteInteger('Global', 'ThemeSelection', Ord(FThemeSelection));
  FIniFile.WriteBool('Global', 'ToolbarDrawRounded', ToolbarDrawRounded);
  FIniFile.WriteBool('Global', 'ButtonDrawRounded', ButtonDrawRounded);
  FIniFile.WriteBool('Global', 'MenuDrawRounded', MenuDrawRounded);

  if (FUseDarkStyle and (LightBackground <> default_darkbackground)) or
    (not FUseDarkStyle and (LightBackground <> default_lightbackground)) then
    FIniFile.WriteInteger('Global', 'LightBackground', LightBackground);

  if ASynEditHighilighter <> nil then
  begin
    //Save Highlighter in specific section by Theme
    LThemeSection := GetThemeSectionName;
    for I := 0 to ASynEditHighilighter.AttrCount - 1 do
    begin
      LAttribute := ASynEditHighilighter.Attribute[I];
      FIniFile.WriteInteger(LThemeSection+LAttribute.Name, 'Background', LAttribute.Background);
      FIniFile.WriteInteger(LThemeSection+LAttribute.Name, 'Foreground', LAttribute.Foreground);
      FIniFile.WriteInteger(LThemeSection+LAttribute.Name, 'Style', LAttribute.IntegerStyle);
    end;
  end;

  FIniFile.WriteInteger('PDFPageSettins', 'Orientation', Ord(PDFPageSettings.PrintOrientation));
  FIniFile.WriteInteger('PDFPageSettins', 'PaperSize', Ord(PDFPageSettings.PaperSize));
  FIniFile.WriteFloat('PDFPageSettins', 'MarginTop', PDFPageSettings.MarginTop);
  FIniFile.WriteFloat('PDFPageSettins', 'MarginBottom', PDFPageSettings.MarginBottom);
  FIniFile.WriteFloat('PDFPageSettins', 'MarginLeft', PDFPageSettings.MarginLeft);
  FIniFile.WriteFloat('PDFPageSettins', 'MarginRight', PDFPageSettings.MarginRight);
end;

procedure TSettings.SetToolbarDrawRounded(
  const Value: Boolean);
begin
  FToolbarDrawRounded := Value;
end;

procedure TSettings.SetMenuDrawRounded(const Value: Boolean);
begin
  FMenuDrawRounded := Value;
end;

procedure TSettings.SetButtonDrawRounded(const Value: Boolean);
begin
  FButtonDrawRounded := Value;
end;

{ TPreviewSettings }

constructor TPreviewSettings.CreateSettings(
  const ASynEditHighilighter: TSynCustomHighlighter);
begin
  inherited CreateSettings(
    IncludeTrailingPathDelimiter(
      GetSpecialFolder(CSIDL_APPDATA)) +'FExplorer\PreviewSettings.ini',
    ASynEditHighilighter, nil);
end;

{ TEditorSettings }

constructor TEditorSettings.CreateSettings(const ASynEditHighilighter: TSynCustomHighlighter;
  const ASynEditorOptions: TSynEditorOptionsContainer);
begin
  HistoryFileList := TStringList.Create;
  OpenedFileList := TStringList.Create;
  inherited CreateSettings(
    IncludeTrailingPathDelimiter(
      GetSpecialFolder(CSIDL_APPDATA)) +'FExplorer\ViewerSettings.ini',
    ASynEditHighilighter, ASynEditorOptions);
  ReadSynEditorOptions(ASynEditorOptions);
end;

destructor TEditorSettings.Destroy;
begin
  HistoryFileList.Free;
  OpenedFileList.Free;
  inherited;
end;

procedure TEditorSettings.ReadSettings(
  const ASynEditHighilighter: TSynCustomHighlighter;
  const ASynEditorOptions: TSynEditorOptionsContainer);
var
  I: Integer;
  LValue: string;
  LFileName: string;
begin
  inherited;
  //ActiveLine Color
  DarkActiveLineColor := FIniFile.ReadInteger('Global', 'DarkActiveLineColor', default_darkactivelinecolor);
  LightActiveLineColor := FIniFile.ReadInteger('Global', 'LightActiveLineColor', default_lightactivelinecolor);
  if FUseDarkStyle then
    ASynEditorOptions.ActiveLineColor := DarkActiveLineColor
  else
    ASynEditorOptions.ActiveLineColor := LightActiveLineColor;

  if ASynEditHighilighter = nil then
  begin
    //Leggo la lista dei files aperti di recente
    FIniFile.ReadSectionValues(LAST_OPENED_SECTION, HistoryFileList);
    for I := 0 to HistoryFileList.Count -1 do
    begin
      LValue := HistoryFileList.strings[i];
      //tolgo la chiave
      LFileName := Copy(LValue, pos('=',LValue)+1,MaxInt);
      if FileExists(LFileName) then
        HistoryFileList.strings[i] := LFileName;
    end;
    //Leggo la lista dei files aperti l'ultima volta
    FIniFile.ReadSectionValues(FILES_OPENED_SECTION, OpenedFileList);
    for I := 0 to OpenedFileList.Count -1 do
    begin
      LValue := OpenedFileList.strings[i];
      //tolgo la chiave
      LFileName := Copy(LValue, pos('=',LValue)+1,MaxInt);
      if FileExists(LFileName) then
        OpenedFileList.strings[i] := LFileName;
    end;
  end;
  CurrentFileName := FIniFile.ReadString('Global', 'CurrentFileName', '');

  FAllowEdit := FIniFile.ReadBool('Editor', 'AllowEdit', False);
  FAllowXSL := FIniFile.ReadBool('Editor', 'AllowXSL', False);
  FAllowXSLToInvoice := FIniFile.ReadBool('Editor', 'AllowXSLToInvoice', False);
  FAllowXSLToSVG := FIniFile.ReadBool('Editor', 'AllowXSLToSVG', False);
end;

procedure TeditorSettings.ReadSynEditorOptions(
  const ASynEditorOptions: TSynEditorOptionsContainer);

  procedure UpdateEditorOptions(const AName: string;
    const AValue: TSynEditorOption;
    const ADefault: Boolean = True);
  begin
    if FIniFile.ReadBool(EDITOPTION_OPTIONS, AName, ADefault) then
      ASynEditorOptions.Options := ASynEditorOptions.Options + [AValue];
  end;

  procedure UpdateEditorScrollOptions(const AName: string;
    const AValue: TSynEditorScrollOption;
    const ADefault: Boolean = True);
  begin
    if FIniFile.ReadBool(EDITOPTION_OPTIONS, AName, ADefault) then
      ASynEditorOptions.ScrollOptions := ASynEditorOptions.ScrollOptions + [AValue];
  end;

begin
  if not Assigned(ASynEditorOptions) then
    Exit;

  //Gutter
  ASynEditorOptions.Gutter.Visible := FIniFile.ReadBool(EDITOPTION_GUTTER, 'Visible', True);
  ASynEditorOptions.Gutter.AutoSize := FIniFile.ReadBool(EDITOPTION_GUTTER, 'AutoSize', True);
  ASynEditorOptions.Gutter.ShowLineNumbers := FIniFile.ReadBool(EDITOPTION_GUTTER, 'ShowLineNumbers', True);
  ASynEditorOptions.Gutter.LeadingZeros := FIniFile.ReadBool(EDITOPTION_GUTTER, 'LeadingZeros', False);
  ASynEditorOptions.Gutter.ZeroStart := FIniFile.ReadBool(EDITOPTION_GUTTER, 'ZeroStart', False);
  ASynEditorOptions.Gutter.UseFontStyle := FIniFile.ReadBool(EDITOPTION_GUTTER, 'UseFontStyle', True);
  ASynEditorOptions.Gutter.Font.Name := FIniFile.ReadString(EDITOPTION_GUTTER, 'Font.Name', 'Consolas');
  ASynEditorOptions.Gutter.Font.Size := FIniFile.ReadInteger(EDITOPTION_GUTTER, 'Font.Size', 11);
  //Right Edge
  ASynEditorOptions.RightEdge := FIniFile.ReadInteger(EDITOPTION_RIGHTEDGE,'RightEdge',80);
  //Line Spacing
  ASynEditorOptions.ExtraLineSpacing := FIniFile.ReadInteger(EDITOPTION_LINESPACING,'ExtraLineSpacing', 0);
  ASynEditorOptions.TabWidth := FIniFile.ReadInteger(EDITOPTION_LINESPACING,'TabWidth',4);
  //Bookmarks
  ASynEditorOptions.BookMarkOptions.EnableKeys := FIniFile.ReadBool(EDITOPTION_BOOKMARK,'EnableKeys', True);
  ASynEditorOptions.BookMarkOptions.GlyphsVisible := FIniFile.ReadBool(EDITOPTION_BOOKMARK,'GlyphsVisible', True);
  //Options
  ASynEditorOptions.Options := [];
  UpdateEditorOptions('AutoIndent', eoAutoIndent);
  UpdateEditorOptions('DragDropEditing',  eoDragDropEditing);
  UpdateEditorOptions('SmartTabs',  eoSmartTabs);
  UpdateEditorScrollOptions('HalfPageScroll',  eoHalfPageScroll);
  UpdateEditorScrollOptions('ScrollByOneLess',  eoScrollByOneLess);
  UpdateEditorScrollOptions('ScrollPastEof',  eoScrollPastEof);
  UpdateEditorScrollOptions('ScrollPastEol',  eoScrollPastEol);
  UpdateEditorScrollOptions('ShowScrollHint',  eoShowScrollHint);
  UpdateEditorOptions('TabsToSpaces',  eoTabsToSpaces);
  UpdateEditorOptions('TrimTrailingSpaces',  eoTrimTrailingSpaces);
  UpdateEditorOptions('KeepCaretX',  eoKeepCaretX);
  UpdateEditorOptions('SmartTabDelete',  eoSmartTabDelete);
  UpdateEditorOptions('RightMouseMovesCursor',  eoRightMouseMovesCursor);
  UpdateEditorOptions('EnhanceHomeKey',  eoEnhanceHomeKey);
  UpdateEditorOptions('EnhanceEndKey',  eoEnhanceEndKey);
  UpdateEditorOptions('GroupUndo',  eoGroupUndo);
  UpdateEditorOptions('TabIndent',  eoTabIndent);
  UpdateEditorScrollOptions('DisableScrollArrows',  eoDisableScrollArrows);
  UpdateEditorScrollOptions('HideShowScrollbars',  eoHideShowScrollbars);
  ASynEditorOptions.WantTabs := FIniFile.ReadBool(EDITOPTION_OPTIONS, 'WantTabs', False);
  ASynEditorOptions.WordWrap := FIniFile.ReadBool(EDITOPTION_OPTIONS, 'WordWrap', True);

(*
  //Caret
  cInsertCaret.ItemIndex := ord(ASynEditorOptions.InsertCaret);
  cOverwriteCaret.ItemIndex := ord(ASynEditorOptions.OverwriteCaret);

  KeyList.Items.BeginUpdate;
  try
    KeyList.Items.Clear;
    for I := 0 to ASynEditorOptions.Keystrokes.Count-1 do
    begin
      Item := KeyList.Items.Add;
      FillInKeystrokeInfo(ASynEditorOptions.Keystrokes.Items[I], Item);
      Item.Data := ASynEditorOptions.Keystrokes.Items[I];
    end;
    if (KeyList.Items.Count > 0) then KeyList.Items[0].Selected := True;
  finally
    KeyList.Items.EndUpdate;
  end;
*)
end;

procedure TEditorSettings.UpdateOpenedFiles(AFileList: TStrings;
  const ACurrentFileName: string);
begin
  OpenedFileList.Assign(AFileList);
  CurrentFileName := ACurrentFileName;
end;

procedure TEditorSettings.WriteSettings(
  const ASynEditHighilighter: TSynCustomHighlighter;
  const ASynEditorOptions: TSynEditorOptionsContainer);
var
  I: Integer;
begin
  inherited;
  if (DarkActiveLineColor <> default_darkactivelinecolor) then
    FIniFile.WriteInteger('Global', 'DarkActiveLineColor', DarkActiveLineColor)
  else
    FIniFile.DeleteKey('Global', 'DarkActiveLineColor');

  if (LightActiveLineColor <> default_lightactivelinecolor) then
    FIniFile.WriteInteger('Global', 'LightActiveLineColor', LightActiveLineColor)
  else
    FIniFile.DeleteKey('Global', 'LightActiveLineColor');

  FIniFile.EraseSection(LAST_OPENED_SECTION);
  for I := 0 to HistoryFileList.Count -1 do
  begin
    FIniFile.WriteString(LAST_OPENED_SECTION, InttoStr(I),
      HistoryFileList.strings[i]);
  end;
  FIniFile.EraseSection(FILES_OPENED_SECTION);
  for I := 0 to OpenedFileList.Count -1 do
  begin
    FIniFile.WriteString(FILES_OPENED_SECTION, InttoStr(I),
      OpenedFileList.strings[i]);
  end;
  FIniFile.WriteString('Global', 'CurrentFileName', CurrentFileName);

  FIniFile.WriteBool('Editor', 'AllowEdit', FAllowEdit);
  FIniFile.WriteBool('Editor', 'AllowXSL', FAllowXSL);
  FIniFile.WriteBool('Editor', 'AllowXSLToInvoice', FAllowXSLToInvoice);
  FIniFile.WriteBool('Editor', 'AllowXSLToSVG', FAllowXSLToSVG);

  WriteSynEditorOptions(ASynEditorOptions);
end;

procedure TEditorSettings.WriteSynEditorOptions(
  const ASynEditorOptions: TSynEditorOptionsContainer);

  procedure WriteEditorOptions(const AName: string;
    const AValue: TSynEditorOption);
  begin
    FIniFile.WriteBool(EDITOPTION_OPTIONS, AName, AValue in ASynEditorOptions.Options);
  end;

  procedure WriteEditorScrollOptions(const AName: string;
    const AValue: TSynEditorScrollOption);
  begin
    FIniFile.WriteBool(EDITOPTION_OPTIONS, AName, AValue in ASynEditorOptions.ScrollOptions);
  end;

begin
  if not Assigned(ASynEditorOptions) then
    Exit;
  //Gutter
  FIniFile.WriteBool(EDITOPTION_GUTTER, 'Visible', ASynEditorOptions.Gutter.Visible);
  FIniFile.WriteBool(EDITOPTION_GUTTER, 'AutoSize', ASynEditorOptions.Gutter.AutoSize);
  FIniFile.WriteBool(EDITOPTION_GUTTER, 'ShowLineNumbers', ASynEditorOptions.Gutter.ShowLineNumbers);
  FIniFile.WriteBool(EDITOPTION_GUTTER, 'LeadingZeros', ASynEditorOptions.Gutter.LeadingZeros);
  FIniFile.WriteBool(EDITOPTION_GUTTER, 'ZeroStart', ASynEditorOptions.Gutter.ZeroStart);
  FIniFile.WriteBool(EDITOPTION_GUTTER, 'UseFontStyle', ASynEditorOptions.Gutter.UseFontStyle);
  FIniFile.WriteString(EDITOPTION_GUTTER, 'Font.Name', ASynEditorOptions.Gutter.Font.Name);
  FIniFile.WriteInteger(EDITOPTION_GUTTER, 'Font.Size', ASynEditorOptions.Gutter.Font.Size);
  //Right Edge
  FIniFile.WriteInteger(EDITOPTION_RIGHTEDGE,'RightEdge', ASynEditorOptions.RightEdge);
  //Line Spacing
  FIniFile.WriteInteger(EDITOPTION_LINESPACING,'ExtraLineSpacing', ASynEditorOptions.ExtraLineSpacing);
  FIniFile.WriteInteger(EDITOPTION_LINESPACING,'TabWidth', ASynEditorOptions.TabWidth);
  //Bookmarks
  FIniFile.WriteBool(EDITOPTION_BOOKMARK,'EnableKeys', ASynEditorOptions.BookMarkOptions.EnableKeys);
  FIniFile.WriteBool(EDITOPTION_BOOKMARK,'GlyphsVisible', ASynEditorOptions.BookMarkOptions.GlyphsVisible);
  WriteEditorOptions('AutoIndent', eoAutoIndent);
  WriteEditorOptions('DragDropEditing',  eoDragDropEditing);
  WriteEditorOptions('SmartTabs',  eoSmartTabs);
  WriteEditorScrollOptions('HalfPageScroll',  eoHalfPageScroll);
  WriteEditorScrollOptions('ScrollByOneLess',  eoScrollByOneLess);
  WriteEditorScrollOptions('ScrollPastEof',  eoScrollPastEof);
  WriteEditorScrollOptions('ScrollPastEol',  eoScrollPastEol);
  WriteEditorScrollOptions('ShowScrollHint',  eoShowScrollHint);
  WriteEditorOptions('TabsToSpaces',  eoTabsToSpaces);
  WriteEditorOptions('TrimTrailingSpaces',  eoTrimTrailingSpaces);
  WriteEditorOptions('KeepCaretX',  eoKeepCaretX);
  WriteEditorOptions('SmartTabDelete',  eoSmartTabDelete);
  WriteEditorOptions('RightMouseMovesCursor',  eoRightMouseMovesCursor);
  WriteEditorOptions('EnhanceHomeKey',  eoEnhanceHomeKey);
  WriteEditorOptions('EnhanceEndKey',  eoEnhanceEndKey);
  WriteEditorOptions('GroupUndo',  eoGroupUndo);
  WriteEditorOptions('TabIndent',  eoTabIndent);
  WriteEditorScrollOptions('DisableScrollArrows',  eoDisableScrollArrows);
  WriteEditorScrollOptions('HideShowScrollbars',  eoHideShowScrollbars);
  FIniFile.WriteBool(EDITOPTION_OPTIONS, 'WantTabs', ASynEditorOptions.WantTabs);
  FIniFile.WriteBool(EDITOPTION_OPTIONS, 'WordWrap', ASynEditorOptions.WordWrap);
end;

{ TThemeAttribute }

class function TThemeAttribute.GetStyleAttributes(const AStyleName: string;
  out AThemeAttribute: TThemeAttribute): Boolean;
var
  LThemeAttribute: TThemeAttribute;
begin
  for LThemeAttribute in ThemeAttributes do
  begin
    if SameText(AStyleName, LThemeAttribute.StyleName) then
    begin
      AThemeAttribute := LThemeAttribute;
      Exit(True);
    end;
  end;
  Result := False;
  AThemeAttribute := nil;
end;

procedure FreeThemesAttributes;
var
  LThemeAttribute: TThemeAttribute;
begin
  if Assigned(ThemeAttributes) then
  begin
    for LThemeAttribute in ThemeAttributes do
      LThemeAttribute.Free;
    FreeAndNil(ThemeAttributes);
  end;
end;

initialization
  InitDefaultThemesAttributes;

finalization
  FreeThemesAttributes;

end.
