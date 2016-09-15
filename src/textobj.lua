
textobj = {}

function textobj.attributes()
  lines = {
    "Hello my Booboo",
    "How are you today?",
    "I'm hungry. I'm going to eat you."
  }
  lineLength = {}
  for i,v in ipairs(lines) do
    table.insert(lineLength,v)
  end

  return {
    lines = lines,
    numberofLines = #lines,
    lineLength = lineLength,
    color = {255,255,255}
  }
end

return textobj
