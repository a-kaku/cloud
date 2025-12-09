from survey import AnonymousSurvey
question = "What launguage did you first learn to speak?"
language_survey = AnonymousSurvey(question)

language_survey.show_question()
print("Enter 'q' at any time to quit.\n")
while True:
    response = input("Language:")
    if response == 'q':
        break
    else:
        language_survey.store_responese(response)

language_survey.show_responese()