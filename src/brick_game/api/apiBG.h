//
//  apiBG.h
//  BrickGame
//
//  Created by Alena Ivanova on 05.03.2026.
//

#ifndef APIBG_h
#define APIBG_h

#include <stdbool.h>
#incude "../struct.h"

#ifdef __cplusplus
extern "C" {
#endif
    
void userInput(UserAction_t action, bool hold);
GameInfo_t updateCurrentState();

#ifdef __cplusplus
}
#endif

#endif /* Header_h */
