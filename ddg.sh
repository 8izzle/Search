#!/bin/bash

# Function to fetch answers from DuckDuckGo Instant Answer API
fetch_answers() {
    query=$1
    # Encode the query using URL encoding
    encoded_query=$(printf "%s" "$query" | jq -s -R -r @uri)
    url="https://api.duckduckgo.com/?q=${encoded_query}&format=json"
    response=$(curl -s "$url")
    # Check if response contains RelatedTopics
    if [[ $(echo "$response" | jq -r '.RelatedTopics[0].Text') != "null" ]]; then
        # Concatenate all related topics into a single string
        answer=$(echo "$response" | jq -r '.RelatedTopics[].Text' | paste -sd '\n' -)
    # If RelatedTopics is empty, set answer to a default message
    else
        answer="No answer found for \"$query\""
    fi
    echo "$answer"
}

# Main function
main() {
    echo "Enter your search query:"
    read query
    # Calling the fetch_answers function with the user's query
    result=$(fetch_answers "$query")
    echo "Answer:"
    echo "$result"
}

# Calling the main function
main
