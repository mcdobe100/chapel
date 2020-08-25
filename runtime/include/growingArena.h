#include<stdio.h>
#include<stdlib.h>
#include "chpl-mem.h"
#include "chpl-mem-impl.h"

typedef struct {
  chunk* chunks[5];
  int currChunk;
  void* head;
  unsigned char* curr;
} arena;

typedef struct {
  void* mem;
  int size;
  int used;
} chunk;

static atomic_spinlock_t lock;

static inline void growingArenaInit(arena* a, int arenaSize, chpl_mem_descInt_t description,
                     int32_t lineno, int32_t filename);

static inline void* growingArenaNext(arena* a);

static inline void* chpl_mem_alloc(size_t size, chpl_mem_descInt_t description,
                   int32_t lineno, int32_t filename);

static inline
void growingArenaInit(arena* a, int arenaSize, chpl_mem_descInt_t description,
                     int32_t lineno, int32_t filename) {
  a -> currChunk = 0;
  a -> chunks[0] -> mem = chpl_mem_alloc((size_t)arenaSize, description, lineno, filename);
  a -> chunks[0] -> size = arenaSize;
  a -> chunks[0] -> used = 0;
  a -> head = a -> chunks[0] -> mem;
  a -> curr = (unsigned char*)a -> head;
  atomic_init_spinlock_t(&lock);
}

static inline
void* growingArenaNext(arena* a) {
  atomic_lock_spinlock_t(&lock);

  if(a->chunks[a->currChunk]-> used + 50 >= a->chunks[a->currChunk]-> size)
    return head;
  void* temp = (void*)a->curr;
  a->curr += 50; // move over 4 bytes to the next block

  atomic_unlock_spinlock_t(&lock);
  return temp;
}
