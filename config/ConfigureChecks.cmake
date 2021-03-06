# CMake build system for exiv2 library and executables
# Copyright 2008 by Patrick Spendrin <ps_ml@gmx.de>
# Copyright 2010 by Gilles Caulier <caulier dot gilles at gmail dot com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#    1. Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#    2. Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#    3. The name of the author may not be used to endorse or promote
#       products derived from this software without specific prior
#       written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ConfigureChecks for exiv2

SET( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/config )
INCLUDE( CheckIncludeFile )
INCLUDE( CheckFunctionExists )
INCLUDE( CheckSymbolExists )
INCLUDE( CheckCSourceCompiles )
INCLUDE( CheckCXXSourceCompiles )

INCLUDE( FindIconv )

SET( STDC_HEADERS ON )
SET( HAVE_DECL_STRERROR_R 0 )

SET( HAVE_PRINTUCS2 ${EXIV2_ENABLE_PRINTUCS2} )
SET( HAVE_LENSDATA ${EXIV2_ENABLE_LENSDATA} )

INCLUDE_DIRECTORIES( ${CMAKE_INCLUDE_PATH} ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/xmpsdk/include )
LINK_DIRECTORIES( ${CMAKE_LIBRARY_PATH} )
SET( CMAKE_REQUIRED_INCLUDES ${CMAKE_INCLUDE_PATH} )

IF( EXIV2_ENABLE_PNG )
    FIND_PACKAGE( ZLIB )
    INCLUDE_DIRECTORIES( ${ZLIB_INCLUDE_DIR} )
    SET (HAVE_LIBZ ${ZLIB_FOUND})
ENDIF( EXIV2_ENABLE_PNG )

IF (EXIV2_ENABLE_XMP)
    FIND_PACKAGE(EXPAT)
    INCLUDE_DIRECTORIES(${EXPAT_INCLUDE_DIR})
    # FindEXPAT.cmake doesn't check for REQUIRED flags - so we need to check ourselves
	IF( MINGW OR UNIX )
		IF (NOT EXPAT_FOUND)
			MESSAGE(FATAL_ERROR "missing library expat required for XMP")
		ENDIF( NOT EXPAT_FOUND )
	ENDIF( MINGW OR UNIX )
ENDIF (EXIV2_ENABLE_XMP)

IF( EXIV2_ENABLE_SHARED )
    ADD_DEFINITIONS( -DEXV_HAVE_DLL )
    SET( STATIC_FLAG SHARED )
ELSE( EXIV2_ENABLE_SHARED )
    SET( STATIC_FLAG STATIC )
ENDIF( EXIV2_ENABLE_SHARED )

IF( EXIV2_ENABLE_NLS )
    IF( NOT LOCALEDIR )
        SET( LOCALEDIR "${CMAKE_INSTALL_PREFIX}/share/locale" )
        IF( WIN32 )
            STRING( REPLACE "/" "\\\\" LOCALEDIR ${LOCALEDIR} )
        ENDIF( WIN32 )
    ENDIF( NOT LOCALEDIR )
    ADD_DEFINITIONS( -DEXV_LOCALEDIR=${LOCALEDIR} )
ENDIF( EXIV2_ENABLE_NLS )

IF( EXIV2_ENABLE_COMMERCIAL )
    ADD_DEFINITIONS( -DEXV_COMMERCIAL_VERSION )
ENDIF( EXIV2_ENABLE_COMMERCIAL )

FIND_PACKAGE(Iconv)
IF( ICONV_FOUND )
    SET( HAVE_ICONV 1 )
    INCLUDE_DIRECTORIES(${ICONV_INCLUDE_DIR})
    MESSAGE ( "-- ICONV_LIBRARIES : " ${ICONV_LIBRARIES} )
ENDIF( ICONV_FOUND )

IF( ICONV_ACCEPTS_CONST_INPUT )
    MESSAGE ( "ICONV_ACCEPTS_CONST_INPUT : yes" )
ENDIF( ICONV_ACCEPTS_CONST_INPUT )

FIND_PACKAGE(MSGFMT)
IF(MSGFMT_FOUND)
    MESSAGE(STATUS "Program msgfmt found (${MSGFMT_EXECUTABLE})")
    SET( EXIV2_BUILD_PO 1 )
ENDIF(MSGFMT_FOUND)

