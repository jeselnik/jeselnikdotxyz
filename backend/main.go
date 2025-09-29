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

type VisitorCountReqBody struct {
	Increment bool `json:"increment"`
}

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatal(err)
	}
	dbClient = dynamodb.NewFromConfig(cfg)
}

func getVisitorCount() (int, error) {
	input := &dynamodb.GetItemInput{
		TableName: aws.String(cTABLE_NAME),
		Key: map[string]types.AttributeValue{
			cPARTITION_KEY: &types.AttributeValueMemberS{Value: cCOUNTER_NAME},
		},
		ProjectionExpression: aws.String("totalVisitors"),
	}

	result, err := dbClient.GetItem(context.TODO(), input)
	if err != nil {
		return -1, err
	}

	if result.Item == nil {
		return 0, nil
	}

	val, ok := result.Item["totalVisitors"].(*types.AttributeValueMemberN)
	if !ok {
		return -1, errAttrFetch
	}

	count, err := strconv.Atoi(val.Value)
	if err != nil {
		return -1, err
	}

	return count, nil
}

func updateVisitorCount() error {
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

	_, err := dbClient.UpdateItem(context.TODO(), updateInput)
	return err
}

func visitorCount(incr bool) (events.LambdaFunctionURLResponse, error) {
	var count int = 0
	var err error = nil
	message := "retrieved"
	if incr {
		err = updateVisitorCount()
		if err != nil {
			return genericServerError, err
		}
		message = "incremented"
	}
	count, err = getVisitorCount()
	if err != nil {
		return genericServerError, err
	}

	resBody := VisitorCountResponse{
		Message:       message,
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
	var reqBody VisitorCountReqBody
	reqBodyErr := json.Unmarshal([]byte(req.Body), &reqBody)
	if reqBodyErr != nil {
		return genericServerError, reqBodyErr
	}
	/* Only one route (for now?) */
	return visitorCount(reqBody.Increment)
}

func main() {
	lambda.Start(handler)
}
