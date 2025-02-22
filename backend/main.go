package main

import (
	"context"
	"encoding/json"
	"errors"
	"log"
	"strconv"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

const (
	cTABLE_NAME    = "jeselnikxyz-visitor-counter"
	cPARTITION_KEY = "CounterID"
	cCOUNTER_NAME  = "totalVisitors"
)

var (
	dbClient           *dynamodb.Client
	errAttrFetch       = errors.New("unable to retrieve totalVisitors attribute")
	genericServerError = events.LambdaFunctionURLResponse{StatusCode: 500}
)

type VisitorCountResponse struct {
	Message       string `json:"message"`
	TotalVisitors int    `json:"totalVisitors"`
}

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatal(err)
	}
	dbClient = dynamodb.NewFromConfig(cfg)
}

func updateVisitorCount() (int, error) {
	updateInput := &dynamodb.UpdateItemInput{
		TableName: aws.String(cTABLE_NAME),
		Key: map[string]types.AttributeValue{
			cPARTITION_KEY: &types.AttributeValueMemberS{Value: cCOUNTER_NAME},
		},
		UpdateExpression: aws.String("SET totalVisitors = if_not_exists(totalVisitors, :start) + :inc"),
		ExpressionAttributeValues: map[string]types.AttributeValue{
			":inc":   &types.AttributeValueMemberN{Value: "1"},
			":start": &types.AttributeValueMemberN{Value: "0"},
		},
		ReturnValues: types.ReturnValueUpdatedNew,
	}

	result, err := dbClient.UpdateItem(context.TODO(), updateInput)
	if err != nil {
		return -1, err
	}

	val, success := result.Attributes["totalVisitors"].(*types.AttributeValueMemberN)
	if !success {
		return -1, errAttrFetch
	}

	count, err := strconv.Atoi(val.Value)
	if err != nil {
		return -1, err
	}

	return count, nil
}

func visitorCount() (events.LambdaFunctionURLResponse, error) {
	count, err := updateVisitorCount()
	if err != nil {
		return genericServerError, err
	}

	resBody := VisitorCountResponse{
		Message:       "incremented",
		TotalVisitors: count,
	}

	resJson, err := json.Marshal(resBody)
	if err != nil {
		return genericServerError, err
	}

	resp := events.LambdaFunctionURLResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(resJson),
	}

	return resp, nil
}

func handler(ctx context.Context, req events.LambdaFunctionURLRequest) (events.LambdaFunctionURLResponse, error) {
	/* Only one route (for now?) */
	return visitorCount()
}

func main() {
	lambda.Start(handler)
}
