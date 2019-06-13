# -----------------------------------------------------------------------------
# Numenta Platform for Intelligent Computing (NuPIC)
# Copyright (C) 2016, Numenta, Inc.  Unless you have purchased from
# Numenta, Inc. a separate commercial license for this software code, the
# following terms and conditions apply:
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero Public License for more details.
#
# You should have received a copy of the GNU Affero Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# http://numenta.org/licenses/
# -----------------------------------------------------------------------------
#
# This creates a library from external source code
# that is physically included in this repository.
#
# Directions for adding a package:
# 1) If it is an include only package, then just add it to external/include and skip the rest of these directions.
# 2) Create a folder for the package in external/common/ and copy all files there.
# 3) Add the .cpp files to the common_src list.
# 4) The include files will be accessable with a path starting with the name of the folder created for your package.
# 5) The objects will be placed in common.lib and included as part of the external libraries.
#
# Notes about MurmurHash3
#   #include <murmurhash3/MurmurHash3.hpp>
#   link with common.lib
#    From IIRC The upstream repository for MurmurHash3 is not active. It is not merging fixes, even ones which 
#    pass all of thier unit tests. The maintainer appears to be only interested in the algorithms, and not the implementations.
#    @ctrl-z-9000-times modified the upstream code as follows:
#      - to not use switch case statements with implicit fallthroughs because our build 
#        settings disallow that. 
#      - removed all the other functions which we dont need.
#
#
# where to look for include files
set(common_SOURCE_DIR
	${REPOSITORY_DIR}/external/common
)

# where to look for .cpp files to compile
set(common_src 
	common/murmurhash3/MurmurHash3.cpp
)
source_group("common" FILES ${common_src})

# build a library of the common things.  It will be merged with the other libraries later.
add_library(common OBJECT ${common_src})
target_compile_definitions(common PRIVATE ${COMMON_COMPILER_DEFINITIONS})

set(common_INCLUDE_DIR ${common_SOURCE_DIR})
if (MSVC)
  set(common_LIBRARIES   "${CMAKE_BINARY_DIR}/common.dir/$<$<CONFIG:Release>:/Release/common.lib>$<$<CONFIG:Debug>:/Debug/common.lib>") 
else()
  set(common_LIBRARIES   ${CMAKE_BINARY_DIR}/common.dir/${CMAKE_STATIC_LIBRARY_PREFIX}common${CMAKE_STATIC_LIBRARY_SUFFIX}) 
endif()

message(STATUS "  common_INCLUDE_DIR= ${common_INCLUDE_DIR}")
message(STATUS "  common_LIBRARIES= ${common_LIBRARIES}")

FILE(APPEND "${EXPORT_FILE_NAME}" "common_INCLUDE_DIRS@@@${common_INCLUDE_DIR}\n")
FILE(APPEND "${EXPORT_FILE_NAME}" "common_LIBRARIES@@@${common_LIBRARIES}\n")
