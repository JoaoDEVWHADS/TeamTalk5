
if (MSVC)
  set (TINYXML_INCLUDE_DIR ${TTLIBS_ROOT}/tinyxml)
  set (TINYXML_STATIC_LIB optimized ${TTLIBS_ROOT}/tinyxml/lib/$(PlatformName)/tinyxml.lib
    debug ${TTLIBS_ROOT}/tinyxml/lib/$(PlatformName)/tinyxmld.lib)
  set (TINYXML_LINK_FLAGS ${TINYXML_STATIC_LIB})
else()

  option (TINYXML_STATIC "Build using static tinyxml libraries" ON)

  if (TINYXML_STATIC)
    set (TINYXML_STATIC_LIB ${TTLIBS_ROOT}/tinyxml/libTinyXML.a )
    if (EXISTS "${TINYXML_STATIC_LIB}")
      set (TINYXML_INCLUDE_DIR ${TTLIBS_ROOT}/tinyxml )
      set (TINYXML_LINK_FLAGS ${TINYXML_STATIC_LIB})
    else()
      find_library(TINYXML_SYSTEM_STATIC NAMES libtinyxml.a tinyxml)
      set (TINYXML_LINK_FLAGS ${TINYXML_SYSTEM_STATIC})
      find_path(TINYXML_INCLUDE_DIR NAMES tinyxml.h HINTS /usr/include /usr/local/include)
    endif()
  else()
    # Ubuntu: libtinyxml-dev
    find_library(TINYXML_LIBRARY tinyxml)
    set (TINYXML_LINK_FLAGS ${TINYXML_LIBRARY})
  endif()
endif()
