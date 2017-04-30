#This needs to be unique globally
set(proj FFTW3double)
set(proj_COMPONENTS "COMPONENTS double")
# Set dependency list
if (WIN32)
  # rely on the "single" version to install everything
  set(${proj}_DEPENDENCIES "FFTW3")
endif()

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} DEPENDS_VAR ${proj}_DEPENDENCIES)

# Set external name (same as internal for now)
set(externalProjName ${proj})

if(NOT ( DEFINED "USE_SYSTEM_${externalProjName}" AND "${USE_SYSTEM_${externalProjName}}" ) )
  if (WIN32)
    # don't do anything
    ExternalProject_Add_Empty(${proj})
    return()
  endif()
    
  message(STATUS "${__indent}Adding project ${proj}")

  ### --- Project specific additions here
  set(FFTWdouble_Install_Dir ${CMAKE_CURRENT_BINARY_DIR}/INSTALL)
  set(FFTWdouble_Configure_Script ${CMAKE_CURRENT_LIST_DIR}/External_FFTWdouble_configure.cmake)
  set(FFTW_Build_Script ${CMAKE_CURRENT_LIST_DIR}/External_FFTWdouble_build.cmake)

  set(${proj}_URL http://www.fftw.org/fftw-3.3.5.tar.gz )
  set(${proj}_MD5 6cc08a3b9c7ee06fdd5b9eb02e06f569 )

  if(CMAKE_COMPILER_IS_CLANGXX)
    set(CLANG_ARG -DCMAKE_COMPILER_IS_CLANGXX:BOOL=ON)
  endif()

  set(FFTWdouble_SOURCE_DIR ${SOURCE_DOWNLOAD_CACHE}/${proj} )

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    URL ${${proj}_URL}
    URL_HASH MD5=${${proj}_MD5}
    SOURCE_DIR ${FFTWdouble_SOURCE_DIR}
    BINARY_DIR ${FFTWdouble_SOURCE_DIR}
    CONFIGURE_COMMAND ./configure --with-pic --prefix ${FFTWdouble_Install_Dir}
    INSTALL_DIR ${FFTWdouble_Install_Dir}
  )

  set( FFTW3_ROOT_DIR ${FFTWdouble_Install_Dir} )


 else()
    if(${USE_SYSTEM_${externalProjName}})
      find_package(${proj} ${${externalProjName}_REQUIRED_VERSION} ${${externalProjName}_COMPONENTS} REQUIRED)
      message(STATUS "USING the system ${externalProjName}, found FFTW3double_INCLUDE_DIR=${FFTW3double_INCLUDE_DIR}, FFTW3double_LIBRARY=${FFTW3double_LIBRARY}")
  endif()
  ExternalProject_Add_Empty(${proj} "${${proj}_DEPENDENCIES}")
endif()

mark_as_superbuild(
  VARS
    ${externalProjName}_DIR:PATH
  LABELS
    "FIND_PACKAGE"
)