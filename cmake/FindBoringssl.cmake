# - Try to find Boringssl include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(Boringssl)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  Boringssl_ROOT_DIR          Set this variable to the root installation of
#                            Boringssl if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  Boringssl_FOUND             System has Boringssl, include and library dirs found
#  Boringssl_INCLUDE_DIR       The Boringssl include directories.

include(tearoot-helper)
include(FindPackageHandleStandardArgs)

find_path(Boringssl_INCLUDE_DIR
        NAMES openssl/opensslv.h
        HINTS ${Boringssl_ROOT_DIR} ${Boringssl_ROOT_DIR}/include/
)

if (NOT TARGET openssl::crypto::shared)
    find_library(Boringssl_CRYPTO_SHARED
            NAMES libcrypto.so
            HINTS ${Boringssl_ROOT_DIR} ${Boringssl_ROOT_DIR}/lib
            )

    if (Boringssl_CRYPTO_SHARED)
        add_library(openssl::crypto::shared SHARED IMPORTED)
        set_target_properties(openssl::crypto::shared PROPERTIES
                IMPORTED_LOCATION ${Boringssl_CRYPTO_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${Boringssl_INCLUDE_DIR}
                )
    endif ()
endif ()

if (NOT TARGET openssl::ssl::shared)
    find_library(Boringssl_SSL_SHARED
            NAMES libssl.so
            HINTS ${Boringssl_ROOT_DIR} ${Boringssl_ROOT_DIR}/lib
            )

    if (Boringssl_SSL_SHARED)
        add_library(openssl::ssl::shared SHARED IMPORTED)
        set_target_properties(openssl::ssl::shared PROPERTIES
                IMPORTED_LOCATION ${Boringssl_SSL_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${Boringssl_INCLUDE_DIR}
                )
    endif ()
endif ()

find_package_handle_standard_args(Boringssl DEFAULT_MSG
        Boringssl_INCLUDE_DIR
)

mark_as_advanced(
        Boringssl_ROOT_DIR
        Boringssl_INCLUDE_DIR
        Boringssl_LIBRARIES_STATIC
        Boringssl_LIBRARIES_SHARED
)