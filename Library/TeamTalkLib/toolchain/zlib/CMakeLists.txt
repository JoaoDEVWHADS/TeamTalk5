project(ZLib)

include(ExternalProject)

##################################################
# ZLib
##################################################

set (TOOLCHAIN_INSTALL_PREFIX_ZLIB ${TOOLCHAIN_INSTALL_PREFIX}/zlib)

if (MSVC)

  if (NOT CMAKE_VS_PLATFORM_NAME)
    if (${CMAKE_SIZEOF_VOID_P} EQUAL 8)
      set (CMAKE_VS_PLATFORM_NAME x64)
    else()
      set (CMAKE_VS_PLATFORM_NAME win32)
    endif()
  endif()

  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    if (${CMAKE_SIZEOF_VOID_P} EQUAL 8)

      ExternalProject_Add(zlib-src
        GIT_REPOSITORY    https://github.com/madler/zlib.git
        GIT_TAG           v1.3.2
        UPDATE_COMMAND    ""
        PREFIX            ${TOOLCHAIN_BUILD_PREFIX}/zlib
        INSTALL_DIR       ${TOOLCHAIN_INSTALL_PREFIX_ZLIB}
        SOURCE_SUBDIR     .
        CMAKE_ARGS        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                          -DZLIB_BUILD_TESTING=OFF
                          -DZLIB_BUILD_SHARED=OFF
        BUILD_COMMAND     ${CMAKE_COMMAND} --build <BINARY_DIR> --config Release
        INSTALL_COMMAND   ${CMAKE_COMMAND} --build <BINARY_DIR> --config Release --target install
        BUILD_BYPRODUCTS  <INSTALL_DIR>/lib/zs.lib
      )
    else()

      ExternalProject_Add(zlib-src
        GIT_REPOSITORY    https://github.com/madler/zlib.git
        GIT_TAG           v1.3.2
        UPDATE_COMMAND    ""
        PREFIX            ${TOOLCHAIN_BUILD_PREFIX}/zlib
        INSTALL_DIR       ${TOOLCHAIN_INSTALL_PREFIX_ZLIB}
        SOURCE_SUBDIR     .
        CMAKE_ARGS        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                          -DZLIB_BUILD_TESTING=OFF
                          -DZLIB_BUILD_SHARED=OFF
        BUILD_COMMAND     ${CMAKE_COMMAND} --build <BINARY_DIR> --config Release
        INSTALL_COMMAND   ${CMAKE_COMMAND} --build <BINARY_DIR> --config Release --target install
        BUILD_BYPRODUCTS  <INSTALL_DIR>/lib/zs.lib
        )
    endif()
    ExternalProject_Get_Property(zlib-src INSTALL_DIR)
    file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
  else()
    set (INSTALL_DIR ${TOOLCHAIN_INSTALL_PREFIX_ZLIB})
  endif()

  add_library(zlib STATIC IMPORTED GLOBAL)
  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    add_dependencies(zlib zlib-src)
  endif()
  target_include_directories (zlib INTERFACE ${INSTALL_DIR}/include)
  set_target_properties(zlib PROPERTIES
    IMPORTED_LOCATION_DEBUG ${INSTALL_DIR}/lib/zs.lib
    IMPORTED_LOCATION ${INSTALL_DIR}/lib/zs.lib)

elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    ExternalProject_Add(zlib-src
      GIT_REPOSITORY    https://github.com/madler/zlib.git
      GIT_TAG           v1.3.2
      GIT_SHALLOW       TRUE
      UPDATE_COMMAND    ""
      PREFIX            ${TOOLCHAIN_BUILD_PREFIX}/zlib
      INSTALL_DIR       ${TOOLCHAIN_INSTALL_PREFIX}/zlib
      CONFIGURE_COMMAND CFLAGS=-mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}
                        CPPFLAGS=-mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}
                        <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --static --archs=-arch\ arm64\ -arch\ x86_64
      BUILD_COMMAND     make ${TOOLCHAIN_BUILD_MAKEJOBS}
      INSTALL_COMMAND   make ${TOOLCHAIN_BUILD_MAKEJOBS} install
      BUILD_BYPRODUCTS  <INSTALL_DIR>/lib/libz.a
      )
    ExternalProject_Get_Property(zlib-src INSTALL_DIR)
    file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
  else()
    set (INSTALL_DIR ${TOOLCHAIN_INSTALL_PREFIX_ZLIB})
  endif()

  add_library(zlib STATIC IMPORTED GLOBAL)
  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    add_dependencies(zlib zlib-src)
  endif()
  target_include_directories (zlib INTERFACE ${INSTALL_DIR}/include)
  set_property(TARGET zlib PROPERTY IMPORTED_LOCATION ${INSTALL_DIR}/lib/libz.a)

elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")

  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    ExternalProject_Add(zlib-src
      GIT_REPOSITORY    https://github.com/madler/zlib.git
      GIT_TAG           v1.3.2
      GIT_SHALLOW       TRUE
      UPDATE_COMMAND    ""
      PREFIX            ${TOOLCHAIN_BUILD_PREFIX}/zlib
      INSTALL_DIR       ${TOOLCHAIN_INSTALL_PREFIX}/zlib
      CONFIGURE_COMMAND CFLAGS=-fPIC <SOURCE_DIR>/configure --prefix=<INSTALL_DIR> --static
      BUILD_COMMAND     make ${TOOLCHAIN_BUILD_MAKEJOBS}
      INSTALL_COMMAND   make ${TOOLCHAIN_BUILD_MAKEJOBS} install
      BUILD_BYPRODUCTS  <INSTALL_DIR>/lib/libz.a
      )
    ExternalProject_Get_Property(zlib-src INSTALL_DIR)
    file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
  else()
    set (INSTALL_DIR ${TOOLCHAIN_INSTALL_PREFIX_ZLIB})
  endif()

  add_library(zlib STATIC IMPORTED GLOBAL)
  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    add_dependencies(zlib zlib-src)
  endif()
  target_include_directories (zlib INTERFACE ${INSTALL_DIR}/include)
  set_target_properties(zlib PROPERTIES
    IMPORTED_LOCATION ${INSTALL_DIR}/lib/libz.a)

elseif (${CMAKE_SYSTEM_NAME} MATCHES "iOS")

  set (ZLIB_CFG_FLAGS -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}
                      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
                      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}
                      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
                      -DCMAKE_C_FLAGS_RELEASE=-fembed-bitcode
                      -DCMAKE_BUILD_TYPE=release)

  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    ExternalProject_Add(zlib-src
      GIT_REPOSITORY    https://github.com/madler/zlib.git
      GIT_TAG           v1.3.2
      GIT_SHALLOW       TRUE
      UPDATE_COMMAND    ""
      PREFIX            ${TOOLCHAIN_BUILD_PREFIX}/zlib
      INSTALL_DIR       ${TOOLCHAIN_INSTALL_PREFIX_ZLIB}
      CMAKE_ARGS        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> ${ZLIB_CFG_FLAGS}
                        -DZLIB_BUILD_TESTING=OFF
                        -DZLIB_BUILD_SHARED=OFF
      BUILD_COMMAND     ${CMAKE_COMMAND} --build . --target zlibstatic
      INSTALL_COMMAND   ${CMAKE_COMMAND} --build . --target install
      BUILD_BYPRODUCTS  <INSTALL_DIR>/lib/libz.a
      )
    ExternalProject_Get_Property(zlib-src INSTALL_DIR)
    file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
  else()
    set (INSTALL_DIR ${TOOLCHAIN_INSTALL_PREFIX_ZLIB})
  endif()

  add_library(zlib STATIC IMPORTED GLOBAL)
  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    add_dependencies(zlib zlib-src)
  endif()
  target_include_directories (zlib INTERFACE ${INSTALL_DIR}/include)
  set_target_properties(zlib PROPERTIES
    IMPORTED_LOCATION ${INSTALL_DIR}/lib/libz.a)

elseif (${CMAKE_SYSTEM_NAME} MATCHES "Android")

  set (ZLIB_CFG_FLAGS -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DANDROID_ABI=${ANDROID_ABI} -DANDROID_PLATFORM=${ANDROID_PLATFORM}
    -DCMAKE_BUILD_TYPE=release)

  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    ExternalProject_Add(zlib-src
      GIT_REPOSITORY    https://github.com/madler/zlib.git
      GIT_TAG           v1.3.2
      GIT_SHALLOW       TRUE
      UPDATE_COMMAND    ""
      PREFIX            ${TOOLCHAIN_BUILD_PREFIX}/zlib
      INSTALL_DIR       ${TOOLCHAIN_INSTALL_PREFIX_ZLIB}
      CMAKE_ARGS        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> ${ZLIB_CFG_FLAGS}
                        -DZLIB_BUILD_TESTING=OFF
                        -DZLIB_BUILD_SHARED=OFF
      BUILD_COMMAND     ${CMAKE_COMMAND} --build . --target zlibstatic
      INSTALL_COMMAND   ${CMAKE_COMMAND} --build . --target install
      BUILD_BYPRODUCTS  <INSTALL_DIR>/lib/libz.a
      )
    ExternalProject_Get_Property(zlib-src INSTALL_DIR)
    file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
  else()
    set (INSTALL_DIR ${TOOLCHAIN_INSTALL_PREFIX_ZLIB})
  endif()

  add_library(zlib STATIC IMPORTED GLOBAL)
  if (TOOLCHAIN_BUILD_EXTERNALPROJECTS)
    add_dependencies(zlib zlib-src)
  endif()
  target_include_directories (zlib INTERFACE ${INSTALL_DIR}/include)
  set_target_properties(zlib PROPERTIES
    IMPORTED_LOCATION ${INSTALL_DIR}/lib/libz.a)

endif()
