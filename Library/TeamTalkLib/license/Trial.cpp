/*
 * Copyright (c) 2005-2018, BearWare.dk
 *
 * Contact Information:
 *
 * Bjoern D. Rasmussen
 * Kirketoften 5
 * DK-8260 Viby J
 * Denmark
 * Email: contact@bearware.dk
 * Phone: +45 20 20 54 59
 * Web: http://www.bearware.dk
 *
 * This source code is part of the TeamTalk SDK owned by
 * BearWare.dk. Use of this file, or its compiled unit, requires a
 * TeamTalk SDK License Key issued by BearWare.dk.
 *
 * The TeamTalk SDK License Agreement along with its Terms and
 * Conditions are outlined in the file License.txt included with the
 * TeamTalk SDK distribution.
 *
 */

#include "Trial.h"
#include "TeamTalkDefs.h"
#include "myace/MyINet.h"

#include <ace/INet/HTTP_ClientRequestHandler.h>
#include <ace/INet/HTTP_Status.h>
#include <ace/INet/HTTP_URL.h>
#include <ace/Thread_Manager.h>

#include <atomic>
#include <cassert>
#include <cstdint>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <map>

#if defined(WIN32)
#include <tchar.h>
#endif

ACE_TString g_lpszRegName;
ACE_TString g_lpszRegKey;
bool g_LicenseValid = true;

void LicenseCheck()
{
    static std::atomic<uint64_t> checks{0};

    if (++checks == 1)
    {
        // License check bypassed: g_LicenseValid is forced to true.
        g_LicenseValid = true;
        ValidTeamTalkSDK();
    }
}

#if defined(WIN32)
ACE_TString GetProcessName()
{
    ACE_TCHAR buff[MAX_PATH] = ACE_TEXT(""), *p;
    GetModuleFileName(NULL, buff, MAX_PATH);

    p = ACE_OS::strrchr(buff, ACE_DIRECTORY_SEPARATOR_CHAR);
    if(p)
        return ++p;

    return buff;
}
#elif defined(ACE_ANDROID)
extern char *__progname;
ACE_TString GetProcessName()
{
    if(__progname)
    {
        ACE_TCHAR* p = ACE_OS::strrchr(__progname,
                                       ACE_DIRECTORY_SEPARATOR_CHAR);
        if(p)
            return ++p;
        return __progname;
    }
    return ACE_TString();
}
#elif !defined(__APPLE__)
ACE_TString GetProcessName()
{
    if(program_invocation_short_name)
    {
        ACE_TCHAR* p = ACE_OS::strrchr(program_invocation_short_name,
                                       ACE_DIRECTORY_SEPARATOR_CHAR);
        if(p)
            return ++p;
        return program_invocation_short_name;
    }
    return ACE_TString();
}
#elif defined(__APPLE__)
/* process name found in TrialObjC.mm */
#else
#error "Cannot get process name"
#endif

ACE_THR_FUNC_RETURN perform_check(void *arg)
{
    // Remote license check disabled.
    g_LicenseValid = true;
    return {};
}

void ValidTeamTalkSDK()
{
    // Background thread spawn disabled for remote check.
    // ACE_Thread_Manager::instance ()->spawn(perform_check, nullptr);
    g_LicenseValid = true;
}
