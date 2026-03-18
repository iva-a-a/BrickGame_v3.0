export const GAME_BOARD_WIDTH = 10;
export const GAME_BOARD_HEIGHT = 20;

export const Actions = {
    Start: 10,
    Pause: 11,
    Terminate: 12,
    Left: 13,
    Right: 14,
    Up: 15,
    Down: 16,
    Action: 17,
    None: 18
};

export const rootStyles = {
    '--tile-size': '20px',
    '--tile-color': '#eee',
    '--tile-active-color': '#222',
    '--game-board-width': GAME_BOARD_WIDTH,
    '--game-board-height': GAME_BOARD_HEIGHT,
    '--game-board-gap': '2px',
    '--game-board-background': '#333',
};

export const keyCodes = {
    Enter: GameAction.Start,
    KeyP: GameAction.Pause,
    Escape: GameAction.Terminate,
    ArrowUp: Actions.Up,
    ArrowDown: GameAction.Down,
    ArrowLeft: GameAction.Left,
    ArrowRight: GameAction.Right,
};
