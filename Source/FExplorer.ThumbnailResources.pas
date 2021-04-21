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
unit FExplorer.ThumbnailResources;

interface

uses
  SysUtils
  , Classes
  , Xml.xmldom
  , Xml.XMLIntf
  , Xml.Win.msxmldom
  , Xml.XMLDoc
  ;

type
  TdmThumbnailResources = class(TDataModule)
    DefaultTemplate: TXMLDocument;
    SourceXML: TXMLDocument;
    EditingTemplate: TXMLDocument;
  private
    function Parse: string;
  public
    StylesheetName: string;
    function GetSVGText(const AXMLLines: TStrings): string; overload;
    function GetSVGText(const AStream: TStream): string; overload;
  public
    const SVG_DEFAULT_XSLT = 'Default';
    const SVG_EDITING_XSLT = 'Editing';
  end;

implementation

{$R *.dfm}

uses
  Windows, StrUtils, IOUtils, NetEncoding, ShellAPI;

{ TThumbnail }

function TdmThumbnailResources.Parse: string;
var
  LXSLTOutput: WideString;

  procedure Transform(AXMLDoc: TXMLDocument);
  begin
    AXMLDoc.Active := True;
    SourceXML.Node.TransformNode(AXMLDoc.DocumentElement, LXSLTOutput);
  end;

begin
  Result := '';
  LXSLTOutput := '';
  SourceXML.Active := True;
  try
    if StylesheetName = SVG_EDITING_XSLT then
      Transform(EditingTemplate)
    else
      Transform(DefaultTemplate);
  finally
    SourceXML.Active := False;
  end;
  Result := LXSLTOutput;
end;

function TdmThumbnailResources.GetSVGText(const AStream: TStream): string;
begin
  //Inizializza il Documento XML
  SourceXML.LoadFromStream(AStream, xetUTF_8);
  Result := Parse;
end;

function TdmThumbnailResources.GetSVGText(const AXMLLines: TStrings): string;
begin
  //Inizializza il Documento XML
  SourceXML.XML.Assign(AXMLLines);
  Result := Parse;
end;

end.
