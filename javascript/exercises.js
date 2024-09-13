import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

// Write your first then lower case function here


export function firstThenLowerCase(arr,predicate){
  return arr.find(predicate)?.toLowerCase();
}




// Write your powers generator here 

export function* powersGenerator({ ofBase, upTo }) {
  let power = 1; // Start with 1, which is ofBase^0

  while (power <= upTo) { 
    yield power;
    power *= ofBase; // Compute the next power
  }
}


// Write your say function here
export function say(word) {
  let words = word !== undefined ? [word] : [];

  function chain(nextWord) {
      if (nextWord !== undefined) {
          words.push(nextWord);
          return chain;
      } else {
          return words.join(' ');
      }
  }

  
  // so say() returns empty string
  if (word === undefined) {
      return '';
  }

  return chain;
}



// Write your line count function here

// Write your Quaternion class here
