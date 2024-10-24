import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<T, U>(
  items: T[],
  predicate: (item: T) => boolean,
  consumer: (item: T) => U
): U | undefined {
  const foundItem = items.find(predicate)
  return foundItem !== undefined ? consumer(foundItem) : undefined
}

export function* powersGenerator(base: bigint): Generator<bigint> {
  let power = 1n // Start with BigInt 1
  while (true) {
    yield power
    power *= base // Multiply using BigInt
  }
}

export async function meaningfulLineCount(filePath: string): Promise<number> {
  const fileHandle = await open(filePath, "r") // Open the file for reading
  try {
    const fileContent = await fileHandle.readFile({ encoding: "utf-8" })
    const lines = fileContent.split(/\r?\n/) // Split content into lines (handles both Unix and Windows line breaks)

    let lineCount = 0

    for (const line of lines) {
      const trimmedLine = line.trim()

      if (trimmedLine.length === 0 || trimmedLine.startsWith("#")) {
        continue // Skip empty lines or lines starting with #
      }

      lineCount++
    }

    return lineCount
  } finally {
    await fileHandle.close() // Ensure the file is closed
  }
}

interface Sphere {
  kind: "Sphere"
  radius: number
}

interface Box {
  kind: "Box"
  width: number
  length: number
  depth: number
}

export type Shape = Sphere | Box

export function surfaceArea(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return 4 * Math.PI * shape.radius ** 2
    case "Box":
      return (
        2 *
        (shape.width * shape.length +
          shape.width * shape.depth +
          shape.length * shape.depth)
      )
  }
}

export function volume(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return (4 / 3) * Math.PI * shape.radius ** 3
    case "Box":
      return shape.width * shape.length * shape.depth
  }
}

// Custom toString function for both Sphere and Box
export function toString(shape: Shape): string {
  switch (shape.kind) {
    case "Sphere":
      return `Sphere(radius: ${shape.radius})`
    case "Box":
      return `Box(width: ${shape.width}, height: ${shape.length}, depth: ${shape.depth})`
  }
}

export interface BinarySearchTree<T> {
  size(): number
  insert(value: T): BinarySearchTree<T>
  contains(value: T): boolean
  inorder(): Iterable<T>
}

class Node<T> implements BinarySearchTree<T> {
  constructor(
    public value: T,
    public left: BinarySearchTree<T>,
    public right: BinarySearchTree<T>
  ) {}

  size(): number {
    return 1 + this.left.size() + this.right.size()
  }

  insert(value: T): BinarySearchTree<T> {
    if (value < this.value) {
      const newLeft = this.left.insert(value)
      return new Node(this.value, newLeft, this.right)
    } else if (value > this.value) {
      const newRight = this.right.insert(value)
      return new Node(this.value, this.left, newRight)
    }
    // If value is equal, do not insert and return this (immutable)
    return this // Ensuring immutability
  }

  contains(value: T): boolean {
    if (value === this.value) {
      return true
    } else if (value < this.value) {
      return this.left.contains(value)
    } else {
      return this.right.contains(value)
    }
  }

  *inorder(): Iterable<T> {
    yield* this.left.inorder()
    yield this.value
    yield* this.right.inorder()
  }

  toString(): string {
    const leftStr = this.left.toString()
    const rightStr = this.right.toString()
    const leftPart = leftStr ? `(${leftStr})` : ""
    const rightPart = rightStr ? `(${rightStr})` : ""
    return `${leftPart}${this.value}${rightPart}`
  }
}

export class Empty<T> implements BinarySearchTree<T> {
  size(): number {
    return 0
  }

  insert(value: T): BinarySearchTree<T> {
    return new Node(value, new Empty(), new Empty())
  }

  contains(value: T): boolean {
    return false
  }

  *inorder(): Iterable<T> {
    return [] // Empty tree yields no values
  }

  toString(): string {
    return "()" // Empty tree representation
  }
}
