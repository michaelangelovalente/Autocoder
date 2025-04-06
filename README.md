# Autocoder

Automated Code Generation Tool

Makes DevOps workflow smoother with AI-powered code generation.

A GitHub Action tool that automatically generates code from GitHub issues using ChatGPT. It analyzes your issue descriptions and creates corresponding code files, making your development workflow more efficient.

This tool integrates seamlessly with your GitHub repositories, processing specially labeled issues and generating code based on the issue description. It then creates a pull request with the generated files for review before integration.

## How It Works

1. Create an issue with detailed requirements using the `autocoder-bot` label
2. Autocoder processes the issue using OpenAI's ChatGPT
3. Code is automatically generated based on your requirements
4. A pull request is created with the generated code for review

## Setup Instructions

### 1. Set up Required Secrets

In your repository settings, add the following secrets:
- `OPENAI_KEY`: Your OpenAI API key
- `GITHUB_TOKEN`: Usually provided automatically by GitHub Actions

### 2. Create Workflow File

Create a workflow file in `.github/workflows/autocoder.yml`:

```yaml
name: Autocoder Bot Workflow

permissions:
  contents: write
  pull-requests: write
  issues: read

on:
  issues:
    types: [opened, reopened, labeled]

jobs:
  process_issue:
    runs-on: ubuntu-latest
    if: contains(github.event.issue.labels.*.name, 'autocoder-bot')
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with: 
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Run Autocoder Bot Action
        id: autocoder
        uses: michaelangelovalente/Autocoder@v2
        with:
          issue_number: ${{ github.event.issue.number }}
          issue_body: ${{ github.event.issue.body }}
          issue_assignees: ${{ join(github.event.issue.assignees.*.login, ', ') }}
          issue_assigned_labels: ${{ join(github.event.issue.labels.*.name, ', ') }}
          issue_label: 'autocoder-bot'
          repository: ${{ github.repository }}
          openai_api_key: ${{ secrets.OPENAI_KEY }}
          github_token: ${{ secrets.GITHUB_TOKEN }}

      - name: Echo Pull Request URL
        if: steps.autocoder.outputs.pull_request_number
        run: |
          echo "Pull Request Number - ${{ steps.autocoder.outputs.pull_request_number }}"
          echo "Pull Request URL - ${{ steps.autocoder.outputs.pull_request_url }}"
```

## Creating Issues for Autocoder

For Autocoder to process your issue and generate code:

1. Create a new issue in your repository
2. Add the `autocoder-bot` label
3. Write a detailed description of the code you need
4. Structure your issue with clear requirements

### Issue Format Example

```
Problem Description:
You are tasked with setting a Docker Compose configuration for a web application.
Create a Docker Compose file that defines two services: a frontend service using an NGNIX image and a vackend service usign a Node.js image.

Services
    - Frontend
        Image: ngnix (latest version)
        Ports: 80:80
        Volumes: ./frontend:/usr/share/ngnix/html

    - Backend
        Image: Node (latest version)
        Ports: 3000:3000
        Volumes: ./backend:/usr/src/app
    
    - Environment
        Node.js (latest version)
        NGNIX version (latest version)
```

## Configuration Options

| Input Parameter | Description | Required | Default |
|----------------|-------------|----------|---------|
| `issue_number` | The number of the issue to process | Yes | - |
| `issue_body` | Body content of the issue | Yes | - |
| `issue_assignees` | Issue assignees | Yes | - |
| `issue_label` | Label that triggers the Autocoder action | Yes | `autocoder-bot` |
| `issue_assigned_labels` | All labels assigned to the issue | Yes | `autocoder-bot` |
| `repository` | The repository where the action runs | Yes | - |
| `openai_api_key` | API key for OpenAI | Yes | - |
| `github_token` | GitHub token for authentication | Yes | - |

## Outputs

| Output | Description |
|--------|-------------|
| `pull_request_url` | URL of the created pull request with generated code |
| `pull_request_number` | Number of the created pull request |

## Limitations

- The quality of generated code depends on the clarity and detail of your issue description
- Complex architecture or logic may require multiple issues or manual adjustments
- Always review generated code before merging the pull request