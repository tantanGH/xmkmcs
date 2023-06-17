TARGET1 = lze
TARGET2 = lzed

CC = gcc
LD = gcc

CFLAGS = -O2 -Wall
LDFLAGS = 
LIBS = 

OBJS1 = lze.o
OBJS2 = lzed.o lzedec.o

all: $(TARGET1) $(TARGET2)

$(TARGET1): $(OBJS1)
	$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)

$(TARGET2): $(OBJS2)
	$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f *.o $(TARGET1) $(TARGET2)
