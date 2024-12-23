.DEFAULT_GOAL := all

TARGET := pb-tester

BUILD_DIR := .build
STATIC_BUILD_DIR := $(BUILD_DIR)/x86_64-swift-linux-musl
DEBUG_TARGET   := debug/$(TARGET)
RELEASE_TARGET := release/$(TARGET)

DEBUG   := $(BUILD_DIR)/$(DEBUG_TARGET)
RELEASE := $(BUILD_DIR)/$(RELEASE_TARGET)

DEBUG_FLAGS   :=
RELEASE_FLAGS := -c release

STATIC_DEBUG   := $(STATIC_BUILD_DIR)/$(DEBUG_TARGET)
STATIC_RELEASE := $(STATIC_BUILD_DIR)/$(RELEASE_TARGET)

STATIC_FLAGS := --swift-sdk x86_64-swift-linux-musl
STATIC_DEBUG_FLAGS   := $(STATIC_FLAGS)
STATIC_RELEASE_FLAGS := $(STATIC_FLAGS) $(RELEASE_FLAGS)

SOURCES := Package.swift Sources/pb-tester/**.swift Sources/nyPB/**.swift


$(DEBUG): $(SOURCES)
	swift build $(DEBUG_FLAGS)

$(RELEASE): $(SOURCES)
	swift build $(RELEASE_FLAGS)

debug:   $(DEBUG)
release: $(RELEASE)

$(STATIC_DEBUG):
	swift build $(STATIC_DEBUG_FLAGS)

$(STATIC_RELEASE):
	swift build $(STATIC_RELEASE_FLAGS)

static-debug: $(STATIC_DEBUG)
static-release: $(STATIC_RELEASE)

# Currently static builds with URLSession seem to be broken due to SSL issues
# Error Domain=NSURLErrorDomain Code=-1 "(null)": SSL certificate problem: unable to get local issuer certificate
# So for now they're removed from all

all: debug release # static-debug static-release

ZIPFILE := $(TARGET)-$(shell git log -1 --format=%h)-$(shell date -u +'%Y.%m.%d').zip
$(ZIPFILE): all
	mkdir -p builds/debug builds/release # builds/static-debug builds/static-release
	@cp $(DEBUG) builds/debug/
	@cp $(RELEASE) builds/release/
	#@cp $(STATIC_DEBUG) builds/static-debug/
	#@cp $(STATIC_RELEASE) builds/static-release/
	strip builds/**/$(TARGET)
	zip -r $(ZIPFILE) builds/
	rm -r builds/

zip: $(ZIPFILE)

INSTALL_TARGET := ~/.swiftpm/bin/$(TARGET)
$(INSTALL_TARGET): $(RELEASE)

install: $(INSTALL_TARGET)
	@test ! -f $(INSTALL_TARGET) && \
	 cp $(RELEASE) $(INSTALL_TARGET) && \
	 strip $(INSTALL_TARGET) && \
	 echo "cp $(RELEASE) $(INSTALL_TARGET) && strip $(INSTALL_TARGET)" || \
	 echo "Nothing to be done!"

uninstall: $(INSTALL_TARGET)
	@test -f $(INSTALL_TARGET) && \
	 rm $(INSTALL_TARGET) && \
	 echo "rm $(INSTALL_TARGET)" || \
	 echo "Nothing to be done!"

reinstall: uninstall install

CLEAN_TARGETS := $(DEBUG) $(RELEASE) $(STATIC_DEBUG) $(STATIC_RELEASE) $(ZIPFILE)
clean:
	$(foreach fi,$(CLEAN_TARGETS),rm -f $(fi);)

.PHONY := clean
