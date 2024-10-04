# Ordner 
BUILD_DIR = Ausgabe
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin
SERIAL_PORT = /dev/ttyACM0

# Toolchain
CC = avr-gcc
OBJCP = avr-objcopy
DUDE = avrdude
RM = rm

# Dateien
Ziel = $(BIN_DIR)/Programm

SOURCES = main.c

OBJECT_NAMES = $(SOURCES:.c=.o)
OBJECTS = $(patsubst %,$(OBJ_DIR)/%,$(OBJECT_NAMES))

#Flags
MCU = atmega2560
CLK = 16000000UL
PTYPE = wiring
BAUD = 115200
WFLAGS = -Wall -Wextra -Werror -Wshadow
CFLAGS = -mmcu=$(MCU) $(WFLAGS) $(addprefix -I,$(INCLUDE_DIRS)) -Og -g
LDFLAGS = -mmcu=$(MCU)
CLFLAGS = -DF_CPU=$(CLK)

# Build
$(Ziel).hex: $(Ziel)
	$(OBJCP) -j .text -j .data -O ihex $^ $@

# Linking
$(Ziel): $(OBJECTS)
	@mkdir -p $(dir $@)
	$(CC) $(CLFLAGS) $(LDFLAGS) $^ -o $@

# Compiling
$(OBJ_DIR)/%.o: Hauptdateien/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CLFLAGS) $(CFLAGS) -c -o $@ $^

# Phonies
.PHONY: clean flash

clean:
	@$(RM) -R $(BUILD_DIR) 

flash: $(Ziel).hex
	sudo $(DUDE) -p$(MCU) -c$(PTYPE) -P$(SERIAL_PORT) -b$(BAUD) -D -U flash:w:$<:i  

