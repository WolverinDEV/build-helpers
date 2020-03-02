# - Try to find openssl include dirs and libraries
#
# Usage of this module as follows:
#
#     find_package(Crypto)
#
# Variables used by this module, they can change the default behaviour and need
# to be set before calling find_package:
#
#  Crypto_ROOT_DIR          Set this variable to the root installation of
#                            openssl if the module has problems finding the
#                            proper installation path.
#
# Variables defined by this module:
#
#  Crypto_FOUND             System has openssl, include and library dirs found
#  Crypto_INCLUDE_DIR       The openssl include directories.
#  Crypto_LIBRARIES         The openssl libraries.
#  Crypto_CRYPTO_LIBRARY    The openssl crypto library.
#  Crypto_SSL_LIBRARY       The openssl ssl library.
#  Crypto_OPENSSL           Set if crypto is openssl
#  Crypto_openssl         Set if crypto is openssl

include(FindPackageHandleStandardArgs)

find_path(Crypto_INCLUDE_DIR
        NAMES openssl/ssl.h openssl/base.h openssl/hkdf.h include/openssl/opensslv.h
        HINTS ${Crypto_ROOT_DIR}/include
)

#detect if its openssl or openssl
file(READ "${Crypto_INCLUDE_DIR}/openssl/crypto.h" Crypto_CRYPTO_H)
if(Crypto_CRYPTO_H MATCHES ".*Google Inc.*" OR Crypto_CRYPTO_H MATCHES ".*openssl.*")
    set(Crypto_BORINGSSL 1)
elseif(Crypto_CRYPTO_H MATCHES ".*to the OpenSSL project.*" OR Crypto_CRYPTO_H MATCHES ".*OpenSSL Project Authors.*")
    set(Crypto_OPENSSL 1)
endif()

if (NOT TARGET openssl::crypto::shared)
    find_library(CRYPTO_CRYPTO_SHARED
            NAMES libcrypto.so crypto.dll crypto.lib
            HINTS ${Crypto_ROOT_DIR} ${Crypto_ROOT_DIR}/lib
    )

    if (CRYPTO_CRYPTO_SHARED)
        add_library(openssl::crypto::shared SHARED IMPORTED)
        set_target_properties(openssl::crypto::shared PROPERTIES
                IMPORTED_LOCATION ${CRYPTO_CRYPTO_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${Crypto_INCLUDE_DIR}
        )
    endif ()
endif ()

if (NOT TARGET openssl::ssl::shared)
    find_library(CRYPTO_SSL_SHARED
            NAMES libssl.so
            HINTS ${Crypto_ROOT_DIR} ${Crypto_ROOT_DIR}/lib
    )

    if (CRYPTO_SSL_SHARED)
        add_library(openssl::ssl::shared SHARED IMPORTED)
        set_target_properties(openssl::ssl::shared PROPERTIES
                IMPORTED_LOCATION ${CRYPTO_SSL_SHARED}
                INTERFACE_INCLUDE_DIRECTORIES ${Crypto_INCLUDE_DIR}
        )
    endif ()
endif ()

if (NOT TARGET openssl::crypto::static)
    find_library(CRYPTO_CRYPTO_STATIC
            NAMES libcrypto.a
            HINTS ${Crypto_ROOT_DIR} ${Crypto_ROOT_DIR}/lib
    )

    if (CRYPTO_CRYPTO_STATIC)
        add_library(openssl::crypto::static STATIC IMPORTED)
        set_target_properties(openssl::crypto::static PROPERTIES
                IMPORTED_LOCATION ${CRYPTO_CRYPTO_STATIC}
                INTERFACE_INCLUDE_DIRECTORIES ${Crypto_INCLUDE_DIR}
        )
    endif ()
endif ()

if (NOT TARGET openssl::ssl::static)
    find_library(CRYPTO_SSL_STATIC
            NAMES libssl.a
            HINTS ${Crypto_ROOT_DIR} ${Crypto_ROOT_DIR}/lib
    )

    if (CRYPTO_SSL_STATIC)
        add_library(openssl::ssl::static STATIC IMPORTED)
        set_target_properties(openssl::ssl::static PROPERTIES
                IMPORTED_LOCATION ${CRYPTO_SSL_STATIC}
                INTERFACE_INCLUDE_DIRECTORIES ${Crypto_INCLUDE_DIR}
        )
    endif ()
endif ()


find_package_handle_standard_args(Crypto DEFAULT_MSG Crypto_INCLUDE_DIR)
mark_as_advanced(
        Crypto_ROOT_DIR
        Crypto_INCLUDE_DIR
        Crypto_LIBRARIES
        Crypto_SSL_LIBRARY
        Crypto_CRYPTO_LIBRARY
        Crypto_OPENSSL
        Crypto_openssl
)