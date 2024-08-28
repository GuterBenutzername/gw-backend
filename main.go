package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.GET("/courses", getCourses)

	router.Run("localhost:8080")
}

func getCourses(c *gin.Context) {
	courses := []string{"course1", "course2", "course3"}
	c.IndentedJSON(200, courses)
}
