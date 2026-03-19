import { applyRootStyles } from './src/utils.js';
import { GameBoard } from './src/game-board.js';
import { rootStyles, keyCodes } from './src/config.js';
import { getGames, selectGame, postAction, getState } from './src/api.js';
import { GamePanel } from './src/game-panel.js';
import { GameStats } from './src/game-stats.js';
import { GameControls } from './src/game-controls.js';
import { GameOverModal } from './src/game-over-modal.js';
import { PauseModal } from './src/pause-modal.js';
import { NextBoard } from './src/next-board.js';

applyRootStyles(rootStyles);

const gameBoard = new GameBoard(document.querySelector('#game-board'));
const panel = new GamePanel(document.querySelector('#game-buttons'));
const stats = new GameStats(document.querySelector('#stats-panel'));
const controls = new GameControls(document.querySelector('#controls-panel'));
const gameOverModal = new GameOverModal(document.querySelector('#game-over-modal'));
const pauseModal = new PauseModal(document.querySelector('#pause-modal'));
const nextBoard = new NextBoard(document.querySelector('#next-panel'));

let stateIntervalId = null;
let isSendingAction = false;

document.addEventListener('keydown', async function (event) {
    if (event.repeat) return;
    if (isSendingAction) return;

    try {
        isSendingAction = true;

        if (keyCodes.start.includes(event.code)) {
            await postAction(10, false);
            gameOverModal.hide();
        }
        if (keyCodes.pause.includes(event.code)) {
            await postAction(11, false);
        }
        if (keyCodes.terminate.includes(event.code)) {
            await postAction(12, false);
        }
        if (keyCodes.left.includes(event.code)) {
            await postAction(13, false);
        }
        if (keyCodes.right.includes(event.code)) {
            await postAction(14, false);
        }
        if (keyCodes.up.includes(event.code)) {
            await postAction(15, false);
        }
        if (keyCodes.down.includes(event.code)) {
            await postAction(16, false);
        }
        if (keyCodes.action.includes(event.code)) {
            await postAction(17, false);
        }
    } catch (error) {
        console.error(error);
    } finally {
        isSendingAction = false;
    }
});

async function updateState() {
    try {
        const state = await getState();

        gameBoard.render(state.field);
        stats.render(state);
        nextBoard.render(state.next);

        const isGameOver = !state.next || state.next.length === 0;
        gameOverModal.setVisible(isGameOver);

        pauseModal.setVisible(state.pause && !isGameOver);
    } catch (error) {
        console.error(error);
    }
}

function startStateLoop() {
    stopStateLoop();
    updateState();
    stateIntervalId = setInterval(updateState, 120);
}

function stopStateLoop() {
    if (stateIntervalId !== null) {
        clearInterval(stateIntervalId);
        stateIntervalId = null;
    }
}

async function initGames() {
    try {
        const data = await getGames();
        const games = data.games;

        panel.render(games, async (game) => {
            try {
                await selectGame(game.id);
                gameOverModal.hide();
                gameBoard.clear();
                nextBoard.clear();
                await updateState();
                startStateLoop();
            } catch (error) {
                console.error(error);
            }
        });
    } catch (error) {
        console.error(error);
    }
}

initGames();
