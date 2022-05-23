# mastermind
The Odin Project´s Mastermind project in ruby

# Assignment
Build a Mastermind game from the command line where you have 12 turns to guess the secret code, starting with you guessing the computer’s random code.

# Goal
- Build the basic game where the computer generates a random code to be cracked by the human player.
- Add creator/guesser option for human player.
- Create code so the computer will try to guess when a human player chooses the code.
- Either create new rules or follow the rules of the game. In any case, try to implement a good strategy for the computer when playing the game.

# Expectations and challenges
- After the tic-tac-toe game this seems a bit like more of the same, but I'm sure there are some challenges I'm not seeing just yet.
- Probably gonna create a player class which then can be used in making a human player or computer player class.
- Have to research how to get random samples from the array of available colours. Class game might be used for this.
- Probably make the rules clear from the start.
- Think of a smart way to do input that make sense and convert that to something useful for the code so it can be compared.
- Somehow use a tracker during evaluation for keeping the number of correct colours and locations
- Human input for becoming a creator seems trivial.
- Creating the computer strategy might require a lot of conditionals and branching. Gonna be challenging to find out the best strategy and then convert that to working code that doesn't become a giant mess.

# Results and Evaluation
- The basics were definitely similar, though clearly adding an option for computer play is different. I should have probably moved a lot of code out of the Game class and into either the Player class or its descendants. Finding the right way to implement the checks was a challenge as well. Trying to find the perfect solution, again, cost more time than it should have, though I feel like I've learned the limitations of working and checking arrays with that for sure.
- Should have done that I guess.
- This turned out to be a relatively easy solution.
- This helped a lot, comment now removed from code.
- Went for the lazy simple approach to have seperate entries for each position, all checked seperately, which the code then turns into an array which can be easily compared to the other arrays in the code.
- Once I wrote out the steps of the process in my head, it was fairly obvious how to do this in code.
- It was
- This was an interesting experience, going on a semi deep dive on wikipedia about minimax theory and so on. Eventually, for simplicity's sake, went with checking the guess against all possible codes and then selecting the ones which have the correct corresponding result. All other solutions quickly became madness indeed.

# Notes for future revisiting
- Seperate code out from Game class to Player classes.
- Implement using abbrevations for typing the colors.
- Implement options for hints for human play.
- Add options for difficulty level, both for computer play and human play
- Add flexibility for number of colors and positions
- Add options for 2 human players playing against each other in turns?
- Create deeper/more efficient strategies for Computer to guess in fewer turns.
