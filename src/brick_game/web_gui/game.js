import { applyRootStyles } from './src/utils.js';
import { GameBoard } from './src/game-board.js';
import { rootStyles, keyCodes } from './src/config.js';

applyRootStyles(rootStyles);
const gameBoard = new GameBoard(document.querySelector('#game-board'));

const $sidePanel = document.querySelector('#side-panel');

document.addEventListener('keydown', function (event) {
    if (GameAction.Up) {
        gameBoard.enableTile(4, 5);
        console.log('up');
    }
    if (GameAction.Right) {
        gameBoard.disableTile(4, 5);
        console.log('right');
    }
    if (GameAction.Down) {
        console.log('down');
    }
    if (GameAction.Left) {
        console.log('left');
    }
});
