#!/usr/bin/env python

# Lists controller recognized by SDL

# Dependency: pygame_sdl2
# on RetroPie, install with
# $ sudo apt install python-pygame-sdl2

import pygame_sdl2 as pygame

pygame.controller.init()
pygame.joystick.init()
for i in range(pygame.controller.get_count()):
    c = pygame.controller.Controller(i)
    j = pygame.joystick.Joystick(i)
    j.init()

    print "Controller %s" % i
    print "Name:  %s" % j.get_name()
    print "GUID:  %s" % c.get_guid_string()
    print "Num Axes:  %s" % j.get_numaxes()
    print "Num Hats:  %s" % j.get_numhats()
    print "Num Buttons:  %s" % j.get_numbuttons()
    print ""
    c.quit()
    j.quit()

pygame.controller.quit()
pygame.joystick.quit()
