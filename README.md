# Nim Snippets
A collection of useful and instructive [Nim](https://www.nim-lang.org) snippets.<br>
Each snippet is a viable minimal program.<br>
The snippets are regularly run with the latest compiler by the `run_snippets` program.<br>
If additional flags need to be passed to the compiler for the snippet to compile and run, they can be passed as comment in the first line of the snippet, like this: `#flags:--threads:on` .

## Uniform Function Call Syntax (UFCS)
Nim's procedures can be called in multiple ways:<br>
`echo(5)` is the same as `echo 5` and as `5.echo`.

Some interesting applications of this:

### Use as Value Units
```Nim
proc m(x: float): float = x
proc cm(x: float): float = x / 100

assert(1.m == 100.cm)
```

## Compile-Time
### Source Filename
Get the source filename at compile-time:

```Nim
template filename: string = instantiationInfo().filename
assert(filename == "snippet.nim")
```

## Overloading
### Overloading Parameters
```Nim
proc toString(x: int): string =
  if x > 0: result = "true"
  else: result = "false"

proc toString(x: bool): string =
  if x: result = "true"
  else: result = "false"

assert(toString(13) == "true")   # calls the toString(x: int) proc
assert(toString(true) == "true") # calls the toString(x: bool) proc
```

### Overloading Operators
Use the curly braces in the example to assign to a seq at a certain position.
This could of course also be achieved by simply using the [] notation.

```Nim
proc `{}=`(s: var seq[int], idx: int, val: int) =
  s[idx] = val

var a = @[1, 2, 3, 4, 5]
a{2} = 16

assert(a == @[1, 2, 16, 4, 5])
```
