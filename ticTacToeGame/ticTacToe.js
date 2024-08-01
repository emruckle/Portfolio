// ----------------------------------------------------------------------------------------------------------
// ticTacTow.js by Emma Ruckle
// funtionality for mega tic tac toe game written in javascript, html and css
// ----------------------------------------------------------------------------------------------------------

// miniBoard class
class miniBoard {
    constructor() {
        this.board = [
            ["","",""],
            ["","",""],
            ["","",""]
        ]
        this.winner = null;
    }
}

// array to assist with row column pair to cell number conversion
const rowColToNum = [
    [0,1,2],
    [3,4,5],
    [6,7,8]
]

// constructing 9 miniboard object, one for each cell of mega board
const miniBoard0 = new miniBoard();
const miniBoard1 = new miniBoard();
const miniBoard2 = new miniBoard();
const miniBoard3 = new miniBoard();
const miniBoard4 = new miniBoard();
const miniBoard5 = new miniBoard();
const miniBoard6 = new miniBoard();
const miniBoard7 = new miniBoard();
const miniBoard8 = new miniBoard();

// initialzing mega board array
const megaBoard = [
    miniBoard0,
    miniBoard1,
    miniBoard2,
    miniBoard3,
    miniBoard4,
    miniBoard5,
    miniBoard6,
    miniBoard7,
    miniBoard8
]

const moveStack = []; // storing each move in a stack for undo button functionality
var whichTurn = 1; // counter to keep track of which player's turn it is
var currentBoard = null; // board the player HAS to play in
var game = true; // true when game is active, false when a player wins

// called onclick when a player clicks a cell
function turn(board,row,col) {
    // if the player is not in the correct board or the game is over, do nothing
    if ((currentBoard != null && board != currentBoard) || game == false) {
       return;
    }
    // if the cell is empty
    if (megaBoard[board].board[row][col] == "") {
        moveStack.push(String(board)+String(row)+String(col)); // store the players move on the stack
        if (whichTurn % 2 == 0) { // if it was player 2
            playerText(); // update player text 
            document.getElementById("mini-flex-cell"+board+rowColToNum[row][col]).innerHTML = "O"; // update html
            document.getElementById("mini-flex-cell"+board+rowColToNum[row][col]).style.color = "#084B83";
            megaBoard[board].board[row][col] = "O"; // update megaboard
        }
        else { // player 1
            playerText(); 
            document.getElementById("mini-flex-cell"+board+rowColToNum[row][col]).innerHTML = "X";
            document.getElementById("mini-flex-cell"+board+rowColToNum[row][col]).style.color = "#FF66B3"
            megaBoard[board].board[row][col] = "X";
        }
        whichTurn++; // incremement turn counter
        if (megaBoard[board].winner == null) { // if the board the move was played in doesn't have a winner yet, check for a winner
            winCheck(megaBoard[board]);
        }
        if (megaBoard[board].winner == "X") { // if the winner is x, color megaboard cell pink
            document.getElementById("mini-flex-board"+board).style.background = "#F5E6E8";
        }
        else if (megaBoard[board].winner == "O") { // if the winner is 0, color megaboard cell blue
            document.getElementById("mini-flex-board"+board).style.background = "#BEE7E8";
        }
        document.getElementById("mini-flex-board"+board).style.border = "none"; // update the html to highlight the new current board
        document.getElementById("mini-flex-board"+rowColToNum[row][col]).style.border = "6px solid yellow";
        currentBoard = rowColToNum[row][col]; //update current board
        megaWinCheck(); // check if a player has won the megaboard
    }
}

// displays player text at the top of the screen
function playerText() {
    if (whichTurn % 2 == 0) {
        document.getElementById("player").innerHTML = "Player 1";
        document.getElementById("player").style.color = "#FF66B3";
    }
    else {
        document.getElementById("player").innerHTML = "Player 2";
        document.getElementById("player").style.color = "#084B83"
    }
}

