package main

import (
	"log"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
)

func do(seconds int, action ...any) {
    log.Println(action...)
    randomMillis := 500 * seconds + rand.Intn(500 * seconds)
    time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

type Order struct {
    id uint64
    customer string
    reply chan *Order
    preparedBy string
}

var nextId atomic.Uint64 

// a waiter can only hold 3 orders at once
var Waiter = make(chan *Order, 3)

func Cook(name string) {
    log.Println(name, "starting work")
    for {
        // fetch order from waiter
        order := <- Waiter
        // cook the order
        do(10, name, "is cooking order", order.id, "for", order.customer)
        // assign the cook's name to order
        order.preparedBy = name
        // send order back to customer
        order.reply <- order
    }
}

func Customer(name string, wg *sync.WaitGroup ) {
    defer wg.Done()
    for mealsEaten := 0; mealsEaten < 5; {
        // create new order 
        order := &Order{
            id: nextId.Add(1),
            customer: name,
            reply: make(chan *Order),
        }
        log.Println(name, "placed order", order.id)

        select {
            // try to place order with waiter within 7s
        case Waiter <- order:
            // wait for meal
            meal := <- order.reply
            // eat meal 
            do(2, name, "is eating meal", meal.id, "prepared by", meal.preparedBy)
            mealsEaten++
        case <- time.After(7 * time.Second):
            do(5, name, "is waiting too long, abandoning order", order.id)
        }
    }
    log.Println(name, "is going home")
}

func main() {
    customers := [10]string{
        "Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai",
    }

    // in a loop, start each customer as a goroutine
    var wg sync.WaitGroup

    // start customers as goroutine
    for _, customer := range customers {
        wg.Add(1)
        go Customer(customer, &wg)
    }

    // start 3 cooks, Remy, Linguini, and Colette
    go Cook("Remy")
    go Cook("Linguini")
    go Cook("Colette")
    
    // wait for customers to go home
    wg.Wait()
    log.Println("Restaurant closing")
}