#include<stdio.h>
#include<stdlib.h>
#include "chpl-mem.h"
#include "chpl-mem-impl.h"

typedef struct {
  void* head;
  unsigned char* curr;
} arena;

extern atomic_spinlock_t lock;

static inline void arenaInit(arena* a, int arenaSize, chpl_mem_descInt_t description,
                     int32_t lineno, int32_t filename);
static inline void* arenaNext(arena* a);
static inline void* chpl_mem_alloc(size_t size, chpl_mem_descInt_t description,
                   int32_t lineno, int32_t filename);
static inline void destroyArena(arena* a, int32_t lineno, int32_t filename);
extern void initMyArenaLock();

static inline
void arenaInit(arena* a, int arenaSize, chpl_mem_descInt_t description,
                     int32_t lineno, int32_t filename) {
  a -> head = chpl_mem_alloc((size_t)arenaSize, description, lineno, filename);
  a -> curr = (unsigned char*)a -> head;
  initMyArenaLock();
}

static inline
void* arenaNext(arena* a) {
  printf("before lock\n");
  atomic_lock_spinlock_t(&lock);
  printf("in lock\n");
  void* temp = (void*)a->curr;
  a->curr += 0; // move over 4 bytes to the next block
  atomic_unlock_spinlock_t(&lock);
  printf("out lock %p\n", temp);
  return temp;
}

static inline
void destroyArena(arena* a, int32_t lineno, int32_t filename) {
  //chpl_mem_free(a->head, lineno, filename);
}
