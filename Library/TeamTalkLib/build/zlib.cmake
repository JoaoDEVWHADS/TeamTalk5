
if (MSVC)
  set (ZLIB_INCLUDE_DIR ${TTLIBS_ROOT}/zlib)
  set (ZLIB_STATIC_LIB optimized ${TTLIBS_ROOT}/zlib/lib/$(PlatformName)/zlib.lib debug ${TTLIBS_ROOT}/zlib/lib/$(PlatformName)/zlibd.lib)
  set (ZLIB_LINK_FLAGS ${ZLIB_STATIC_LIB})
else()
  option (ZLIB_STATIC "Build using zlib static libraries" ON)

  if (ZLIB_STATIC)
    set (ZLIB_STATIC_LIB ${TTLIBS_ROOT}/zlib/lib/libz.a)
    if (EXISTS "${ZLIB_STATIC_LIB}")
      set (ZLIB_INCLUDE_DIR ${TTLIBS_ROOT}/zlib/include)
      set (ZLIB_LINK_FLAGS ${ZLIB_STATIC_LIB})
    else()
      find_library(ZLIB_SYSTEM_STATIC NAMES libz.a z)
      set (ZLIB_LINK_FLAGS ${ZLIB_SYSTEM_STATIC})
      find_path(ZLIB_INCLUDE_DIR NAMES zlib.h HINTS /usr/include /usr/local/include)
    endif()
  else()
    # Ubuntu: zlib1g-dev
    find_library(ZLIB_LIBRARY z)
    set (ZLIB_LINK_FLAGS ${ZLIB_LIBRARY})
  endif()
endif()


