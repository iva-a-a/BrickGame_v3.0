//
//  apiBG.h
//  BrickGame
//
//  Created by Alena Ivanova on 05.03.2026.
//

#ifndef APIBG_h
#define APIBG_h

#include <stdbool.h>
#include "struct.h"

#ifdef __cplusplus
extern "C" {
#endif
    
void userInput(UserAction_t action, bool hold);
GameInfo_t updateCurrentState();

typedef struct {
    int id;
    char *name;
} GameListItem_t;

typedef struct {
    GameListItem_t *items;
    int count;
} AvailableGames_t;

AvailableGames_t listAvailableGames();
void freeAvailableGames(AvailableGames_t games);

bool selectGameById(int id);

#ifdef __cplusplus
}
#endif

#endif /* APIBG_h */