# checking for Header files
check_include_file( "inttypes.h" have_inttypes_h )
check_include_file( "libintl.h" HAVE_LIBINTL_H )
check_include_file( "malloc.h" HAVE_MALLOC_H )
check_include_file( "memory.h" HAVE_MEMORY_H )
check_include_file( "iconv.h" HAVE_ICONV_H )
check_include_file( "stdbool.h" HAVE_STDBOOL_H )
check_include_file( "stdint.h" HAVE_STDINT_H )
check_include_file( "stdlib.h" HAVE_STDLIB_H )
check_include_file( "string.h" HAVE_STRING_H )
check_include_file( "strings.h" HAVE_STRINGS_H )
check_include_file( "unistd.h" HAVE_UNISTD_H )
check_include_file( "wchar.h" HAVE_WCHAR_H )
check_include_file( "sys/stat.h" HAVE_SYS_STAT_H )
check_include_file( "sys/time.h" HAVE_SYS_TIME_H )
check_include_file( "sys/types.h" HAVE_SYS_TYPES_H )
check_include_file( "sys/mman.h" HAVE_SYS_MMAN_H )
check_include_file( "process.h" HAVE_PROCESS_H )

check_function_exists( alarm HAVE_ALARM )
check_function_exists( gmtime_r HAVE_GMTIME_R )
check_function_exists( malloc HAVE_MALLOC )
check_function_exists( memset HAVE_MEMSET )
check_function_exists( mmap HAVE_MMAP )
check_function_exists( munmap HAVE_MUNMAP )
check_function_exists( realloc HAVE_REALLOC )
check_function_exists( strchr HAVE_STRCHR )
check_function_exists( strchr_r HAVE_STRCHR_R )
check_function_exists( strerror HAVE_STRERROR )
check_function_exists( strerror_r HAVE_STRERROR_R )
check_function_exists( strtol HAVE_STRTOL )
check_function_exists( timegm HAVE_TIMEGM )
check_function_exists( vprintf HAVE_VPRINTF )

MESSAGE( STATUS "None:              ${CMAKE_CXX_FLAGS}" )
MESSAGE( STATUS "Debug:             ${CMAKE_CXX_FLAGS_DEBUG}" )
MESSAGE( STATUS "Release:           ${CMAKE_CXX_FLAGS_RELEASE}" )
MESSAGE( STATUS "RelWithDebInfo:    ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}" )
MESSAGE( STATUS "MinSizeRel:        ${CMAKE_CXX_FLAGS_MINSIZEREL}" )

IF( HAVE_STDBOOL_H )
    CHECK_SYMBOL_EXISTS( "_Bool" stdbool.h HAVE__BOOL )
ENDIF( HAVE_STDBOOL_H )

