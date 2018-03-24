export TARGET=iphone::11.2:11.0
ARCHS = arm64
DEBUG = 1
GO_EASY_ON_ME = 1
COLOR = 0
FORCE_COLOR = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iNDT
$(TWEAK_NAME)_FILES = $(wildcard *.m) Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_LDFLAGS += -F./
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
