# - Try to find DataPipes include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(DataPipes)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  DataPipes_ROOT_DIR          Set this variable to the root installation of
#                            DataPipes if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  DataPipes_FOUND             System has DataPipes, include and library dirs found
#  DataPipes_INCLUDE_DIR       The DataPipes include directories.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

function(find_datapipes)
    find_path(DataPipes_ROOT_DIR
            NAMES include/pipes/buffer.h include/pipes/pipeline.h
            HINTS ${DataPipes_ROOT_DIR}
    )

    find_path(DataPipes_INCLUDE_DIR
            NAMES pipes/pipeline.h pipes/buffer.h
            HINTS ${DataPipes_ROOT_DIR}/include/
    )

    if (NOT TARGET DataPipes::core::static)
        find_library(STATIC_CORE_LIBRARY
                NAMES DataPipes-Core-Static.lib libDataPipes-Core-Static.a
                HINTS ${DataPipes_ROOT_DIR} ${DataPipes_ROOT_DIR}/lib
        )

        if(STATIC_CORE_LIBRARY)
            add_library(DataPipes::core::static STATIC IMPORTED)
            set_target_properties(DataPipes::core::static PROPERTIES
                    IMPORTED_LOCATION ${STATIC_CORE_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${DataPipes_INCLUDE_DIR}
            )
        endif()
    endif ()

    if (NOT TARGET DataPipes::core::shared)
        find_library(SHARED_CORE_LIBRARY
                NAMES DataPipes-Core-Shared.dll libDataPipes-Core-Shared.so
                HINTS ${DataPipes_ROOT_DIR} ${DataPipes_ROOT_DIR}/lib
                )

        if(SHARED_CORE_LIBRARY)
            add_library(DataPipes::core::shared SHARED IMPORTED)
            set_target_properties(DataPipes::core::shared PROPERTIES
                    IMPORTED_LOCATION ${SHARED_CORE_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${DataPipes_INCLUDE_DIR}
                    )
        endif()
    endif ()

    if (NOT TARGET DataPipes::rtc::static)
        find_library(STATIC_RTC_LIBRARY
                NAMES DataPipes-Rtc-Static.lib libDataPipes-Rtc-Static.a
                HINTS ${DataPipes_ROOT_DIR} ${DataPipes_ROOT_DIR}/lib
                )

        if(STATIC_RTC_LIBRARY)
            add_library(DataPipes::rtc::static STATIC IMPORTED)
            set_target_properties(DataPipes::rtc::static PROPERTIES
                    IMPORTED_LOCATION ${STATIC_RTC_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${DataPipes_INCLUDE_DIR}
            )
        endif()
    endif ()

    if (NOT TARGET DataPipes::rtc::shared)
        find_library(SHARED_RTC_LIBRARY
                NAMES DataPipes-Rtc-Shared.dll libDataPipes-Rtc-Shared.so
                HINTS ${DataPipes_ROOT_DIR} ${DataPipes_ROOT_DIR}/lib
        )

        if(SHARED_RTC_LIBRARY)
            add_library(DataPipes::rtc::shared SHARED IMPORTED)
            set_target_properties(DataPipes::rtc::shared PROPERTIES
                    IMPORTED_LOCATION ${SHARED_RTC_LIBRARY}
                    INTERFACE_INCLUDE_DIRECTORIES ${DataPipes_INCLUDE_DIR}
            )
        endif()
    endif ()

    find_package_handle_standard_args(DataPipes DEFAULT_MSG
            DataPipes_INCLUDE_DIR
    )

    mark_as_advanced(
            DataPipes_ROOT_DIR
            DataPipes_INCLUDE_DIR
            STATIC_CORE_LIBRARY
            STATIC_RTC_LIBRARY
            SHARED_CORE_LIBRARY
            SHARED_RTC_LIBRARY
    )
endfunction()
find_datapipes()