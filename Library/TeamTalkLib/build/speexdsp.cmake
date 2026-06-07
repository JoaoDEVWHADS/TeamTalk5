
if (MSVC)
  set (SPEEXDSP_INCLUDE_DIR ${TTLIBS_ROOT}/speexdsp/include)

  set (SPEEXDSP_LINK_FLAGS optimized ${TTLIBS_ROOT}/speexdsp/lib/$(PlatformName)/libspeexdsp_sse.lib
    debug ${TTLIBS_ROOT}/speexdsp/lib/$(PlatformName)/libspeexdspd.lib)

else()

  option (SPEEXDSP_STATIC "Build using static SpeexDSP libraries" ON)

  if (SPEEXDSP_STATIC)
    set (SPEEXDSP_STATIC_LIB ${TTLIBS_ROOT}/speex/lib/libspeexdsp.a)
    if (EXISTS "${SPEEXDSP_STATIC_LIB}")
      set (SPEEXDSP_INCLUDE_DIR ${TTLIBS_ROOT}/speex/include)
      set (SPEEXDSP_LINK_FLAGS ${SPEEXDSP_STATIC_LIB})
    else()
      find_library(SPEEXDSP_SYSTEM_STATIC NAMES libspeexdsp.a speexdsp)
      set (SPEEXDSP_LINK_FLAGS ${SPEEXDSP_SYSTEM_STATIC})
      find_path(SPEEXDSP_INCLUDE_DIR NAMES speex/speex_preprocess.h HINTS /usr/include /usr/local/include)
    endif()
  else()
    # Ubuntu: libspeexdsp-dev
    find_library(SPEEXDSP_LIBRARY speexdsp)
    set (SPEEXDSP_LINK_FLAGS ${SPEEXDSP_LIBRARY})
  endif()
endif()
