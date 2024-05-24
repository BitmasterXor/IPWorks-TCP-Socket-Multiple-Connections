unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, scControls, ipwcore,
  ipwtypes, ipwtcpserver, generics.Collections, Vcl.Menus;

type
  TForm1 = class(TForm)
    scListView1: TscListView;
    scStatusBar1: TscStatusBar;
    serversocket: TipwTCPServer;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    S2: TMenuItem;
    procedure serversocketDataIn(Sender: TObject; ConnectionId: Integer;
      Text: string; TextB: TBytes; EOL: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure serversocketDisconnected(Sender: TObject;
      ConnectionId, StatusCode: Integer; const Description: string);
    procedure S1Click(Sender: TObject);
    procedure S2Click(Sender: TObject);
  private
    ClientList: TDictionary<string, Integer>;
    procedure BroadcastMessage(const Msg: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BroadcastMessage(const Msg: string);
var
  ClientPair: TPair<string, Integer>;
begin
  try
    for ClientPair in ClientList do
    begin
    serversocket.Send(ClientPair.Value, BytesOf(Msg));
    end;
  finally
    // No Action Required Here!
  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientList := TDictionary<string, Integer>.Create;
  self.serversocket.LocalPort := 3434;
  self.serversocket.Listening := true;
  self.scStatusBar1.Panels[0].Text := 'Server Status: Online!';
end;

procedure TForm1.S1Click(Sender: TObject);
begin
  BroadcastMessage('MSG To ALL!');
end;

procedure TForm1.S2Click(Sender: TObject);
begin
  if self.scListView1.Selected = nil then
    exit;

  if ClientList.ContainsKey(self.scListView1.Selected.SubItems[0]) then
    serversocket.Send(ClientList[self.scListView1.Selected.SubItems[0]],
      BytesOf('MSG Only To YOU!'))
  else
    // do nothing!
end;

procedure TForm1.serversocketDataIn(Sender: TObject; ConnectionId: Integer;
  Text: string; TextB: TBytes; EOL: Boolean);
var
  sl: Tstringlist;
  li: Tlistitem;
begin
  try
    sl := Tstringlist.Create;
    sl.Delimiter := '|';
    sl.StrictDelimiter := true;
    sl.DelimitedText := stringof(TextB);

    if sl[0] = 'NewCon' then
    begin
      // add connected user to our internal list of connections for later use...
      if not ClientList.ContainsKey(sl[1]) then
      begin
        ClientList.Add(sl[1], ConnectionId);
        li := self.scListView1.Items.Add;
        li.Caption := self.serversocket.Connections[ConnectionId].RemoteHost;
        li.SubItems.Add(sl[1]);
        self.scStatusBar1.Panels[1].Text := 'Clients Online [' +
          inttostr(self.serversocket.ConnectionCount) + ']';
      end;

    end;

  finally
    sl.Free;
  end;

end;

procedure TForm1.serversocketDisconnected(Sender: TObject;
  ConnectionId, StatusCode: Integer; const Description: string);
var
  Nickname: string;
  li: Tlistitem;
begin
  // Find the nickname associated with the ConnectionId
  Nickname := '';
  for Nickname in ClientList.Keys do
  begin
    if ClientList[Nickname] = ConnectionId then
      Break;
  end;

  // Remove the client from the ListView
  for li in scListView1.Items do
  begin
    if li.SubItems[0] = Nickname then
    begin
      li.Delete;
      Break; // Exit the loop once the item is found and deleted
    end;
  end;

  // Remove the client from the ClientList
  if Nickname <> '' then
    ClientList.Remove(Nickname);

  // Update the status bar
  scStatusBar1.Panels[1].Text := 'Clients Online [' +
    inttostr(serversocket.ConnectionCount) + ']';
end;

end.
