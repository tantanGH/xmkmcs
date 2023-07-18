TARGET = lze

CC = gcc
LD = gcc

CFLAGS = -O2 -Wall -DCLK_TCK=CLOCKS_PER_SEC
LDFLAGS = 
LIBS = 

OBJS = lze.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f *.o $(TARGET)
