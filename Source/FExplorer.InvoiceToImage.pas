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
unit FExplorer.InvoiceToImage;

interface

uses
  System.SysUtils
  , System.Classes;

type
  TInvoiceToSVG = class
  private
    FSVGTemplate: string;
    FInvoiceXML: string;
    function GetOutSVGtext: string;
    procedure SetInvoiceXML(const Value: string);
    procedure SetSVGTemplate(const Value: string);
  protected
  public
    property SVGTemplate: string read FSVGTemplate write SetSVGTemplate;
    property InvoiceXML: string read FInvoiceXML write SetInvoiceXML;
    property OutSVGText: string read GetOutSVGtext;
  end;


implementation

{ TInvoiceToSVG }

function TInvoiceToSVG.GetOutSVGtext: string;

begin
  //Applica i dati della fattura xml al template svg
  Result := FSVGTemplate;
  if FInvoiceXML <> '' then
  begin

  end;
end;

procedure TInvoiceToSVG.SetInvoiceXML(const Value: string);
begin
  FInvoiceXML := Value;
end;

procedure TInvoiceToSVG.SetSVGTemplate(const Value: string);
begin
  FSVGTemplate := Value;
end;

end.
