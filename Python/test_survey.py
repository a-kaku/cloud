import pytest
from survey import AnonymousSurvey

@pytest.fixture
def language_survey():
    question = 'What language did you learn to speak?'
    language_survey = AnonymousSurvey(question)
    return language_survey

def test_store_single_response(language_survey):
    # responses = ['English','Chinese','Japenese']
    # for response in responses:
    #     language_survey.store_responese(response)
    # assert 'English' in language_survey.response