// checks to see if someone has won miniBoardObject
function winCheck(miniBoardObject) {
    if (miniBoardObject.board[0][0] != "" && (miniBoardObject.board[0][0] == miniBoardObject.board[0][1] && miniBoardObject.board[0][1] == miniBoardObject.board[0][2])){
        miniBoardObject.winner = miniBoardObject.board[0][0];
    }
    else if ((miniBoardObject.board[1][0] != "") && (miniBoardObject.board[1][0] == miniBoardObject.board[1][1] && miniBoardObject.board[1][1] == miniBoardObject.board[1][2])) {
        miniBoardObject.winner = miniBoardObject.board[1][0];
    }
    else if ((miniBoardObject.board[2][0] != "") && (miniBoardObject.board[2][0] == miniBoardObject.board[2][1] && miniBoardObject.board[2][1] == miniBoardObject.board[2][2])) {
        miniBoardObject.winner = miniBoardObject.board[2][0];
    }
    else if ((miniBoardObject.board[0][0] != "") && (miniBoardObject.board[0][0] == miniBoardObject.board[1][0] && miniBoardObject.board[1][0] == miniBoardObject.board[2][0])) {
        miniBoardObject.winner = miniBoardObject.board[0][0];
    }
    else if ((miniBoardObject.board[0][1] != "") && (miniBoardObject.board[0][1] == miniBoardObject.board[1][1] && miniBoardObject.board[1][1] == miniBoardObject.board[2][1])) {
        miniBoardObject.winner = miniBoardObject.board[0][1];
    }
    else if ((miniBoardObject.board[0][2] != "") && (miniBoardObject.board[0][2] == miniBoardObject.board[1][2] && miniBoardObject.board[1][2] == miniBoardObject.board[2][2])) {
        miniBoardObject.winner = miniBoardObject.board[0][2];
    }
    else if ((miniBoardObject.board[0][0] != "") && (miniBoardObject.board[0][0] == miniBoardObject.board[1][1] && miniBoardObject.board[1][1] == miniBoardObject.board[2][2])) {
        miniBoardObject.winner = miniBoardObject.board[0][0];
    }
    else if ((miniBoardObject.board[0][2] != "") && (miniBoardObject.board[0][2] == miniBoardObject.board[1][1] && miniBoardObject.board[1][1] == miniBoardObject.board[2][0])) {
        miniBoardObject.winner = miniBoardObject.board[0][2];
    }
    else {
        miniBoardObject.winner = null; // if no one has won, returns null
    }
}

// checks to see if someone has won megaboard
function megaWinCheck() {
    if (miniBoard0.winner != null && miniBoard0.winner == miniBoard1.winner && miniBoard1.winner == miniBoard2.winner) {
        megaWinHighlight(0, 1, 2, miniBoard0.winner); // if someone has won, calls megaboard hightlight 
    }
    else if (miniBoard3.winner != null && miniBoard3.winner == miniBoard4.winner && miniBoard4.winner == miniBoard5.winner) {
        megaWinHighlight(3, 4, 5, miniBoard3.winner);
    }
    else if (miniBoard6.winner != null && miniBoard6.winner == miniBoard7.winner && miniBoard7.winner == miniBoard8.winner) {
        megaWinHighlight(6, 7, 8, miniBoard6.winner);
    }
    else if (miniBoard0.winner != null && miniBoard0.winner == miniBoard3.winner && miniBoard3.winner == miniBoard6.winner) {
        megaWinHighlight(0, 3, 6, miniBoard0.winner);
    }
    else if (miniBoard1.winner != null && miniBoard1.winner == miniBoard4.winner && miniBoard4.winner == miniBoard7.winner) {
        megaWinHighlight(1, 4, 7, miniBoard1.winner);
    }
    else if (miniBoard2.winner != null && miniBoard2.winner == miniBoard5.winner && miniBoard5.winner == miniBoard8.winner) {
        megaWinHighlight(2, 5, 8, miniBoard2.winner);
    }
    else if (miniBoard0.winner != null && miniBoard0.winner == miniBoard4.winner && miniBoard4.winner == miniBoard8.winner) {
        megaWinHighlight(0, 4, 8, miniBoard0.winner);
    }
    else if (miniBoard2.winner != null && miniBoard2.winner == miniBoard4.winner && miniBoard4.winner == miniBoard6.winner) {
        megaWinHighlight(2, 4, 6, miniBoard2.winner);
    }
}

