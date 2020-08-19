#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include "chpl-mem.h"

#define POOL_BLOCKS_INITIAL 10000

typedef struct poolFreed{
	struct poolFreed *nextFree;
} poolFreed;

typedef struct {
	uint32_t elementSize;
	uint32_t blockSize;
	uint32_t used;
	int32_t block;
	poolFreed *freed;
	uint32_t blocksUsed;
	uint8_t **blocks;
} pool;

static inline void poolInitialize(pool *p, const uint32_t elementSize, const uint32_t blockSize);
static inline void poolFreePool(pool *p);

#ifndef DISABLE_MEMORY_POOLING
static inline void *poolMalloc(pool *p);
static inline void poolFree(pool *p, void *ptr);
#else
#include <stdlib.h>
#define poolMalloc(p) malloc((p)->blockSize)
#define poolFree(p, d) free(d)
#endif
static inline void poolFreeAll(pool *p);


#ifndef max
#define max(a,b) ((a)<(b)?(b):(a))
#endif

static inline void* chpl_malloc(size_t size);

static inline 
void poolInitialize(pool *p, const uint32_t elementSize, const uint32_t blockSize)
{
	uint32_t i;

	p->elementSize = max(elementSize, sizeof(poolFreed));
	p->blockSize = blockSize;
	
	poolFreeAll(p);

	p->blocksUsed = POOL_BLOCKS_INITIAL;
	p->blocks = chpl_malloc(sizeof(uint8_t*)* p->blocksUsed);
  
	for(i = 0; i < p->blocksUsed; ++i)
		p->blocks[i] = NULL;
}

static inline 
void poolFreePool(pool *p)
{
	uint32_t i;
	for(i = 0; i < p->blocksUsed; ++i) {
		if(p->blocks[i] == NULL)
			break;
		else
			free(p->blocks[i]);
	}

	free(p->blocks);
}

#ifndef DISABLE_MEMORY_POOLING
static inline 
void *poolMalloc(pool *p)
{
	if(p->freed != NULL) {
		void *recycle = p->freed;
		p->freed = p->freed->nextFree;
		return recycle;
	}

	if(++p->used == p->blockSize) {
		p->used = 0;
		if(++p->block == (int32_t)p->blocksUsed) {
			uint32_t i;

			p->blocksUsed <<= 1;
			p->blocks = realloc(p->blocks, sizeof(uint8_t*)* p->blocksUsed);

			for(i = p->blocksUsed >> 1; i < p->blocksUsed; ++i)
				p->blocks[i] = NULL;
		}

		if(p->blocks[p->block] == NULL)
			p->blocks[p->block] = chpl_malloc(p->elementSize * p->blockSize);
	}
	
	return p->blocks[p->block] + p->used * p->elementSize;
}

static inline 
void poolFree(pool *p, void *ptr)
{
	poolFreed *pFreed = p->freed;

	p->freed = ptr;
	p->freed->nextFree = pFreed;
}
#endif

static inline 
void poolFreeAll(pool *p)
{
	p->used = p->blockSize - 1;
	p->block = -1;
	p->freed = NULL;
}
