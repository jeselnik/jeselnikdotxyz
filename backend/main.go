package main

import (
	"context"
	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Response struct {
	Message       string `json:"message"`
	TotalVisitors int    `json:"totalVisitors"`
}

/* stub, database operations l8r */
func handler(ctx context.Context, req events.LambdaFunctionURLRequest) (events.LambdaFunctionURLResponse, error) {
	resBody := Response{
		Message:       "405 :p",
		TotalVisitors: 0,
	}

	resJson, err := json.Marshal(resBody)
	if err != nil {
		return events.LambdaFunctionURLResponse{StatusCode: 500}, err
	}

	resp := events.LambdaFunctionURLResponse{
		StatusCode: 200,
		Headers:    map[string]string{"Content Type:": "application/json"},
		Body:       string(resJson),
	}

	return resp, nil
}

func main() {
	lambda.Start(handler)
}
