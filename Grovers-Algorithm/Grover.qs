namespace Quantum.Grover_n
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
	open Microsoft.Quantum.Extensions.Math;
	operation Set (desired: Result, q1: Qubit) : ()
    {
        body
        {
            let current = M(q1);
            if (desired != current)
            {
                X(q1);
            }
        }
    }
	operation Oracle(q:Qubit[],n:Int):()
	{
		body
		{	
			using (w=Qubit[n-1])
			{
				mutable j=n-1;
				for (i in 0..n-2)
				{
					Set(Zero,w[i]);
				}
				//X(q[n-1]);
				CCNOT(q[0],q[1],w[0]);
				for (i in 1..n-2)
				{
					CCNOT(q[i+1],w[i-1],w[i]);
				}			
				CNOT(w[n-2],q[n]);
				for (i in 1..n-2)
				{
					set j=j-1;
					CCNOT(q[j+1],w[j-1],w[j]);
				}			
				CCNOT(q[0],q[1],w[0]);
				//X(q[n-1]);
				for (i in 0..n-2)
				{
					Set(Zero,w[i]);
				}
			}
		}
	}
	operation Phase(q:Qubit[],n:Int):()
	{
		body
		{
			for (i in 0..n-1)
			{
				X(q[i]);
			}
			using (w=Qubit[n-2])
			{
				mutable j=n-2;
				for (i in 0..n-3)
				{
					Set(Zero,w[i]);
				}
				CCNOT(q[0],q[1],w[0]);
				for (i in 1..n-3)
				{
					CCNOT(q[i+1],w[i-1],w[i]);
				}			
				H(q[n-1]);
				CNOT(w[n-3],q[n-1]);
				H(q[n-1]);
				for (i in 1..n-3)
				{
					set j=j-1;
					CCNOT(q[j+1],w[j-1],w[j]);
				}			
				CCNOT(q[0],q[1],w[0]);
				for (i in 0..n-3)
				{
					Set(Zero,w[i]);
				}
			}
			for (i in 0..n-1)
			{
				X(q[i]);
			}
		}
	}
	operation Grover(q:Qubit[],n:Int):()
	{
		body
		{
			Oracle(q,n);
			for (i in 0..n-1)
			{
				H(q[i]);
			}
			Phase(q,n);
			for (i in 0..n-1)
			{
				H(q[i]);
			}
		}
	}
	
	operation Search(n:Int,re:Int,ans:Int):(Int)
	{
		body
		{
			mutable num=0;
			mutable nn=0;
			using (q=Qubit[n+1])
			{
				for (t in 1..1)
				{
					set num=0;
					for (i in 0..n-1)
					{
						Set(Zero,q[i]);
						H(q[i]);
					}
					Set(One,q[n]);
					H(q[n]);
					for (i in 1..re)
					{
						Grover(q,n);
					}
					for (i in 0..n-1)
					{
						set num=num*2;
						let res=M(q[i]);	
						if (res==One)
						{
							set num=num+1;
						}
					}
					if (num==ans-1)
					{
						set nn=nn+1;
					}
					ResetAll(q);
				}
			}
			return num;
		}
	}
	operation ClassicSearch(N:Int):(Int)
	{
		body
		{
			mutable ans=-1;
			for (i in 0..N-1)
			{
				set ans=ans+1;
				if (ans==N-1) 
				{
					return ans;
				}
			}
			return ans;
		}
	}
	operation ClassicSearchStandard(n:Int,N:Int):(Int)
	{
		body
		{
			mutable ans=-1;
			using (q=Qubit[n+1])
			{
				for (i in 0..N-1)
				{
					mutable k=i;
					for (j in 0..n-1)
					{
						if (k%2==0)
						{
							Set(Zero,q[j]);
						}
						else
						{
							Set(One,q[j]);
						}
						set k=k/2;
					}
					Set(Zero,q[n]);
					Oracle(q,n);
					let state=M(q[n]);
					if (state==One)
					{
						set ans=i;
					}
				}
				for (i in 0..n)
				{
					Set(Zero,q[i]);
				}
			}
			return ans;
		}
	}
}