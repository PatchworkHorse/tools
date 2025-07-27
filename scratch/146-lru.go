package main

type Node struct {
	Value int
	Key   int
	Prev  *Node
	Next  *Node
}

type LRUCache struct {
	Capacity int
	Head     *Node         // Most recently used
	Tail     *Node         // Least recently used; subject to eviction
	CacheMap map[int]*Node // Refs to nodes for arbitrary lookup, position agnostic
}

func Constructor(capacity int) LRUCache {
	// Init list, link together
	h, t := &Node{}, &Node{}
	h.Next = t
	t.Prev = h

	return LRUCache{
		Capacity: capacity,
		CacheMap: make(map[int]*Node, capacity),
		Head:     h,
		Tail:     t,
	}
}

func (this *LRUCache) Get(key int) int {
	target := this.CacheMap[key]

	if target == nil {
		return -1
	}

	this.ToHead(target)
	return target.Value
}

func (this *LRUCache) Put(key int, value int) {

	// Key exists; Update value and move to head
	if item, exists := this.CacheMap[key]; exists {
		item.Value = value
		this.ToHead(item)
		return
	}

	// Key does not exist; Create entry
	newNode := &Node{Key: key, Value: value}
	this.ToHead(newNode)
	this.CacheMap[key] = newNode
	this.Constrain()

}

func (cache *LRUCache) ToHead(mru *Node) {

	if cache.Head.Next == mru {
		return
	}

	// Detach
	if mru.Prev != nil && mru.Next != nil {
		mru.Prev.Next = mru.Next
		mru.Next.Prev = mru.Prev
	}

	// Update target refs
	mru.Prev = cache.Head
	mru.Next = cache.Head.Next

	// Update former head refs
	cache.Head.Next.Prev = mru

	// Update sentinel
	cache.Head.Next = mru
}

func (cache *LRUCache) Constrain() {
	if len(cache.CacheMap) <= cache.Capacity {
		return
	}

	lru := cache.Tail.Prev
	if lru != cache.Head {
		lru.Prev.Next = cache.Tail
		cache.Tail.Prev = lru.Prev
		delete(cache.CacheMap, lru.Key)
	}
}
