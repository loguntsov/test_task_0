# Test

In Erlang. Let all functions be separate processes. You have a function f that given input x as in f(x) computes sin(x) or else tan(x) after receiving (x,sin) or (x,tan) as a message. It sends the result as a message to a function g. There are also functions h and k, which are not sent anything. g(x) is x hashed with sha256. g prints the result. h(x) is x + 17 hashed with sha256. h prints the result. k(x) is x/5 hashed with sha256. k prints the result. Now let function f be defined such that you can also send a message rand([h,k]) to it. Then it will send the **next** and only the **next** result it computed randomly to h or to k instead of to g. In other words, if the input to f message rand([h,k]) precedes an input to f message (x,sin), for example, f will then send sin(x) randomly to h or else k, as indicated, **not** to g. But after **that** it will **default** back to sending whatever it computes next to g.

# Notes

To start you should run:

```make run```

After that you can use function provided by modules: f, g, h, k.

```
f:calc(x, tan).
f:rand([h, k]).
f:calc(x, sin).
f:calc(x, fun(X) -> X+ 1 end). % as example of universal function
```

rebar3 should be installed in system.