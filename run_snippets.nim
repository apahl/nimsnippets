import osproc,
       re,
       strutils

type FailedSnippet = tuple[snippetNo: int, output:string]

const baseCmd = "nim --cc:tcc --verbosity:0 --hints:off -r "

proc loadReadme(fn="README.md"): string =
  result = fn.open.readAll

proc extractSnippets(readme: var string): seq[string] =
  result = @[]
  let reSnippet = re("""```Nim.*?```""", flags={reDotAll, reExtended, reStudy})
  let snippets = re.findAll(readme, reSnippet)
  for snippet in snippets:
    result.add(snippet[7..^5])

proc compileFlags(snippet: string): string =
  result = " "
  if snippet.startsWith("#flags:"):
    let line = snippet.splitLines[0]
    result = line[7..line.high] & " "

proc writeSnippet(snippet: string) =
  let f = open("snippet.nim", fmWrite)
  f.write(snippet)
  f.close

proc runSnippet(snippet: string): string =
  result = ""
  # let result = execCmdEx("ls") (-> tuple[output: TaintedString, exitCode: int])
  writeSnippet(snippet)
  let compileCmd = baseCmd & compileFlags(snippet) & "c snippet.nim"
  let execResult = execCmdEx(compileCmd)
  if execResult.exitCode != 0:
    result = execResult.output

when isMainModule:
  var
    readme = loadReadme()
    failedSnippets: seq[FailedSnippet] = @[]
  let
    snippets = extractSnippets(readme)
  echo ""
  echo "Running Snippets..."
  for idx, snippet in snippets:
    let
      spc = if idx < 9: " " else: ""
      res = runSnippet(snippet)
    var msg: string
    if res.len == 0:
      msg = ": success."
    else:
      msg = ": FAILED!"
      let failedSnippet: FailedSnippet = (idx+1, res)
      failedSnippets.add(failedSnippet)
    echo "Snippet #", spc, idx+1, msg
    # echo snippet
    # echo "――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――"

  if failedSnippets.len > 0:
    echo "\n\nFailed Snippets:"
    for failedSnippet in failedSnippets:
      echo "Snippet #", failedSnippet.snippetNo, ":"
      echo failedSnippet.output
      echo "――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――"