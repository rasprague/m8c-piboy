// Copyright 2021 Jonne Kokkonen
// Released under the MIT licence, https://opensource.org/licenses/MIT

#ifndef _SERIAL_H_
#define _SERIAL_H_

#include <libserialport.h>

struct sp_port *init_serial(int verbose);

#endif
