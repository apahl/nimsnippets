# Nim Snippets
A collection of useful [Nim](http://www.nim-lang.org) snippets.<br>
Each snippet containing an assert statement is a viable minimal program.

## Compile-Time
### Source Filename
Get the source filename at compile-time:

```Nim
template filename: string = instantiationInfo().filename
assert(filename != "")
```

## Overloading
### Overloading Curly Braces
Used in the example to assign to a seq at a certain position.
This could of course also be achieved by simply using the [] notation.

```Nim
proc `{}=`(s: var seq[int], idx: int, val: int) =
  s[idx] = val

var a = @[1, 2, 3, 4, 5]
a{2} = 16

assert(a == @[1, 2, 16, 4, 5])
```
