//
//  sf_log.c
//  ScoreFive
//
//  Created by Varun Santhanam on 7/19/17.
//  Copyright © 2017 Varun Santhanam. All rights reserved.
//

#include "sf_log.h"

os_log_t sf_log_create(const char * category) {
    
    return os_log_create("com.varunsanthanam.ScoreFive", category);
    
}

os_log_t sf_log() {
    
    static os_log_t sf_log;
    
    if (!sf_log) {
        
        sf_log = sf_log_create("ScoreFive");
        
    }
    
    return sf_log;
    
}
