import re

proc loadReadme(fn="README.md"): string =
  result = fn.open.readAll

proc extractSnippets(readme: var string): seq[string] =
  result = @[]
  let reSnippet = re("""```Nim.*?```""", flags={reDotAll, reExtended, reStudy})

  let snippets = re.findAll(readme, reSnippet)

  for snippet in snippets:
    result.add(snippet[7..^5])

proc writeSnippet(snippet: string) =
  discard

proc runSnippet(): bool =
  # let result = execCmdEx("ls") (-> tuple[output: TaintedString, exitCode: int])
  discard

when isMainModule:
  var readme = loadReadme()
  let snippets = extractSnippets(readme)
  for idx, snippet in snippets:
    echo "Running snippet #", idx+1, " ..."
    echo snippet
    echo "------------------"
