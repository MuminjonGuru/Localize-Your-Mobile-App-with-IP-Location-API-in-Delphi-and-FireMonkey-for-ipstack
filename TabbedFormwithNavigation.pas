unit TabbedFormwithNavigation;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Gestures, System.Actions, FMX.ActnList, System.Skia, FMX.Skia,
  FMX.Objects,
  FMX.Effects, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TTabbedwithNavigationForm = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabControl2: TTabControl;
    TabItem5: TTabItem;
    ToolBar1: TToolBar;
    lblTitle1: TLabel;
    btnNext: TSpeedButton;
    TabItem6: TTabItem;
    ToolBar2: TToolBar;
    lblTitle2: TLabel;
    btnBack: TSpeedButton;
    TabItem2: TTabItem;
    ToolBar3: TToolBar;
    lblTitle3: TLabel;
    TabItem3: TTabItem;
    ToolBar4: TToolBar;
    lblTitle4: TLabel;
    TabItem4: TTabItem;
    ToolBar5: TToolBar;
    lblTitle5: TLabel;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    Label1: TLabel;
    CalloutRectangle1: TCalloutRectangle;
    ShadowEffect1: TShadowEffect;
    SpeedButton1: TSpeedButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    Label2: TLabel;
    Lang1: TLang;
    Label3: TLabel;
    Label4: TLabel;
    StyleBook1: TStyleBook;
    procedure GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    FGlobalCountryCode: String;

    procedure GetCountry;
  public
    { Public declarations }
  end;

var
  TabbedwithNavigationForm: TTabbedwithNavigationForm;

implementation

{$R *.fmx}

uses
  System.JSON;

procedure TTabbedwithNavigationForm.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl1.ActiveTab := TabItem1;
end;

procedure TTabbedwithNavigationForm.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then
  begin
    if (TabControl1.ActiveTab = TabItem1) and (TabControl2.ActiveTab = TabItem6)
    then
    begin
      TabControl2.Previous;
      Key := 0;
    end;
  end;
end;

procedure TTabbedwithNavigationForm.GestureDone(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    sgiLeft:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount - 1]
        then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex + 1];
        Handled := True;
      end;

    sgiRight:
      begin
        if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
          TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex - 1];
        Handled := True;
      end;
  end;
end;

procedure TTabbedwithNavigationForm.GetCountry;
begin
  // init parameters
  RESTClient1.ResetToDefaults;
  RESTClient1.Accept := 'application/json';
  RESTClient1.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient1.BaseURL := Format('http://api.ipstack.com/check?access_key=%s',
    ['afd8c877c16bbb9da45e20b2edc90ea3']);

  // send API endpoint request
  RESTRequest1.Execute;

  // parse the country code from the response
  var JSONValue := TJSONObject.ParseJSONValue(RESTResponse1.Content);
  try
    if JSONValue is TJSONObject then
    begin
      Label1.Text := 'You are from: ' + JSONValue.GetValue<String>
        ('country_code');
      FGlobalCountryCode := JSONValue.GetValue<String>('country_code');
    end;
  finally
    JSONValue.Free;
  end;
end;

procedure TTabbedwithNavigationForm.SpeedButton1Click(Sender: TObject);
begin
  // lookup via IP address
  GetCountry;

  // check the global property for country code
  if FGlobalCountryCode.Equals('FR') then
  begin
    LoadLangFromStrings(Lang1.LangStr['FR']);
  end
  else if FGlobalCountryCode.Equals('UZ') then
  begin
    LoadLangFromStrings(Lang1.LangStr['UZ'])
  end;
end;

end.
