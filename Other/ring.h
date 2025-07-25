
#ifndef __SIPHON_RING_H__
#define __SIPHON_RING_H__

//#include <pjsua-lib/pjsua.h>
#include "call.h"

PJ_BEGIN_DECL

void sip_ring_init(app_config_t *app_config);
void sip_ring_deinit(app_config_t *app_config);
void sip_ring_start(app_config_t *app_config);
void sip_ringback_start(app_config_t *app_config);
void sip_ring_stop(app_config_t *app_config);

PJ_END_DECL

#endif /* __SIPHON_RING_H__ */
