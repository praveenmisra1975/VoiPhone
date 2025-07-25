
#ifndef __SIPHON_DTMF_H__
#define __SIPHON_DTMF_H__

#include <pjsua-lib/pjsua.h>

PJ_BEGIN_DECL

void sip_call_play_digit     (pjsua_call_id call_id, char digit);
void sip_call_deinit_tonegen (pjsua_call_id call_id);
void sip_call_play_info_digit(pjsua_call_id call_id, char digit);

void sip_call_play_digits(pjsua_call_id call_id, pj_str_t *digits);
void sip_call_play_info_digits(pjsua_call_id call_id, pj_str_t *digits);

PJ_END_DECL

#endif /* __SIPHON_DTMF_H__ */
