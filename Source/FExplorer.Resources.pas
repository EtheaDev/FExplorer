{******************************************************************************}
{                                                                              }
{       FExplorer: Shell extensions per Fattura Elettronica                    }
{       (Preview Panel, Thumbnail Icon, F.E.Viewer)                            }
{                                                                              }
{       Copyright (c) 2021-2022 (Ethea S.r.l.)                                 }
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
unit FExplorer.Resources;

interface

uses
  SysUtils
  , Classes
  , SynHighlighterXML
  , Vcl.Graphics
  , Vcl.ImgList
  , Vcl.Controls
  , System.ImageList
  , SynEdit
  , SynEditOptionsDialog
  , SynEditPrint
  , SynEditCodeFolding
  , SynEditHighlighter
  , SVGIconImageListBase
  , SVGIconImageList
  , Vcl.BaseImageCollection
  , SVGIconImageCollection
  , Xml.xmldom
  , Xml.XMLIntf
  , Xml.Win.msxmldom
  , Xml.XMLDoc
  ;

type
  TFileContentType = (fcGenericFile, fcLegalInvoice,
    fcGenericXML, fcStyleSheetLegalInvoice, fcStyleSheetSVGIcon, fcGenericXSL);

const AImageNames : Array[TFileContentType] of string =
  ('file',
   'fattura-elettronica',
   'xml',
   'xsl',
   'xsl',
   'xsl');

type
  TEditFileType = Record
    ComponentName : string;
    LanguageName : string;
    FileExtensions : string;
    SynHighlighter : TSynCustomHighlighter;
  end;

  TLinkedDoc = record
    FileName: string;
    FileType: string;
    Compressione: string;
    Data: string;
    procedure DumpAndOpen;
    procedure Clear;
  end;

  TLegalInvoiceLoader = class
  public
    class procedure LoadFromFile(const AFileName: string;
      const ASynEditor: TSynEdit);
    class function LoadFromStream(const AInputStream: TStream;
      const AOutStream: TStringStream): Boolean;
  end;

  TLegalInvoice = record
  private
    FParsed: Boolean;
    FXML: string;
    FHTML: string;
    FAllegati: TArray<TLinkedDoc>;
    procedure SetXML(const Value: string);
    procedure ParseAllegati(const AXMLDoc: IXMLDocument);
    function GetHasAllegati: Boolean;
  public
    StylesheetName: string;

    const ADE_TEMPLATE_XSLT = 'AgenziaEntrate';
    const ASSOSOFTWARE_XSLT = 'AssoSoftware';
    const CUSTOM_XSLT = 'Custom';
    const EDITING_XSLT = 'Editing';

    constructor Create(const AXML: string; const AParseImmediately: Boolean = True);

    procedure Clear;
    procedure Parse;

    property Parsed: Boolean read FParsed;
    property XML: string read FXML write SetXML;
    property HTML: string read FHTML;
    property Allegati: TArray<TLinkedDoc> read FAllegati;
    property HasAllegati: Boolean read GetHasAllegati;
  end;

  TdmResources = class(TDataModule)
    SynXMLSyn: TSynXMLSyn;
    SynXMLSynDark: TSynXMLSyn;
    SVGIconImageCollection: TSVGIconImageCollection;
    AssoSoftwareTemplate: TXMLDocument;
    CustomTemplate: TXMLDocument;
    SVGTemplates: TSVGIconImageCollection;
    AgenziaEntrateTemplate: TXMLDocument;
    SynXSLSyn: TSynXMLSyn;
    SynXSLSynDark: TSynXMLSyn;
    EditingTemplate: TXMLDocument;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    function GetEditFileType(const Extension : string) : TEditFileType;
    function GetFilter(const Language : string = '') : string;
    function GetSynHighlighter(const ADarkStyle: boolean;
      const ABackgroundColor: TColor) : TSynCustomHighlighter;
  end;

var
  dmResources: TdmResources;

  AFileTypes : Array of TEditFileType;

implementation

{$R *.dfm}

uses
  Windows
  , System.StrUtils
  , System.IOUtils
  , System.NetEncoding
  , Winapi.ShellAPI
  , PKCS7Extractor;


