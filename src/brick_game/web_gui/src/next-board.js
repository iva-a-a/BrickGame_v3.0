import { GAME_NEXT_WIDTH, GAME_NEXT_HEIGHT } from './config.js';

export class NextBoard {
    constructor(container, rows = GAME_NEXT_WIDTH, cols = GAME_NEXT_HEIGHT) {
        this.container = container;
        this.rows = rows;
        this.cols = cols;
        this.tiles = [];

        this.element = document.createElement('div');
        this.element.className = 'next-board-wrapper';

        this.title = document.createElement('h3');
        this.title.className = 'next-board-title';
        this.title.textContent = 'Next';

        this.board = document.createElement('div');
        this.board.className = 'next-board';

        for (let y = 0; y < rows; y++) {
            for (let x = 0; x < cols; x++) {
                const tile = document.createElement('div');
                tile.className = 'next-tile';
                this.tiles.push(tile);
                this.board.appendChild(tile);
            }
        }

        this.element.appendChild(this.title);
        this.element.appendChild(this.board);
        this.container.appendChild(this.element);
    }

    getTile(x, y) {
        return this.tiles[y * this.cols + x];
    }

    hasActiveCells(matrix) {
        if (!matrix) return false;

        for (let y = 0; y < matrix.length; y++) {
            for (let x = 0; x < matrix[y].length; x++) {
                if (matrix[y][x]) return true;
            }
        }

        return false;
    }

    render(matrix) {
        const hasActive = this.hasActiveCells(matrix);

        this.element.classList.toggle('has-preview', hasActive);

        for (let y = 0; y < this.rows; y++) {
            for (let x = 0; x < this.cols; x++) {
                const active = Boolean(matrix?.[y]?.[x]);
                this.getTile(x, y).classList.toggle('active', active);
            }
        }
    }

    clear() {
        this.element.classList.remove('has-preview');

        for (const tile of this.tiles) {
            tile.classList.remove('active');
        }
    }
}