# struct tm in sys/time.h
IF( HAVE_SYS_TIME_H )
    CHECK_C_SOURCE_COMPILES( "#include <sys/time.h>
int main() {
struct tm t;
return 0;
}" TM_IN_SYS_TIME )
ENDIF( HAVE_SYS_TIME_H )

#####################################################################################
# strerror_r returns char*

# NOTE : reverting commit #2041, which break compilation under linux and windows

CHECK_C_SOURCE_COMPILES( "#include <string.h>
int main() {
char * c;
c = strerror_r(0,c,0);
return 0;
}" STRERROR_R_CHAR_P )

# function is declared with the above
IF( STRERROR_R_CHAR_P )
    SET( HAVE_DECL_STRERROR_R 1 )
ENDIF( STRERROR_R_CHAR_P )

#####################################################################################

# time.h and sys/time.h can be included in the same file
CHECK_C_SOURCE_COMPILES( "#include <time.h>
#include <sys/time.h>
int main() {
return 0;
}" TIME_WITH_SYS_TIME )

# for msvc define to int in exv_conf.h
IF( NOT MSVC )
    SET( HAVE_PID_T TRUE )
ENDIF( NOT MSVC )

SET( EXV_SYMBOLS ENABLE_NLS
                 HAVE_ALARM
                 HAVE_DECL_STRERROR_R
                 HAVE_GMTIME_R
                 HAVE_ICONV
                 HAVE_ICONV_H
                 HAVE_INTTYPES_H
                 HAVE_LENSDATA
                 HAVE_LIBINTL_H
                 HAVE_LIBZ
                 HAVE_MALLOC_H
                 HAVE_MEMORY_H
                 HAVE_MEMSET
                 HAVE_MMAP
                 HAVE_MUNMAP
                 HAVE_PRINTUCS2
                 HAVE_PROCESS_H
                 HAVE_REALLOC
                 HAVE_STDBOOL_H
                 HAVE_STDINT_H
                 HAVE_STDLIB_H
                 HAVE_STRCHR
                 HAVE_STRCHR_R
                 HAVE_STRERROR
                 HAVE_STRERROR_R
                 HAVE_STRINGS_H
                 HAVE_STRING_H
                 HAVE_STRTOL
                 HAVE_SYS_MMAN_H
                 HAVE_SYS_STAT_H
                 HAVE_SYS_TIME_H
                 HAVE_SYS_TYPES_H
                 HAVE_TIMEGM
                 HAVE_UNISTD_H
                 HAVE_VPRINTF
                 HAVE_WCHAR_H
                 HAVE_XMP_TOOLKIT
                 HAVE__BOOL
                 PACKAGE
                 PACKAGE_BUGREPORT
                 PACKAGE_NAME
                 PACKAGE_STRING
                 PACKAGE_TARNAME
                 PACKAGE_VERSION
                 STRERROR_R_CHAR_P
   )

FOREACH( entry ${EXV_SYMBOLS} )
    SET( EXV_${entry} ${${entry}} )
    # NOTE: to hack...
    # MESSAGE( EXV_${entry} " : " ${${entry}} )
ENDFOREACH( entry ${EXV_SYMBOLS} )

CONFIGURE_FILE( config/config.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/exv_conf.h )
CONFIGURE_FILE( config/exv_msvc.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/exv_msvc.h COPYONLY )
INSTALL( FILES ${CMAKE_CURRENT_BINARY_DIR}/exv_conf.h DESTINATION include/exiv2 )
INSTALL( FILES ${CMAKE_CURRENT_BINARY_DIR}/exv_msvc.h DESTINATION include/exiv2 )

CONFIGURE_FILE(config/exiv2_uninstall.cmake ${CMAKE_BINARY_DIR}/cmake_uninstall.cmake COPYONLY)
ADD_CUSTOM_TARGET(uninstall "${CMAKE_COMMAND}" -P "${CMAKE_BINARY_DIR}/cmake_uninstall.cmake")

IF( NOT MSVC )
    CONFIGURE_FILE( config/exiv2.pc.cmake ${CMAKE_CURRENT_BINARY_DIR}/exiv2.pc @ONLY )
    INSTALL( FILES ${CMAKE_CURRENT_BINARY_DIR}/exiv2.pc DESTINATION lib/pkgconfig )
    CONFIGURE_FILE( config/exiv2.lsm.cmake ${CMAKE_CURRENT_BINARY_DIR}/exiv2.lsm)
    INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/exiv2.lsm DESTINATION lib/pkgconfig )
ENDIF( NOT MSVC )

# ******************************************************************************
# output chosen build options
MACRO( OptionOutput _outputstring )
    IF( ${ARGN} )
        SET( _var "YES" )
    ELSE( ${ARGN} )
        SET( _var "NO" )
    ENDIF( ${ARGN} )
    MESSAGE( STATUS "${_outputstring}${_var}" )
ENDMACRO( OptionOutput _outputstring )

MESSAGE( STATUS "------------------------------------------------------------------" )
MESSAGE( STATUS "${PACKAGE_STRING} configure results        <${PACKAGE_URL}>"        )
OptionOutput( "Building PNG support:               " EXIV2_ENABLE_PNG AND ZLIB_FOUND )
OptionOutput( "Building shared library:            " EXIV2_ENABLE_SHARED             )
OptionOutput( "XMP metadata support:               " EXIV2_ENABLE_XMP                )
OptionOutput( "Building static libxmp:             " EXIV2_ENABLE_LIBXMP             )
OptionOutput( "Native language support:            " EXIV2_ENABLE_NLS                )
OptionOutput( "Conversion of Windows XP tags:      " EXIV2_ENABLE_PRINTUCS2          )
OptionOutput( "Nikon lens database:                " EXIV2_ENABLE_LENSDATA           )
OptionOutput( "Commercial build:                   " EXIV2_ENABLE_COMMERCIAL         )
OptionOutput( "Build the unit tests:               " EXIV2_ENABLE_BUILD_SAMPLES      )
OptionOutput( "Building translations files:        " EXIV2_ENABLE_BUILD_PO           )
MESSAGE( STATUS "------------------------------------------------------------------" )
