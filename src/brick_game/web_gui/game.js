import { applyRootStyles } from './src/utils.js';
import { GameBoard } from './src/game-board.js';
import { rootStyles, keyCodes } from './src/config.js';
import { getGames, selectGame, postAction } from './src/api.js';
import { GamePanel } from './src/game-panel.js';

applyRootStyles(rootStyles);
const gameBoard = new GameBoard(document.querySelector('#game-board'));
const panel = new GamePanel(document.querySelector('#side-panel'));

const $sidePanel = document.querySelector('#side-panel');

document.addEventListener('keydown', async function (event) {
    if (keyCodes.start.includes(event.code)) {
        await postAction(10, false);
        console.log('start');
    }
    if (keyCodes.pause.includes(event.code)) {
        await postAction(11, false);
        console.log('pause');
    }
    if (keyCodes.terminate.includes(event.code)) {
        await postAction(12, false);
        console.log('terminate');
    }
    if (keyCodes.left.includes(event.code)) {
        await postAction(13, false);
        console.log('left');
    }
    if (keyCodes.right.includes(event.code)) {
        await postAction(14, false);
        console.log('right');
    }
    if (keyCodes.up.includes(event.code)) {
        await postAction(15, false);
        console.log('up');
    }
    if (keyCodes.down.includes(event.code)) {
        await postAction(16, false);
        console.log('down');
    }
    if (keyCodes.action.includes(event.code)) {
        await postAction(17, false);
        console.log('action');
    }
});

async function initGames() {
    try {
        const data = await getGames();
        const games = data.games;

        panel.render(games, async (game) => {
            console.log('Selected:', game.id);
            await selectGame(game.id);
        });

    } catch (err) {
        console.error(err);
    }
}
// Запускаем
initGames();
