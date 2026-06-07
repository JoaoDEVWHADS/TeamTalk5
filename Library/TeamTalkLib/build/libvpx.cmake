if (MSVC)
  set (LIBVPX_INCLUDE_DIR ${TTLIBS_ROOT}/libvpx)

  set (LIBVPX_LINK_FLAGS optimized ${TTLIBS_ROOT}/libvpx/lib/$(PlatformName)/vpxmt.lib
    debug ${TTLIBS_ROOT}/libvpx/lib/$(PlatformName)/vpxmtd.lib)

else()

  option (LIBVPX_STATIC "Build libvpx using static libraries" ON)

  if (LIBVPX_STATIC)
    set (LIBVPX_STATIC_LIB ${TTLIBS_ROOT}/libvpx/lib/libvpx.a)
    if (EXISTS "${LIBVPX_STATIC_LIB}")
      set (LIBVPX_INCLUDE_DIR ${TTLIBS_ROOT}/libvpx/include)
      set (LIBVPX_LINK_FLAGS ${LIBVPX_STATIC_LIB})
    else()
      find_library(LIBVPX_SYSTEM_STATIC NAMES libvpx.a vpx)
      set (LIBVPX_LINK_FLAGS ${LIBVPX_SYSTEM_STATIC})
      find_path(LIBVPX_INCLUDE_DIR NAMES vpx/vpx_codec.h HINTS /usr/include /usr/local/include)
    endif()
  else()
    # Ubuntu: libvpx-dev
    find_library(LIBVPX_LIBRARY vpx)
    set (LIBVPX_LINK_FLAGS ${LIBVPX_LIBRARY})
  endif()
endif()
