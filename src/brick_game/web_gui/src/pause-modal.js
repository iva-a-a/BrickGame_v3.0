export class PauseModal {
    constructor(container) {
        this.container = container;
    }

    show() {
        this.container.classList.remove('hidden');
    }

    hide() {
        this.container.classList.add('hidden');
    }

    setVisible(visible) {
        this.container.classList.toggle('hidden', !visible);
    }
}
