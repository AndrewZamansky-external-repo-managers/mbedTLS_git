
MBEDTLS_GIT_COMMIT_HASH :="d411098b8b949b47b254d9c0fbb7bae84ca46285"

MBEDTLS_PATH :=$(EXTERNAL_SOURCE_ROOT_DIR)/mbedTLS
ifeq ("$(wildcard $(MBEDTLS_PATH))","")
    MBEDTLS_URL :=https://github.com/ARMmbed/mbedtls
    $(info   )
    $(info --- mbedTLS path $(MBEDTLS_PATH) dont exists )
    $(info --- get repo from andew zamansky or from $(MBEDTLS_URL))
    $(info --- make sure that .git directory is located)
    $(info --- in $(MBEDTLS_PATH)/  after unpacking)
    $(error )
endif

# test if current commit and branch of mbedTLS git is the same
# as required by application.
# CURR_COMPONENT_DIR is pointing to parent directory
CURR_GIT_REPO_DIR :=$(MBEDTLS_PATH)
CURR_GIT_COMMIT_HASH_VARIABLE :=MBEDTLS_GIT_COMMIT_HASH
CURR_GIT_BUNDLE :=$(CURR_COMPONENT_DIR)/mbedTLS_git/mbedTLS_20200707.bundle
include $(MAKEFILES_ROOT_DIR)/_include_functions/git_prebuild_repo_check.mk

DUMMY := $(call ADD_TO_GLOBAL_INCLUDE_PATH , $(MBEDTLS_PATH)/include)

ifeq ($(CONFIG_HOST),y)
    DEFINES += COMPILING_FOR_HOST
    ifeq ($(findstring WINDOWS,$(COMPILER_HOST_OS)),WINDOWS)
        ifdef CONFIG_MICROSOFT_COMPILER
            # disable warning C4127: conditional expression is constant
            CFLAGS += /wd4127
            # disable warning C4204: nonstandard
            # extension used : non-constant aggregate initializer
            CFLAGS += /wd4204
            # disable warning C4214: nonstandard
            # extension used : bit field types other than int
            CFLAGS += /wd4214
            DEFINES += _CRT_SECURE_NO_WARNINGS
        endif
        DEFINES += COMPILING_FOR_WINDOWS_HOST
    else
        DEFINES += COMPILING_FOR_LINUX_HOST
    endif
endif

# CURR_COMPONENT_DIR is pointing to parent directory
INCLUDE_DIR +=$(CURR_COMPONENT_DIR)/mbedTLS_git/include
DEFINES += MBEDTLS_CONFIG_FILE="ucprojects_config_mbedtls.h"
DEFINES += MBEDTLS_NO_PLATFORM_ENTROPY

INCLUDE_DIR +=$(MBEDTLS_PATH)/include

# following macro was added from some gcc version (at least from 9.2)
# defining it will open typdefs like ulong
DEFINES += _GNU_SOURCE


DEFINES += MBEDTLS_SSL_SESSION_TICKETS MBEDTLS_SSL_RENEGOTIATION
DEFINES +=  MBEDTLS_VERSION_C MBEDTLS_PK_WRITE_C MBEDTLS_X509_CRL_PARSE_C

SRC += library/hmac_drbg.c
SRC += library/ecdsa.c
SRC += library/pk_wrap.c
SRC += library/rsa_internal.c
SRC += library/rsa.c
SRC += library/asn1write.c
SRC += library/ssl_cli.c
SRC += library/oid.c
SRC += library/x509.c
SRC += library/asn1parse.c
SRC += library/pkwrite.c
SRC += library/version.c
SRC += library/x509_crt.c
SRC += library/x509_crl.c
SRC += library/ssl_ciphersuites.c
SRC += library/pkparse.c
SRC += library/pem.c
SRC += library/net_sockets.c
SRC += library/error.c
SRC += library/ecp_curves.c
SRC += library/ecdh.c
SRC += library/bignum.c
SRC += library/ctr_drbg.c
SRC += library/md.c
SRC += library/hkdf.c
SRC += library/gcm.c
SRC += library/entropy.c
SRC += library/base64.c
SRC += library/platform_util.c
SRC += library/cipher.c
SRC += library/sha512.c
SRC += library/ecp.c
SRC += library/md_wrap.c
SRC += library/sha1.c
SRC += library/ripemd160.c
SRC += library/md5.c
SRC += library/sha256.c
SRC += library/entropy_poll.c
SRC += library/aes.c
SRC += library/ccm.c
SRC += library/chachapoly.c
SRC += library/chacha20.c
SRC += library/cipher_wrap.c
SRC += library/arc4.c
SRC += library/blowfish.c
SRC += library/camellia.c
SRC += library/des.c
SRC += library/poly1305.c
SRC += library/threading.c
SRC += library/ssl_tls.c
SRC += library/pk.c
SRC += library/timing.c

DEFINES += DEBUG_MBEDTLS
#SRC += wolfcrypt/src/logging.c

SPEED_CRITICAL_FILES += $(SRC)
VPATH += | $(MBEDTLS_PATH)

SRC += src/port.c
VPATH += | $(CURR_COMPONENT_DIR)/mbedTLS_git

DISABLE_GLOBAL_INCLUDES_PATH := y


include $(COMMON_CC)
