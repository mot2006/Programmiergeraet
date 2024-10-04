# Ordner 
BUILD_DIR = Ausgabe
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin

# Toolchain
CC = avr-gcc
RM = rm

# Dateien
Ziel = $(BIN_DIR)/Programm

SOURCES = main.c

OBJECT_NAMES = $(SOURCES:.c=.o)
OBJECTS = $(patsubst %,$(OBJ_DIR)/%,$(OBJECT_NAMES))

#Flags
MCU = atmega2560
WFLAGS = -Wall -Wextra -Werror -Wshadow
CFLAGS = -mmcu=$(MCU) $(WFLAGS) $(addprefix -I,$(INCLUDE_DIRS)) -Og -g
LDFLAGS = -mmcu=$(MCU)

#Build
$(Ziel): $(OBJECTS)
	@mkdir -p $(dir $@)
	$(CC) -DF_CPU=16000000UL $(LDFLAGS) $^ -o $@

# Compiling
$(OBJ_DIR)/%.o: Hauptdateien/%.c
	@mkdir -p $(dir $@)
	$(CC) -DF_CPU=16000000UL $(CFLAGS) -c -o $@ $^

# Phonies
.PHONY: all clean

all: $(Ziel)

clean:
	@$(RM) -R $(BUILD_DIR) 