// highlights the winning three boards in green, sets game mode to false and changes visibility of winning popup
function megaWinHighlight(board1, board2, board3, winner) {
    game = false;
    document.getElementById("mini-flex-board"+currentBoard).style.border = "none";
    document.getElementById("mini-flex-board"+board1).style.background = "#8bca84";
    document.getElementById("mini-flex-board"+board2).style.background = "#8bca84";
    document.getElementById("mini-flex-board"+board3).style.background = "#8bca84";
    if (winner == "X") {
        document.getElementById("flex-board").style.border = "12px solid #F5E6E8";
        document.getElementById("winner-popup-text").innerHTML = "Congratulations Player 1!";
        document.getElementById("winner-popup-box").style.border = "4px solid #FF66B3";
    }
    else if (winner == "O") {
        document.getElementById("flex-board").style.border = "12px solid #BEE7E8";
        document.getElementById("winner-popup-text").innerHTML = "Congratulations Player 2!";
        document.getElementById("winner-popup-box").style.border = "4px solid #084B83";
    }
    document.getElementById("winner-popup-title").innerHTML = winner + " MEGA Wins!";
    document.getElementById("winner-popup-box").style.visibility = "visible";
}

// on click closes popup with id = Id
function closePopup(Id) {
    document.getElementById(Id).style.visibility = "hidden";
}

// on click when reset button is pressed, makes reset popup visible
function resetHelper() {
    document.getElementById("reset-popup-box").style.visibility = "visible";
}

// on click if user clicks yes in reset popup, refreshes the page resetting page content
function reset() {
    location.reload();
}

// on click if user clicks the undo button, undos players move one at a time, can be used until the begining of the game is reached
function undo() {
    if (game == false) { // if the game is over, you cannot undo moves
        alert("Game over. You cannot undo moves.");
    }
    else if (moveStack.length > 0) { // ensure there are moves to undo
        undoMove = moveStack.pop() // pop the last move off of the moveStack
        megaBoard[Number(undoMove[0])].board[Number(undoMove[1])][Number(undoMove[2])] = ""; // reset the cell and the html
        document.getElementById("mini-flex-cell"+undoMove[0]+rowColToNum[Number(undoMove[1])][Number(undoMove[2])]).innerHTML = "";
        playerText(); // update the player text
        whichTurn--; // decrease whichTurn counter by 1
        if (megaBoard[Number(undoMove[0])].winner != null) { // if the miniboard had a winner, check to see if it still has a winner
            winCheck(megaBoard[Number(undoMove[0])]);
            if (megaBoard[Number(undoMove[0])].winner == null) { // if it no longer has a winner, update html
                document.getElementById("mini-flex-board"+undoMove[0]).style.background = "none";
            }
        }
        document.getElementById("mini-flex-board"+rowColToNum[Number(undoMove[1])][Number(undoMove[2])]).style.border = "none"; 
        if (moveStack.length == 0) { // if you popped the first move of the game from moveStack, update html accordingly
            document.getElementById("mini-flex-board"+undoMove[0]).style.border = "none";
            currentBoard = null;
            document.getElementById("player").innerHTML = "Player 1 Start";
        }
        else { // update currentBoard accordingly
            document.getElementById("mini-flex-board"+undoMove[0]).style.border = "6px solid yellow";
            currentBoard = undoMove[0];
        }
    }
    else { // if there are no moves to undo, alert the user
        alert("There are no moves to undo.");
    }
}