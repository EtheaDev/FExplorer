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
unit FExplorer.ThumbnailHandler;


interface

uses
  Classes,
  Controls,
  ComObj,
  ShlObj,
  Windows,
  Winapi.PropSys,
  System.Generics.Collections,
  SVGInterfaces,
  SVGCommon,
  ActiveX;

type
  TFEThumbnailProvider = class abstract
  public
    class function GetComClass: TComClass; virtual;
    class procedure RegisterThumbnailProvider(const AClassID: TGUID;
      const AName, ADescription: string);
  end;

  TThumbnailHandlerClass = class of TFEThumbnailProvider;

{$EXTERNALSYM IThumbnailProvider}
  IThumbnailProvider = interface(IUnknown)
    ['{E357FCCD-A995-4576-B01F-234630154E96}']
    function GetThumbnail(cx : uint; out hBitmap : HBITMAP; out bitmapType : dword): HRESULT; stdcall;
  end;

const
  {$EXTERNALSYM IID_IThumbnailProvider}
  ThumbnailProviderGUID = '{E357FCCD-A995-4576-B01F-234630154E96}';
  IID_IThumbnailProvider: TGUID = ThumbnailProviderGUID;

  MyFE_ThumbNailProviderGUID: TGUID = '{9522cb3f-efcb-4c99-ae56-7845adc154e1}';

type
  TComSVGThumbnailProvider = class(TComObject, IInitializeWithStream, IThumbnailProvider)
    function IInitializeWithStream.Initialize = IInitializeWithStream_Initialize;
    function IInitializeWithStream_Initialize(const pstream: IStream; grfMode: Cardinal): HRESULT; stdcall;
    function GetThumbnail(cx : uint; out hBitmap : HBITMAP; out bitmapType : dword): HRESULT; stdcall;
    function Unload: HRESULT; stdcall;
  private
    FThumbnailHandlerClass: TThumbnailHandlerClass;
    FIStream: IStream;
    FMode: Cardinal;
    FSVG: ISVG;
    FLightTheme: Boolean;
  protected
    property Mode: Cardinal read FMode write FMode;
    property IStream: IStream read FIStream write FIStream;
  public
    property ThumbnailHandlerClass: TThumbnailHandlerClass read FThumbnailHandlerClass write FThumbnailHandlerClass;
  end;

implementation

uses
  ComServ,
  Types,
  SysUtils,
  Graphics,
  ExtCtrls,
  uMisc,
  uREgistry,
  uLogExcept,
  uStreamAdapter,
  WinAPI.GDIPObj,
  WinAPI.GDIPApi,
  FExplorer.ThumbnailHandlerRegister,
  SVGIconUtils;

{ TComSVGThumbnailProvider }

function TComSVGThumbnailProvider.GetThumbnail(cx: uint; out hBitmap: HBITMAP;
  out bitmapType: dword): HRESULT;
const
  WTSAT_ARGB = 2;
var
  AStream: TIStreamAdapter;
  LBitmap: TBitmap;
  LAntiAliasColor: TColor;
begin
  try
    TLogPreview.Add('TComSVGThumbnailProvider.GetThumbnail start');
    hBitmap := 0;
    if (cx = 0) then
    begin
      Result := S_FALSE;
      Exit;
    end;
    bitmapType := WTSAT_ARGB;
    AStream := TIStreamAdapter.Create(FIStream);
    try
      TLogPreview.Add('TComSVGThumbnailProvider.GetThumbnail LoadFromStream');
      FSVG.LoadFromStream(AStream);
      TLogPreview.Add('TComSVGThumbnailProvider.FSVG.Source '+FSVG.Source);
      LBitmap := TBitmap.Create;
      LBitmap.PixelFormat := pf32bit;
      if FLightTheme then
        LAntiAliasColor := clWhite
      else
        LAntiAliasColor := clWebDarkSlategray;
      LBitmap.Canvas.Brush.Color := ColorToRGB(LAntiAliasColor);
      LBitmap.SetSize(cx, cx);
      TLogPreview.Add('TComSVGThumbnailProvider.PaintTo start');
      FSVG.PaintTo(LBitmap.Canvas.Handle, TRectF.Create(0, 0, cx, cx));
      TLogPreview.Add('TComSVGThumbnailProvider.PaintTo end');
      hBitmap := LBitmap.Handle;
    finally
      AStream.Free;
    end;
    Result := S_OK;
  except
    on E: Exception do
    begin
      Result := E_FAIL;
      TLogPreview.Add(Format('Error in TComSVGThumbnailProvider.GetThumbnail - Message: %s: Trace %s',
        [E.Message, E.StackTrace]));
    end;
  end;
end;

function TComSVGThumbnailProvider.IInitializeWithStream_Initialize(
  const pstream: IStream; grfMode: Cardinal): HRESULT;
begin
  TLogPreview.Add('TComSVGThumbnailProvider.IInitializeWithStream_Initialize Init');
  Initialize_GDI;
  FIStream := pstream;
  //FMode := grfMode;
  Result := S_OK;
  //Result := E_NOTIMPL;
  if Result = S_OK then
  begin
    FSVG := GlobalSVGFactory.NewSvg;
    FLightTheme := IsWindowsAppThemeLight;
  end;
  TLogPreview.Add('TComSVGThumbnailProvider.IInitializeWithStream_Initialize done');
end;

function TComSVGThumbnailProvider.Unload: HRESULT;
begin
  TLogPreview.Add('TComSVGThumbnailProvider.Unload Init');
  Finalize_GDI;
  result := S_OK;
  TLogPreview.Add('TComSVGThumbnailProvider.Unload Done');
end;

{ TFEThumbnailProvider }

class function TFEThumbnailProvider.GetComClass: TComClass;
begin
  Result := TComSVGThumbnailProvider;
end;

class procedure TFEThumbnailProvider.RegisterThumbnailProvider(
  const AClassID: TGUID; const AName, ADescription: string);
begin
  TLogPreview.Add('TFEThumbnailProvider.RegisterThumbnailProvider Init ' + AName);
  TThumbnailHandlerRegister.Create(Self, AClassID, AName, ADescription);
  TLogPreview.Add('TFEThumbnailProvider.RegisterThumbnailProvider Done ' + AName);
end;

end.


