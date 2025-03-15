# Problem Set 2, hangman.py
# Name:
# Collaborators:
# Time spent:

import random
import string

# -----------------------------------
# HELPER CODE
# -----------------------------------

WORDLIST_FILENAME = "words.txt"

def load_words():
    """
    returns: list, a list of valid words. Words are strings of lowercase letters.

    Depending on the size of the word list, this function may
    take a while to finish.
    """
    print("Loading word list from file...")
    # inFile: file
    inFile = open(WORDLIST_FILENAME, 'r')
    # line: string
    line = inFile.readline()
    # wordlist: list of strings
    wordlist = line.split()
    print(" ", len(wordlist), "words loaded.")
    return wordlist

def choose_word(wordlist):
    """
    wordlist (list): list of words (strings)

    returns: a word from wordlist at random
    """
    return random.choice(wordlist)

# -----------------------------------
# END OF HELPER CODE
# -----------------------------------


# Load the list of words to be accessed from anywhere in the program
wordlist = load_words()

def has_player_won(secret_word, letters_guessed):
    """
    secret_word: string, the lowercase word the user is guessing
    letters_guessed: list (of lowercase letters), the letters that have been
        guessed so far

    returns: boolean, True if all the letters of secret_word are in letters_guessed,
        False otherwise
    """
    # FILL IN YOUR CODE HERE AND DELETE "pass"
    for i in range(len(secret_word)):
        if secret_word[i] not in letters_guessed:
            return False
    return True


def get_word_progress(secret_word, letters_guessed):
    """
    secret_word: string, the lowercase word the user is guessing
    letters_guessed: list (of lowercase letters), the letters that have been
        guessed so far

    returns: string, comprised of letters and asterisks (*) that represents
        which letters in secret_word have not been guessed so far
    """
    # FILL IN YOUR CODE HERE AND DELETE "pass"
    result = []
    for i in secret_word:
        if i in letters_guessed:
            result.append(i)
        else:
            result.append("*")
    return "".join(result)


def get_available_letters(letters_guessed):
    """
    letters_guessed: list (of lowercase letters), the letters that have been
        guessed so far

    returns: string, comprised of letters that represents which
      letters have not yet been guessed. The letters should be returned in
      alphabetical order
    """
    # FILL IN YOUR CODE HERE AND DELETE "pass"
    avail = []
    for i in string.ascii_lowercase:
        if i not in letters_guessed:
            avail.append(i)
    return "".join(avail)


def hangman(secret_word, with_help):
    """
    secret_word: string, the secret word to guess.
    with_help: boolean, this enables help functionality if true.

    Starts up an interactive game of Hangman.

    * At the start of the game, let the user know how many
      letters the secret_word contains and how many guesses they start with.

    * The user should start with 10 guesses.

    * Before each round, you should display to the user how many guesses
      they have left and the letters that the user has not yet guessed.

    * Ask the user to supply one guess per round. Remember to make
      sure that the user puts in a single letter (or help character '!'
      for with_help functionality)

    * If the user inputs an incorrect consonant, then the user loses ONE guess,
      while if the user inputs an incorrect vowel (a, e, i, o, u),
      then the user loses TWO guesses.

    * The user should receive feedback immediately after each guess
      about whether their guess appears in the computer's word.

    * After each guess, you should display to the user the
      partially guessed word so far.

    -----------------------------------
    with_help functionality
    -----------------------------------
    * If the guess is the symbol !, you should reveal to the user one of the
      letters missing from the word at the cost of 3 guesses. If the user does
      not have 3 guesses remaining, print a warning message. Otherwise, add
      this letter to their guessed word and continue playing normally.

    Follows the other limitations detailed in the problem write-up.
    """
    # FILL IN YOUR CODE HERE AND DELETE "pass"
    print("Welcome to Hangman!")
    print(f"I am thinking of a word that is {len(secret_word)} letters long")
    
    guesses = []
    remaining = 10
    while remaining > 0 and "*" in get_word_progress(secret_word, guesses):
        print("--------------")
        print(f"You have {remaining} guesses left.")
        print(f"Available letters: {get_available_letters(guesses)}")
        guess = input("Please guess a letter: ")
        if len(guess) == 1 and guess.isalpha(): #If single alphabet or !
            if guess in get_available_letters(guesses):
                if guess in secret_word:
                    guesses.append(guess)
                    print(f"Good guess: {get_word_progress(secret_word, guesses)}")
                elif guess in "aeiou":
                    print(f"Oops! That letter is not in my word: {get_word_progress(secret_word, guesses)}")
                    remaining -= 2
                    guesses.append(guess)
                else:
                    print(f"Oops! That letter is not in my word: {get_word_progress(secret_word, guesses)}")
                    remaining -= 1 
                    guesses.append(guess)
            else:
                print(f"Oops! You've already guessed that letter: {get_word_progress(secret_word, guesses)}")
        elif with_help and guess == "!":
            if remaining >= 3:
                remaining -= 3
                clueez = clue(secret_word, get_available_letters(guesses))
                guesses.append(clueez)
                print(f"Letter revealed: {clueez}")
                print(get_word_progress(secret_word, guesses))
            else:
                print(f"Oops! Not enough guesses left: {get_word_progress(secret_word, guesses)}")
        else:
            print(f"Oops! That is not a valid letter. Please input a letter from the alphabet: {get_word_progress(secret_word, guesses)}")

    unique = []
    for i in secret_word:
        if i not in unique:
            unique.append(i)

    print("--------------")
    if not "*" in get_word_progress(secret_word, guesses):
        print("Congratulations, you won!")
        score = (remaining + 4 * len(unique)) + 3 * len(secret_word)
        print(f"Your total score for this game is: {score}")
    else:
        print(f"Sorry, you ran out of guesses. The word was {secret_word}")
       
# When you've completed your hangman function, scroll down to the bottom
# of the file and uncomment the lines to test

def clue(secret_word, available):
    choose_from = []
    for i in range(len(secret_word)):
        if secret_word[i] in available:
            choose_from.append(secret_word[i])
    new = random.randint(0, len(choose_from)-1)
    revealed_letter = choose_from[new]
    return revealed_letter

if __name__ == "__main__":
    # To test your game, uncomment the following three lines.

    secret_word = choose_word(wordlist)
    with_help = True
    hangman(secret_word, with_help)

    # After you complete with_help functionality, change with_help to True
    # and try entering "!" as a guess!

    ###############

    # SUBMISSION INSTRUCTIONS
    # -----------------------
    # It doesn't matter if the lines above are commented in or not
    # when you submit your pset. However, please run ps2_student_tester.py
    # one more time before submitting to make sure all the tests pass.
    pass


    