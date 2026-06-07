
if (MSVC)
  set (OPUS_INCLUDE_DIR ${TTLIBS_ROOT}/opus/include)

  set (OPUS_LINK_FLAGS optimized ${TTLIBS_ROOT}/opus/lib/$(PlatformName)/opus.lib
    debug ${TTLIBS_ROOT}/opus/lib/$(PlatformName)/opusd.lib)
else()

  option (OPUS_STATIC "Build using static OPUS libraries" ON)

  if (OPUS_STATIC)
    set (OPUS_STATIC_LIB ${TTLIBS_ROOT}/opus/lib/libopus.a)
    if (EXISTS "${OPUS_STATIC_LIB}")
      set (OPUS_INCLUDE_DIR ${TTLIBS_ROOT}/opus/include)
      set (OPUS_LINK_FLAGS ${OPUS_STATIC_LIB})
    else()
      find_library(OPUS_SYSTEM_STATIC NAMES libopus.a opus)
      set (OPUS_LINK_FLAGS ${OPUS_SYSTEM_STATIC})
      find_path(OPUS_INCLUDE_DIR NAMES opus/opus.h HINTS /usr/include /usr/local/include)
    endif()
  else()
    # Ubuntu: libopus-dev
    find_library(OPUS_LIBRARY opus)
    set (OPUS_LINK_FLAGS ${OPUS_LIBRARY})
  endif()
    
endif()
