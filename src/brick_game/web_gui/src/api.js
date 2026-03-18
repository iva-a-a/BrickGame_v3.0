const BASE_URL = '/api';

export async function getGames() {
    const response = await fetch(`${BASE_URL}/games`);
    if (!response.ok) throw new Error('Failed to fetch games');
    return await response.json();
}

export async function selectGame(gameId) {
    const response = await fetch(`${BASE_URL}/games/${gameId}`, {
        method: 'POST'
    });
    if (!response.ok) throw new Error('Failed to select game');
}

export async function postAction(actionId, hold = false) {
    const body = {
        action_id: actionId,
        hold
    };
    const response = await fetch(`${BASE_URL}/actions`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(body)
    });
    if (!response.ok) throw new Error('Failed to perform action');
}

export async function getState() {
    const response = await fetch(`${BASE_URL}/state`);
    if (!response.ok) throw new Error('Failed to fetch game state');
    return await response.json();
}
