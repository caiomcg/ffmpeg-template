CC = g++

# Folders
SRCDIR := src
BUILDDIR := build
TARGETDIR := bin

# Targets
EXECUTABLE := CHANGE_TO_SOMETHING_ELES
TARGET := $(TARGETDIR)/$(EXECUTABLE)

# Final Paths
INSTALLBINDIR := /usr/local/bin

# Code Lists
SRCEXT := cpp
HEADEREXT := h
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))

# Folder Lists
INCDIRS := $(shell find $(SRCDIR)/**/* -name '*.$(SRCEXT)' -exec dirname {} \; | sort | uniq)
INCLIST := $(patsubst $(SRCDIR)/%,-I $(SRCDIR)/%,$(INCDIRS))
BUILDLIST := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(INCDIRS))

FFMPEG_LIB := `pkg-config --libs libavformat` `pkg-config --libs libavdevice` `pkg-config --libs libavcodec` `pkg-config --libs libavutil` `pkg-config --libs libswscale` `pkg-config --libs libswresample`

# Shared Compiler Flags
CFLAGS := -std=c++17 -O3 -Wall -Wextra
INC := $(INCLIST) -I /usr/local/include
LIB := $(FFMPEG_LIB) -lm

ifeq ($(debug), 1)
CFLAGS += -g -ggdb3 -D DEBUG
else
CFLAGS += -DNDEBUG
endif

ifeq ($(debug), 2)
CFLAGS += -g -ggdb3 -D DEBUG -D DEBUG_EXTRA
else
CFLAGS += -DNDEBUG
endif

$(TARGET): $(OBJECTS)
	@mkdir -p $(TARGETDIR)
	@echo  "Linking all targets..."
	@$(CC) $^ -o $(TARGET) $(LIB)

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDLIST)
	@echo "CC    $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

clean:
	@echo "Cleaning $(TARGET)"; $(RM) -r $(BUILDDIR) $(TARGETDIR)

distclean:
	@echo "Removing $(EXECUTABLE) "; rm $(INSTALLBINDIR)/$(EXECUTABLE)

run:
	${TARGET}

.PHONY: clean
