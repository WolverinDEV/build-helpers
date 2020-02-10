# - Try to find ThreadPool include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(ThreadPool)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  ThreadPool_ROOT_DIR          Set this variable to the root installation of
#                            ThreadPool if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  ThreadPool_FOUND             System has ThreadPool, include and library dirs found
#  ThreadPool_INCLUDE_DIR       The ThreadPool include directories.
#  ThreadPool_LIBRARIES_STATIC  The ThreadPool libraries.
#  ThreadPool_LIBRARIES_SHARED  The ThreadPool libraries.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(ThreadPool_ROOT_DIR
        NAMES include/ThreadPool/ThreadPool.h
		HINTS ${ThreadPool_ROOT_DIR} ${ThreadPool_ROOT_DIR}/${BUILD_OUTPUT}
)

#This NEEDS a fix!
find_path(ThreadPool_INCLUDE_DIR
        NAMES ThreadPool/ThreadPool.h
		HINTS ${ThreadPool_ROOT_DIR} ${ThreadPool_ROOT_DIR}/include/
)

if (NOT TARGET threadpool::static)
    find_library(ThreadPool_LIBRARIES_STATIC
            NAMES ThreadPoolStatic.lib ThreadPoolStatic.a libThreadPoolStatic.a
            HINTS ${ThreadPool_ROOT_DIR} ${ThreadPool_ROOT_DIR}/lib
            )

    if (ThreadPool_LIBRARIES_STATIC)
        add_library(threadpool::static STATIC IMPORTED)
        set_target_properties(threadpool::static PROPERTIES
                IMPORTED_LOCATION ${ThreadPool_LIBRARIES_STATIC}
                INTERFACE_INCLUDE_DIRECTORIES ${ThreadPool_INCLUDE_DIR}
                )
    endif ()
endif ()

if (NOT TARGET threadpool::shared)
    find_library(ThreadPool_LIBRARIES_SHARED
            NAMES ThreadPool.dll ThreadPool.so
            HINTS ${ThreadPool_ROOT_DIR} ${ThreadPool_ROOT_DIR}/lib
            )

    if (ThreadPool_LIBRARIES_SHARED)
        add_library(threadpool::static SHARED IMPORTED)
        set_target_properties(threadpool::shared PROPERTIES
                IMPORTED_LOCATION ${ThreadPool_LIBRARIES_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${ThreadPool_INCLUDE_DIR}
                )
    endif ()
endif ()

find_package_handle_standard_args(ThreadPool DEFAULT_MSG
        ThreadPool_INCLUDE_DIR
)


mark_as_advanced(
        ThreadPool_ROOT_DIR
        ThreadPool_INCLUDE_DIR
        ThreadPool_LIBRARIES_STATIC
        ThreadPool_LIBRARIES_SHARED
)
