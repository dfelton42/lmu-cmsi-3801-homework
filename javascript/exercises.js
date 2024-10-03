import { open } from "node:fs/promises"
import fs from 'fs/promises';

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

export async function meaningfulLineCount(fileName) {
  try {
    const data = await fs.readFile(fileName, 'utf-8');
    const lines = data.split('\n');
    
    return lines.filter(line => {
      const trimmed = line.trim();
      // Exclude empty lines, comments, and lines starting with '#'
      return trimmed !== '' && !trimmed.startsWith('#');
    }).length;
  } catch (error) {
    if (error.code === 'ENOENT') {
      throw new Error('No such file');
    }
    throw new Error('Error reading the file');
  }
}


// Write your Quaternion class here
export class Quaternion {
  constructor(a, b, c, d) {
    this.a = a; // Real part
    this.b = b; // i component
    this.c = c; // j component
    this.d = d; // k component

    Object.freeze(this); // Make quaternion constant
  }

  get coefficients() {
    return [this.a, this.b, this.c, this.d];
  }

  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }

  plus(q) {
    return new Quaternion(
      this.a + q.a,
      this.b + q.b,
      this.c + q.c,
      this.d + q.d
    );
  }

  times(q) {
    const a = this.a * q.a - this.b * q.b - this.c * q.c - this.d * q.d;
    const b = this.a * q.b + this.b * q.a + this.c * q.d - this.d * q.c;
    const c = this.a * q.c - this.b * q.d + this.c * q.a + this.d * q.b;
    const d = this.a * q.d + this.b * q.c - this.c * q.b + this.d * q.a;

    return new Quaternion(a, b, c, d);
  }

  toString() {
    let str = '';
    if (this.a !== 0) str += `${this.a}`;
    if (this.b !== 0) str += `${this.b > 0 && str ? '+' : ''}${this.b === 1 ? 'i' : this.b === -1 ? '-i' : `${this.b}i`}`;
    if (this.c !== 0) str += `${this.c > 0 && str ? '+' : ''}${this.c === 1 ? 'j' : this.c === -1 ? '-j' : `${this.c}j`}`;
    if (this.d !== 0) str += `${this.d > 0 && str ? '+' : ''}${this.d === 1 ? 'k' : this.d === -1 ? '-k' : `${this.d}k`}`;
  
    // Ensuring that zero quaternions are represented as "0"
    if (str === '') str = '0';
  
    return str;
  }
  
  
  
}