procedure TdmResources.DataModuleCreate(Sender: TObject);
var
  i,p : integer;
begin
  p := 0;
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TSynCustomHighlighter then
      inc(p);
  end;
  SetLength(AFileTypes, p);

  p := 0;
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is TSynCustomHighlighter then
    begin
      AFileTypes[p].ComponentName := Components[i].Name;
      AFileTypes[p].LanguageName := (Components[i] as TSynCustomHighlighter).LanguageName;
      AFileTypes[p].FileExtensions := (Components[i] as TSynCustomHighlighter).DefaultFilter;
      AFileTypes[p].SynHighlighter := (Components[i] as TSynCustomHighlighter);
      inc(p);
    end;
  end;
end;

function TdmResources.GetEditFileType(
  const Extension: string): TEditFileType;
var
  i : integer;
begin
  Result := AFileTypes[0]; //XML
  for i := low(AFileTypes) to high(AFileTypes) do
  begin
    if Pos(Extension, AFileTypes[i].FileExtensions) <> 0 then
    begin
      Result := AFileTypes[i];
      break;
    end;
  end;
end;

function TdmResources.GetFilter(const Language: string) : string;
var
  i : integer;
begin
  Result := '';
  for i := low(AFileTypes) to high(AFileTypes) do
  begin
    if (Language = '') or SameText(Language, afileTypes[i].LanguageName) then
    begin
      Result := Result + AFileTypes[i].FileExtensions+'|';
    end;
  end;
end;

function TdmResources.GetSynHighlighter(
  const ADarkStyle: boolean;
  const ABackgroundColor: TColor): TSynCustomHighlighter;
begin
  if ADarkStyle then
  begin
    Result := dmResources.SynXMLSynDark;
    SynXMLSynDark.ElementAttri.Background := ABackgroundColor;
    SynXMLSynDark.AttributeAttri.Background := ABackgroundColor;
    SynXMLSynDark.NamespaceAttributeAttri.Background := ABackgroundColor;
    SynXMLSynDark.AttributeValueAttri.Background := ABackgroundColor;
    SynXMLSynDark.NamespaceAttributeValueAttri.Background := ABackgroundColor;
    SynXMLSynDark.TextAttri.Background := ABackgroundColor;
    SynXMLSynDark.CDATAAttri.Background := ABackgroundColor;
    SynXMLSynDark.EntityRefAttri.Background := ABackgroundColor;
    SynXMLSynDark.ProcessingInstructionAttri.Background := ABackgroundColor;
    SynXMLSynDark.CommentAttri.Background := ABackgroundColor;
    SynXMLSynDark.DocTypeAttri.Background := ABackgroundColor;
    SynXMLSynDark.SpaceAttri.Background := ABackgroundColor;
    SynXMLSynDark.SymbolAttri.Background := ABackgroundColor;
  end
  else
  begin
    Result := dmResources.SynXMLSyn;
    SynXMLSyn.ElementAttri.Background := ABackgroundColor;
    SynXMLSyn.AttributeAttri.Background := ABackgroundColor;
    SynXMLSyn.NamespaceAttributeAttri.Background := ABackgroundColor;
    SynXMLSyn.AttributeValueAttri.Background := ABackgroundColor;
    SynXMLSyn.NamespaceAttributeValueAttri.Background := ABackgroundColor;
    SynXMLSyn.TextAttri.Background := ABackgroundColor;
    SynXMLSyn.CDATAAttri.Background := ABackgroundColor;
    SynXMLSyn.EntityRefAttri.Background := ABackgroundColor;
    SynXMLSyn.ProcessingInstructionAttri.Background := ABackgroundColor;
    SynXMLSyn.CommentAttri.Background := ABackgroundColor;
    SynXMLSyn.DocTypeAttri.Background := ABackgroundColor;
    SynXMLSyn.SpaceAttri.Background := ABackgroundColor;
    SynXMLSyn.SymbolAttri.Background := ABackgroundColor;
  end;
end;

{ TLegalInvoice }

procedure TLegalInvoice.Clear;
begin
  FXML := '';
  FHTML := '';
  StylesheetName := '';
  FAllegati := [];

  FParsed := False;

