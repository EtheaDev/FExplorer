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
const
  SVG_TEMPLATE_XSLT = 'ThumbTemplate';

type
  TdmThumbnailResources = class(TDataModule)
    ThumbTemplate: TXMLDocument;
    SourceXML: TXMLDocument;
  private
    function Parse: string;
  public
    function GetSVGText(const AXMLLines: TStrings): string; overload;
    function GetSVGText(const AStream: TStream): string; overload;
  end;

implementation

{$R *.dfm}

uses
  Windows, StrUtils, IOUtils, NetEncoding, ShellAPI;

{ TThumbnail }

function TdmThumbnailResources.Parse: string;
var
  LXSLTOutput: WideString;
begin
  Result := '';
  ThumbTemplate.Active := True;
  SourceXML.Active := True;
  try
    SourceXML.Node.TransformNode(ThumbTemplate.DocumentElement, LXSLTOutput);
  finally
    SourceXML.Active := False;
    ThumbTemplate.Active := True;
  end;
  Result := LXSLTOutput;
end;

function TdmThumbnailResources.GetSVGText(const AStream: TStream): string;
var
  LStyleSheetName: string;
begin
  LStyleSheetName := SVG_TEMPLATE_XSLT;

  //Inizializza il Documento XML
  SourceXML.LoadFromStream(AStream, xetUTF_8);
  Result := Parse;
end;

function TdmThumbnailResources.GetSVGText(const AXMLLines: TStrings): string;
var
  LStyleSheetName: string;
begin
  LStyleSheetName := SVG_TEMPLATE_XSLT;

  //Inizializza il Documento XML
  SourceXML.XML.Assign(AXMLLines);

  Result := Parse;
end;

end.
