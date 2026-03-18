export class GameButton {
    constructor(game, onClick) {
        this.game = game;
        this.element = document.createElement('button');

        this.element.textContent = `${game.name ?? ''}`;
        this.element.classList.add('game-button');

        this.element.addEventListener('click', () => {
            onClick(this.game);
        });
    }

    getElement() {
        return this.element;
    }

    setActive(active) {
        this.element.classList.toggle('active', active);
    }
}
