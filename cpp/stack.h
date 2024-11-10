// A class for an expandable stack. There is already a stack class in the
// Standard C++ Library; this class serves as an exercise for students to
// learn the mechanics of building generic, expandable, data structures
// from scratch with smart pointers.

#include <stdexcept>
#include <string>
#include <memory>
using namespace std;

// A stack object wraps a low-level array indexed from 0 to capacity-1 where
// the bottommost element (if it ex ists) will be in slot 0. The member top is
// the index of the slot above the top element, i.e. the next available slot
// that an element can go into. Therefore if top==0 the stack is empty and
// if top==capacity it needs to be expanded before pushing another element.
// However for security there is still a super maximum capacity that cannot
// be exceeded.

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
  unique_ptr<T[]> elements;
  int capacity;
  int top;

  // Prohibit copying and assignment
  Stack(const Stack<T>&) = delete;
  Stack<T>& operator=(const Stack<T>&) = delete;

public:
  // Constructor
  Stack() : top(0), capacity(INITIAL_CAPACITY), elements(make_unique<T[]>(INITIAL_CAPACITY)) {}

  // Returns the number of elements in the stack
  int size() const {
    return top;
  }

  // Checks if the stack is empty
  bool is_empty() const {
    return top == 0;
  }

  // Checks if the stack has reached its current capacity
  bool is_full() const {
    return top == capacity;
  }

  // Adds an item to the stack
  void push(T item) {
    if (top == MAX_CAPACITY) {
      throw overflow_error("Stack has reached maximum capacity");
    }
    if (top == capacity) {
      reallocate(2 * capacity);
    }
    elements[top++] = item;
  }

  // Removes and returns the top item of the stack
  T pop() {
    if (is_empty()) {
      throw underflow_error("Cannot pop from empty stack");
    }
    T item = elements[--top]; // Retrieve the top element and decrement top
    elements[top] = T(); // Clear the slot for security

    // Shrink capacity if the stack is less than 25% full, but not below INITIAL_CAPACITY
    if (top > 0 && top <= capacity / 4 && capacity > INITIAL_CAPACITY) {
      reallocate(capacity / 2);
    }
    return item;
  }

private:
  // Reallocate stack capacity within bounds, preserving existing elements
  void reallocate(int new_capacity) {
    if (new_capacity > MAX_CAPACITY) {
      new_capacity = MAX_CAPACITY;
    }
    if (new_capacity < INITIAL_CAPACITY) {
      new_capacity = INITIAL_CAPACITY;
    }
    auto new_elements = make_unique<T[]>(new_capacity);
    copy(&elements[0], &elements[top], &new_elements[0]); // Copy elements up to current top
    elements = move(new_elements); // Move new array to elements
    capacity = new_capacity;
  }
};