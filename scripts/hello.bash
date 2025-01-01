#!/usr/bin/env bash


GITHUB_TOKEN="$1"
REPOSITORY="$2"
ISSUE_NUMBER="$3"
OPENAI_API_KEY="$4"

echo "HELLO TEST";
echo "Using token: $GITHUB_TOKEN"
echo "Using OpenAI key: $OPENAI_API_KEY"
echo "Issue number: $ISSUE_NUMBER"
echo "Repository: $REPOSITORY"