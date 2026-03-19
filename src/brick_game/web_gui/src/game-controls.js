export class GameControls {
    constructor(container) {
        this.container = container;

        this.element = document.createElement('div');
        this.element.className = 'controls-panel';

        const title = document.createElement('h3');
        title.className = 'controls-title';
        title.textContent = 'Controls';

        const list = document.createElement('div');
        list.className = 'controls-list';

        const controls = [
            ['Enter', 'Start'],
            ['P', 'Pause'],
            ['Esc', 'Terminate'],
            ['← → ↑ ↓', 'Move'],
            ['Space', 'Action'],
        ];

        controls.forEach(([key, action]) => {
            const row = document.createElement('div');
            row.className = 'controls-row';

            const keyEl = document.createElement('span');
            keyEl.className = 'controls-key';
            keyEl.textContent = key;

            const actionEl = document.createElement('span');
            actionEl.className = 'controls-action';
            actionEl.textContent = action;

            row.appendChild(keyEl);
            row.appendChild(actionEl);
            list.appendChild(row);
        });

        this.element.appendChild(title);
        this.element.appendChild(list);
        this.container.appendChild(this.element);
    }
}
