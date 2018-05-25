from sievelib.parser import Parser
import sys

p = Parser()

input = sys.stdin.read().strip()

if input == "":
    print("🤔 File was empty")
    exit(1)

result = p.parse(input)

if not result:
    print("☠️ Error: " + p.error)
    exit(2)

print("👍 File looks good")
exit(0)
