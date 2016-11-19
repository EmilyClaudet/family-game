dialogue = {}

dialogue.emily = {
  lines = {
    "Hello my Booboo.",
    "How are you today?",
    "I'm hungry. Can I eat you?"
  },
  decision = {
    topchoice = "yes",
    bottomchoice = "no",
    topresponse = {"Oh really?","I will come to get you soon then!"},
    bottomresponse = {"But why not my Booboo?","You look so tasty."}
  },
  question = true
}

dialogue.catherine = {
  lines = {
    "Won my leetal!",
    "You are so precious my Boobooru desu ka. Do you know how much I love this?"
  },
  question = false
}

dialogue.christopher = {
  lines = {
    "MERLIN.",
    "How is the demon dermon?"
  },
  decision = {
    topchoice = "good",
    bottomchoice = "not good",
    topresponse = {"Aww love this ever!"},
    bottomresponse = {"Oh no why not ever?"}
  },
  question = true
}

dialogue.mark = {
  lines = {
    "The smallest Anthony.",
    "Did you gain weight?"
  },
  decision = {
    topchoice = "yes",
    bottomchoice = "no",
    topresponse = {"Well done the smallest.","I'm proud of you."},
    bottomresponse = {"Oh but Anthony, why?","You must be fat."}
  },
  question = true
}

return dialogue
