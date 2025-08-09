// SPDX-License-Identifier: MIT

pragma experimental ABIEncoderV2;

pragma solidity >=0.6.0 <0.9.0;

contract ticket {
    struct User {
        string role;
        string name;
        string[] questions;
        string[] answers;
        uint256 userId;
    }

    struct Question {
        string question;
        uint256 userIdQuestioner;
        uint256 questionId;
        string tagQuestion;
    }

    struct Answer {
        string answer;
        uint256 userId;
        uint256 questionId;
    }

    //  dynamic arrays of type User, Question, answers
    User[] public users;
    Question[] public questions;
    Answer[] public answers;

    //  help to get questions and answers numbers
    mapping(uint256 => uint256) public userQuestionCount;
    mapping(uint256 => uint256) public userAnswerCount;

    constructor() {
        string[] memory initialQuestions = new string[](1); // Cria um array de strings na memória com tamanho 1
        initialQuestions[0] = "What is the capital of Germany"; // Atribui a string ao primeiro elemento

        questions.push(Question(initialQuestions[0], 1, 1, "countries"));
        users.push(
            User("admin", "Tiago", initialQuestions, new string[](0), 1)
        );
        // Inicializa as contagens para o primeiro utilizador no mapping
        userQuestionCount[1] = 1; // O utilizador com ID 1 tem 1 pergunta inicial
        userAnswerCount[1] = 0; // O utilizador com ID 1 tem 0 respostas iniciais
    }

    //  function to retrieve all questions from one specific user
    function retrieveQuestionsFrom(
        uint256 _userIdQuestioner
    ) public view returns (string[] memory) {
        uint256 count = 0;

        for (uint i = 0; i < questions.length; i++) {
            if (questions[i].userIdQuestioner == _userIdQuestioner) {
                count++;
            }
        }

        //  create an empty array of size number of the questions of a specific user
        string[] memory allQuestions = new string[](count);
        uint index = 0;

        //  fill the array with user questions
        for (uint i = 0; i < questions.length; i++) {
            if (questions[i].userIdQuestioner == _userIdQuestioner) {
                allQuestions[index] = questions[i].question;
                index++;
            }
        }

        return allQuestions;
    }

    //  function to add a new question and associate it with a user
    function addNewQuestion(
        string memory _question,
        uint256 _userIdQuestioner,
        string memory _tagQuestion
    ) public {
        uint256 indexUser; //  store user index
        uint256 nextQId = questions.length + 1;
        bool userExist = false; //  bool to store the existence of the inserted user

        for (uint i = 0; i < users.length; i++) {
            if (users[i].userId == _userIdQuestioner) {
                indexUser = i;
                userExist = true;
                break;
            }
        }

        require(
            userExist == true,
            "This user does not exist, please complete registration first"
        );

        //  insert new question in the questions Question array
        questions.push(
            Question(_question, _userIdQuestioner, nextQId, _tagQuestion)
        );

        //  create a temporary empty array to store questions from the inserted user
        string[] memory storeQuestions = new string[](
            users[indexUser].questions.length + 1
        );

        for (uint i = 0; i < users[indexUser].questions.length; i++) {
            storeQuestions[i] = users[indexUser].questions[i];
        }

        //  push the questions in the user array
        storeQuestions[storeQuestions.length - 1] = _question;

        ///  update questions array
        users[indexUser].questions = storeQuestions;

        // Incrementa a contagem de perguntas para o utilizador que fez a pergunta
        userQuestionCount[_userIdQuestioner]++;
    }

    //  Function to add a new answer and associate it with a user
    function addNewAwnser(
        string memory _answer,
        uint256 _userId,
        uint256 _questionId
    ) public {
        //  check if user and questions exists
        uint256 userIndex = 0;
        bool userExist = false;
        bool questionExist = false;

        for (uint i = 0; i < users.length; i++) {
            if (users[i].userId == _userId) {
                userExist = true;
                userIndex = i;
                break;
            }
        }

        for (uint i = 0; i < questions.length; i++) {
            if (questions[i].questionId == _questionId) {
                questionExist = true;
                break;
            }
        }

        require(
            userExist == true &&
                _userId > 0 &&
                questionExist == true &&
                _questionId > 0,
            "Invalid user or question ID"
        );

        //  insert new answer in the answer array
        answers.push(Answer(_answer, _userId, _questionId));

        // Incrementa a contagem de respostas para o utilizador que deu a resposta
        userAnswerCount[_userId]++;

        //  get answers of questionId inserted
        string[] memory userAnswers;
        uint256 numAnswers = 0;

        for (uint i = 0; i < questions.length; i++) {
            if (questions[i].questionId == _questionId) {
                numAnswers++;
            }
        }

        userAnswers = new string[](numAnswers);

        //  create a temporary empty array to store answers from the inserted user
        string[] memory storeAnswers = new string[](
            users[userIndex].answers.length + 1
        );

        for (uint i = 0; i < users[userIndex].answers.length; i++) {
            storeAnswers[i] = users[userIndex].answers[i];
        }

        //  push the questions in the user array
        storeAnswers[storeAnswers.length - 1] = _answer;

        ///  update questions array
        users[userIndex].questions = storeAnswers;
    }

    //  function to add new user
    function addNewUser(
        string memory _userRole,
        string memory _userName
    ) public {
        uint256 userId = users.length + 1;
        string[] memory userQuestions; //  empty array of questions
        string[] memory userAnswers; //  empty array of answers

        users.push(
            User(_userRole, _userName, userQuestions, userAnswers, userId)
        );

        // Inicializa as contagens para o novo utilizador
        userQuestionCount[userId] = 0;
        userAnswerCount[userId] = 0;
    }

    function retrieveAllQA(
        uint256 _userId
    ) public view returns (string[] memory, string[] memory) {
        //  check if userId exists
        bool userExists = false;

        for (uint i = 0; i < users.length; i++) {
            if (users[i].userId == _userId) {
                userExists = true;
                break;
            }
        }

        require(
            userExists == true && _userId > 0,
            "This userId does not exist"
        );

        //  initialize the arrays with the correct size
        string[] memory userQuestions;
        string[] memory userAnswers;
        uint256 numQuestions = 0;
        uint256 numAnswers = 0;

        //  count questions for the specific user
        for (uint i = 0; i < questions.length; i++) {
            if (questions[i].userIdQuestioner == _userId) {
                numQuestions++;
            }
        }

        //  count answers fot the specific user
        for (uint i = 0; i < answers.length; i++) {
            if (answers[i].userId == _userId) {
                numAnswers++;
            }
        }

        //  start dynamic arrays
        userQuestions = new string[](numQuestions);
        userAnswers = new string[](numAnswers);

        //  populate the users question
        uint256 questionIndex = 0;
        for (uint i = 0; i < questions.length; i++) {
            if (questions[i].userIdQuestioner == _userId) {
                userQuestions[questionIndex] = questions[i].question;
                questionIndex++;
            }
        }

        //  populate the users question
        uint256 answersIndex = 0;
        for (uint i = 0; i < answers.length; i++) {
            if (answers[i].userId == _userId) {
                userAnswers[answersIndex] = answers[i].answer;
                answersIndex++;
            }
        }

        return (userQuestions, userAnswers);
    }

    function returnNumQA(
        uint256 _userId
    ) public view returns (uint256, uint256) {
        //  check if user exists
        bool userExist = false;
        for (uint i = 0; i < users.length; i++) {
            if (users[i].userId == _userId) {
                userExist = true;
                break;
            }
        }
        require(userExist == true, "This user does not exist");

        // Retorna as contagens diretamente dos mappings
        return (userQuestionCount[_userId], userAnswerCount[_userId]);
    }

    function returnAnswersFrom(
        uint256 _questionId
    ) public view returns (Answer[] memory) {
        require(_questionId > 0, "This questions does not exist!");

        //   count answers for a specific question
        uint256 count = 0;
        for (uint i = 0; i < questions.length; i++) {
            if (answers[i].questionId == _questionId) {
                count++;
            }
        }

        //   create an array to store answers
        Answer[] memory answersQuestion = new Answer[](count);
        uint256 index = 0;

        //   fil the array with answers from the specific question
        for (uint i = 0; i < answers.length; i++) {
            if (answers[i].questionId == _questionId) {
                answersQuestion[index] = answers[i];
                index++;
            }
        }

        return answersQuestion;
    }
}
