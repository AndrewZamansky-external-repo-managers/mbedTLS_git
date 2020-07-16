#include "project_config.h"
#include "_project_typedefs.h"
#include "_project_defines.h"

#include "os_wrapper.h"
#include <mbedtls/threading.h>

void Sleep(uint32_t msec)
{
	os_delay_ms(msec);
}


/**
 * Initializes a new mutex. Used by mbed TLS to provide thread-safety.
 *
 * Sets the valid member of `mbedtls_threading_mutex_t`.
 *
 * @param[in] mbedtlsMutex The mutex to initialize.
 */
static void mutex_init(
    mbedtls_threading_mutex_t* mbedtlsMutex )
{
    mbedtlsMutex->mutex = os_create_mutex();
    if( NULL == mbedtlsMutex->mutex )
    {
        mbedtlsMutex->valid = false;
    }
    else
    {
    	mbedtlsMutex->valid = true;
    }
}

/**
 * Frees a mutex. Used by mbed TLS to provide thread-safety.
 *
 * @param[in] mbedtlsMutex The mutex to destroy.
 */
static void mutex_free(
    mbedtls_threading_mutex_t* mbedtlsMutex )
{
    if( mbedtlsMutex->valid == true )
    {
        //TODO
    }
}

/**
 * Locks a mutex. Used by mbed TLS to provide thread-safety.
 *
 * @param[in] mbedtlsMutex The mutex to lock.
 *
 * @return `0` on success; one of `MBEDTLS_ERR_THREADING_BAD_INPUT_DATA`
 * or `MBEDTLS_ERR_THREADING_MUTEX_ERROR` on error.
 */
static int mutex_lock(
    mbedtls_threading_mutex_t* mbedtlsMutex )
{
    int status = 0;

    if( mbedtlsMutex->valid == false )
    {
        status = MBEDTLS_ERR_THREADING_BAD_INPUT_DATA;
    }
    else
    {
    	os_mutex_take_infinite_wait( mbedtlsMutex->mutex );
    }

    return status;
}

/**
 * Unlocks a mutex. Used by mbed TLS to provide thread-safety.
 *
 * @param[in] mbedtlsMutex The mutex to unlock.
 *
 * @return `0` on success; one of `MBEDTLS_ERR_THREADING_BAD_INPUT_DATA`
 * or `MBEDTLS_ERR_THREADING_MUTEX_ERROR` on error.
 */
static int mutex_unlock(
    mbedtls_threading_mutex_t* mbedtlsMutex )
{
    int status = 0;

    if( mbedtlsMutex->valid == false )
    {
        status = MBEDTLS_ERR_THREADING_BAD_INPUT_DATA;
    }
    else
    {
    	os_mutex_give( mbedtlsMutex->mutex );
    }

    return status;
}


#warning "add hardware entropy"
int mbedtls_hardware_poll( void *data,
                    unsigned char *output, size_t len, size_t *olen )
{
    ((void) data);
    ((void) output);
    *olen = 0;

    if( len < sizeof(unsigned char) )
        return( 0 );

    *olen = sizeof(unsigned char);

    return( 0 );
}


void mbedtls_port_init()
{
    /* Set the mutex functions for mbed TLS thread safety. */
    mbedtls_threading_set_alt(
        mutex_init, mutex_free, mutex_lock, mutex_unlock );
}
