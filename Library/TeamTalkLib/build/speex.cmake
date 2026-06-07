
if (MSVC)
  set (SPEEX_INCLUDE_DIR ${TTLIBS_ROOT}/speex/include)

  set (SPEEX_LINK_FLAGS optimized ${TTLIBS_ROOT}/speex/lib/$(PlatformName)/libspeex_sse2.lib
    debug ${TTLIBS_ROOT}/speex/lib/$(PlatformName)/libspeexd.lib)

else()

  option (SPEEX_STATIC "Build using static Speex libraries" ON)

  if (SPEEX_STATIC)
    set (SPEEX_STATIC_LIB ${TTLIBS_ROOT}/speex/lib/libspeex.a)
    if (EXISTS "${SPEEX_STATIC_LIB}")
      set (SPEEX_INCLUDE_DIR ${TTLIBS_ROOT}/speex/include)
      set (SPEEX_LINK_FLAGS ${SPEEX_STATIC_LIB})
    else()
      find_library(SPEEX_SYSTEM_STATIC NAMES libspeex.a speex)
      set (SPEEX_LINK_FLAGS ${SPEEX_SYSTEM_STATIC})
      find_path(SPEEX_INCLUDE_DIR NAMES speex/speex.h HINTS /usr/include /usr/local/include)
    endif()
  else()
    # Ubuntu: libspeex-dev
    find_library(SPEEX_LIBRARY speex)
    set (SPEEX_LINK_FLAGS ${SPEEX_LIBRARY})
  endif()
endif()
