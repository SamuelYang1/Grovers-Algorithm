using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.IO;
using System.Diagnostics;
namespace Quantum.Grover_n
{
    class Driver
    {
        static int cal(int N)
        {
            double theta = Math.Asin(2 * Math.Sqrt(N - 1) / N);
            int r = (int)Math.Round((Math.Acos(Math.Sqrt(1.0 / N)) / theta));
            //System.Console.WriteLine($"{(Math.Acos(Math.Sqrt(1.0 / N)) / theta)}");
            return r;
        }
        static int ClassicSearch(int N)
        {
            int ans = -1;
            for (int i = 0; i <= N - 1; i++)
            {
                ans = ans + 1;
                if (ans == N - 1)
                {
                    return ans;
                }
            }
            return ans;
        }
        static void Main(string[] args)
        {
            Stopwatch s = new Stopwatch(), s2 = new Stopwatch(), s3 = new Stopwatch();

            using (var sim = new QuantumSimulator())
            {
                for (int n = 3; n <= 30; n++)
                {
                    /*String ss = "D:/Quantum/TimeOut/Time" + n + ".txt";
                    StreamWriter sw = new StreamWriter(@ss);
                    Console.SetOut(sw);*/
                    int N = (int)Math.Pow(2, n);
                    s.Start();
                    int re = cal(N);
                    //System.Console.WriteLine($"{re},{N}");
                    var res = Search.Run(sim, n, re, N - 1).Result;
                    s.Stop();
                    s2.Start();
                    //var res2 = ClassicSearch.Run(sim,N).Result;
                    var res2 = ClassicSearch(N);
                    s2.Stop();
                    s3.Start();
                    var res3 = ClassicSearchStandard.Run(sim, n, N).Result;
                    s3.Stop();
                    System.Console.WriteLine($"{N},{s.ElapsedTicks},{s2.ElapsedTicks},{s3.ElapsedTicks},{res},{res2},{res3}");
                    //System.Console.WriteLine($"{N},{res}");
                    /*sw.Flush();
                    sw.Close();*/
                }
            }
        }
    }
}