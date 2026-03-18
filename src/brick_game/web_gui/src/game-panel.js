import { GameButton } from './game-button.js';

export class GamePanel {
    constructor(container) {
        this.container = container;
        this.buttons = [];
    }

    render(games, onSelect) {
        this.container.innerHTML = '';
        this.buttons = [];

        games.forEach(game => {
            const btn = new GameButton(game, (selectedGame) => {
                this.setActive(selectedGame);
                onSelect(selectedGame);
            });

            this.buttons.push(btn);
            this.container.appendChild(btn.getElement());
        });
    }

    setActive(selectedGame) {
        this.buttons.forEach(btn => {
            btn.setActive(btn.game === selectedGame);
        });
    }
}
