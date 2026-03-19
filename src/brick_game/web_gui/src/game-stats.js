export class GameStats {
    constructor(container) {
        this.container = container;

        this.element = document.createElement('div');
        this.element.className = 'stats-panel';

        this.scoreEl = this.createRow('Score');
        this.highScoreEl = this.createRow('High Score');
        this.levelEl = this.createRow('Level');
        this.speedEl = this.createRow('Speed');

        this.container.appendChild(this.element);
    }

    createRow(label) {
        const row = document.createElement('div');
        row.className = 'stats-row';

        const title = document.createElement('span');
        title.className = 'stats-label';
        title.textContent = `${label}: `;

        const value = document.createElement('span');
        value.className = 'stats-value';
        value.textContent = '-';

        row.appendChild(title);
        row.appendChild(value);
        this.element.appendChild(row);

        return value;
    }

    render(state) {
        this.scoreEl.textContent = state?.score ?? 0;
        this.highScoreEl.textContent = state?.high_score ?? 0;
        this.levelEl.textContent = state?.level ?? 0;
        const speed = state?.speed ?? 0;
        this.speedEl.textContent = speed === 0
            ? '0.00'.padStart(5, ' ')
            : (1000 / speed).toFixed(2).padStart(5, ' ');
    }
}
