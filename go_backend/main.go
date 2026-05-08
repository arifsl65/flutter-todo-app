package main

import (
	"encoding/json"
	"log"
	"net/http"
	"sync"
	"time"

	"github.com/google/uuid"
)

// Todo represents a todo item
type Todo struct {
	ID        string    `json:"id"`
	Title     string    `json:"title"`
	Completed bool      `json:"completed"`
	CreatedAt time.Time `json:"created_at"`
}

// In-memory storage (for learning purposes)
// In production, you'd use a database
var (
	todos = make(map[string]Todo)
	mu    sync.RWMutex
)

func main() {
	// Add some sample todos
	addSampleTodos()

	// Set up routes
	http.HandleFunc("/todos", corsMiddleware(handleTodos))
	http.HandleFunc("/todos/", corsMiddleware(handleTodoByID))
	http.HandleFunc("/health", corsMiddleware(handleHealth))

	log.Println("Go backend server starting on http://localhost:8080")
	log.Println("Endpoints:")
	log.Println("  GET    /todos      - List all todos")
	log.Println("  POST   /todos      - Create a new todo")
	log.Println("  PUT    /todos/{id} - Update a todo")
	log.Println("  DELETE /todos/{id} - Delete a todo")
	log.Println("  GET    /health     - Health check")

	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}

func addSampleTodos() {
	sampleTodos := []string{
		"Learn Flutter basics",
		"Set up Go backend",
		"Connect to Firebase",
	}

	for _, title := range sampleTodos {
		id := uuid.New().String()
		todos[id] = Todo{
			ID:        id,
			Title:     title,
			Completed: false,
			CreatedAt: time.Now(),
		}
	}
}

// CORS middleware to allow Flutter web app to connect
func corsMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		next(w, r)
	}
}

func handleHealth(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
}

func handleTodos(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	switch r.Method {
	case "GET":
		// Get all todos
		mu.RLock()
		todoList := make([]Todo, 0, len(todos))
		for _, todo := range todos {
			todoList = append(todoList, todo)
		}
		mu.RUnlock()

		json.NewEncoder(w).Encode(todoList)

	case "POST":
		// Create new todo
		var input struct {
			Title string `json:"title"`
		}

		if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
			http.Error(w, "Invalid request body", http.StatusBadRequest)
			return
		}

		if input.Title == "" {
			http.Error(w, "Title is required", http.StatusBadRequest)
			return
		}

		todo := Todo{
			ID:        uuid.New().String(),
			Title:     input.Title,
			Completed: false,
			CreatedAt: time.Now(),
		}

		mu.Lock()
		todos[todo.ID] = todo
		mu.Unlock()

		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(todo)

	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
	}
}

func handleTodoByID(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	// Extract ID from URL path: /todos/{id}
	id := r.URL.Path[len("/todos/"):]
	if id == "" {
		http.Error(w, "Todo ID is required", http.StatusBadRequest)
		return
	}

	switch r.Method {
	case "GET":
		mu.RLock()
		todo, exists := todos[id]
		mu.RUnlock()

		if !exists {
			http.Error(w, "Todo not found", http.StatusNotFound)
			return
		}

		json.NewEncoder(w).Encode(todo)

	case "PUT":
		mu.RLock()
		todo, exists := todos[id]
		mu.RUnlock()

		if !exists {
			http.Error(w, "Todo not found", http.StatusNotFound)
			return
		}

		var input struct {
			Title     *string `json:"title"`
			Completed *bool   `json:"completed"`
		}

		if err := json.NewDecoder(r.Body).Decode(&input); err != nil {
			http.Error(w, "Invalid request body", http.StatusBadRequest)
			return
		}

		if input.Title != nil {
			todo.Title = *input.Title
		}
		if input.Completed != nil {
			todo.Completed = *input.Completed
		}

		mu.Lock()
		todos[id] = todo
		mu.Unlock()

		json.NewEncoder(w).Encode(todo)

	case "DELETE":
		mu.Lock()
		_, exists := todos[id]
		if exists {
			delete(todos, id)
		}
		mu.Unlock()

		if !exists {
			http.Error(w, "Todo not found", http.StatusNotFound)
			return
		}

		json.NewEncoder(w).Encode(map[string]string{"message": "Todo deleted"})

	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
	}
}