end;

constructor TLegalInvoice.Create(const AXML: string; const AParseImmediately: Boolean = True);
begin
  Clear;

  XML := AXML;
  if AParseImmediately then
    Parse;
end;

function TLegalInvoice.GetHasAllegati: Boolean;
begin
  Result := Length(FAllegati) > 0;
end;

procedure TLegalInvoice.Parse;
var
  LXMLDoc: IXMLDocument;
  LXSLTOutput: WideString;

  procedure Transform(const AXMLDoc: TXMLDocument);
  begin
    AXMLDoc.Active := True;
    LXMLDoc.Node.TransformNode(AXMLDoc.DocumentElement, LXSLTOutput);
  end;

begin
  //Inizializza il Documento XML
  LXMLDoc := LoadXMLData(XML);

  LXSLTOutput := '';

  if (StylesheetName = ADE_TEMPLATE_XSLT) then
    Transform(dmResources.AgenziaEntrateTemplate)
  else if (StylesheetName = ASSOSOFTWARE_XSLT) or (StylesheetName = '') then
    Transform(dmResources.AssoSoftwareTemplate)
  else if (StylesheetName = CUSTOM_XSLT) then
    Transform(dmResources.CustomTemplate)
  else if (StylesheetName = EDITING_XSLT) then
    Transform(dmResources.EditingTemplate);

  FHTML := LXSLTOutput;

  ParseAllegati(LXMLDoc);

  FParsed := True;
end;

procedure TLegalInvoice.ParseAllegati(const AXMLDoc: IXMLDocument);
var
  LAllegati: IDOMNodeList;
  LAllegato: TLinkedDoc;
  LAllegatoNode: IDOMNode;
  LAllegatoElement: IDOMElement;
  LList: IDOMNodeList;
  LIndex: Integer;
  LNomeAttachment: string;
  LFormatoAttachment: string;
  LAlgoritmoCompressione: string;
  LData: string;
begin
  FAllegati := [];

  LAllegati := AXMLDoc.DOMDocument.getElementsByTagName('Allegati');
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

      FAllegati := FAllegati + [LAllegato];
    end;
  end;
end;

procedure TLegalInvoice.SetXML(const Value: string);
begin
  if FXML <> Value then
  begin
    FXML := Value;
    FParsed := False;
  end;
end;

{ TAllegato }

procedure TLinkedDoc.Clear;
begin
  FileName := '';
  FileType := '';
  Compressione := '';
  Data := '';
end;

procedure TLinkedDoc.DumpAndOpen;
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

{ TLegalInvoiceLoader }

class function TLegalInvoiceLoader.LoadFromStream(
  const AInputStream: TStream;
  const AOutStream: TStringStream): Boolean;
begin
  if PKCS7Extractor.Verify(AInputStream) <> vsUnknown then
    Result := PKCS7Extractor.Extract(AInputStream, AOutStream)
  else
  begin
    AOutStream.LoadFromStream(AInputStream);
    Result := True;
  end;
end;

class procedure TLegalInvoiceLoader.LoadFromFile(
  const AFileName: string;
  const ASynEditor: TSynEdit);
var
  LFileStream: TFileStream;
  LOutStream: TMemoryStream;
begin
  LOutStream := nil;
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    if SameText(ExtractFileExt(AFileName), '.p7m') then
    begin
      LOutStream := TMemoryStream.Create;
      if PKCS7Extractor.Extract(LFileStream, LOutStream) then
      begin
        LOutStream.Position := 0;
        ASynEditor.Lines.LoadFromStream(LOutStream, TEncoding.UTF8);
      end;
    end
    else
    begin
      ASynEditor.Lines.LoadFromStream(LFileStream, TEncoding.UTF8);
    end;
  finally
    LOutStream.Free;
    LFileStream.Free;
  end;
end;

initialization
  PKCS7Extractor.Unload;
  FreeLibrary(GetModuleHandle(LIBEAY32_LIBRARY));
  PKCS7Extractor.SetFolder(
    ExtractFilePath(GetModuleName(HInstance)));
  PKCS7Extractor.Load

end.
