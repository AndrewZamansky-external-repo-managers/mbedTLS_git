/*
 * Copyright 2019-2020 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * You may not use this file except in compliance with the terms and conditions
 * set forth in the accompanying LICENSE.TXT file.
 *
 * THESE MATERIALS ARE PROVIDED ON AN "AS IS" BASIS. AMAZON SPECIFICALLY
 * DISCLAIMS, WITH RESPECT TO THESE MATERIALS, ALL WARRANTIES, EXPRESS,
 * IMPLIED, OR STATUTORY, INCLUDING THE IMPLIED WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
 */

/* This file declares mutex functions for mbed TLS using platform mutexes. */

#ifndef THREADING_ALT_H_
#define THREADING_ALT_H_

/* Standard includes. */
#include <stdbool.h>

/* Represents a mutex used by mbed TLS. */
typedef struct mbedtls_threading_mutex
{
    /* Whether this mutex is valid. */
    bool valid;
    /* The wrapped platform mutex. */
    void* mutex;
} mbedtls_threading_mutex_t;

#endif /* ifndef THREADING_ALT_H_ */
