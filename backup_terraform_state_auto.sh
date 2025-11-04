#!/bin/bash

# ================================================================
# Terraform Remote State Backup Script (Auto-Detected Backend)
# Author: Sudhir D (with Robo 🤖)
# Purpose: Automatically back up Azure remote backend Terraform state
# ================================================================

# ====== CONFIGURATION ======
BACKEND_FILE="./backend.tf"
BACKUP_DIR="$HOME/terraform_backups"
LOG_FILE="$BACKUP_DIR/backup_log_$(date +%Y%m%d_%H%M).log"
# ============================

mkdir -p "$BACKUP_DIR"

echo "-----------------------------------------------"
echo "🌐 Starting Terraform Remote State Backup..."
echo "Date: $(date)"
echo "-----------------------------------------------"

# 1️⃣ Extract backend values from backend.tf
if [ ! -f "$BACKEND_FILE" ]; then
  echo "❌ backend.tf not found! Please ensure you're in the correct Terraform directory."
  exit 1
fi

STORAGE_ACCOUNT=$(grep -E 'storage_account_name' "$BACKEND_FILE" | awk -F'=' '{print $2}' | tr -d ' "')
CONTAINER_NAME=$(grep -E 'container_name' "$BACKEND_FILE" | awk -F'=' '{print $2}' | tr -d ' "')
STATE_FILE=$(grep -E 'key' "$BACKEND_FILE" | awk -F'=' '{print $2}' | tr -d ' "')

if [[ -z "$STORAGE_ACCOUNT" || -z "$CONTAINER_NAME" || -z "$STATE_FILE" ]]; then
  echo "❌ Could not read backend configuration values."
  echo "Please check backend.tf for correct 'storage_account_name', 'container_name', and 'key'."
  exit 1
fi

echo "✅ Detected backend configuration:"
echo "   Storage Account: $STORAGE_ACCOUNT"
echo "   Container: $CONTAINER_NAME"
echo "   State File: $STATE_FILE"
echo "-----------------------------------------------"

# 2️⃣ Get storage account key automatically
echo "🔑 Fetching storage account key..."
ACCOUNT_KEY=$(az storage account keys list \
  --account-name "$STORAGE_ACCOUNT" \
  --query "[0].value" -o tsv 2>/dev/null)

if [ -z "$ACCOUNT_KEY" ]; then
  echo "❌ Failed to retrieve storage account key. Make sure you're logged into Azure and have access."
  echo "Try: az login && az account set --subscription <your-subscription-id>"
  exit 1
fi

# Export environment vars for az CLI
export AZURE_STORAGE_ACCOUNT="$STORAGE_ACCOUNT"
export AZURE_STORAGE_KEY="$ACCOUNT_KEY"

# 3️⃣ Download current Terraform state with timestamp
BACKUP_FILE="$BACKUP_DIR/${STATE_FILE}_backup_$(date +%Y%m%d_%H%M%S).tfstate"

echo "📦 Downloading current Terraform state file..."
az storage blob download \
  --account-name "$STORAGE_ACCOUNT" \
  --container-name "$CONTAINER_NAME" \
  --name "$STATE_FILE" \
  --file "$BACKUP_FILE" \
  --only-show-errors

if [ $? -eq 0 ]; then
  echo "✅ Backup successful! File saved at:"
  echo "   $BACKUP_FILE"
else
  echo "❌ Backup failed while downloading blob. Check permissions or backend config."
  exit 1
fi

# 4️⃣ List available blob versions (if versioning enabled)
echo ""
echo "🔍 Listing blob versions (if versioning is enabled)..."
az storage blob list \
  --account-name "$STORAGE_ACCOUNT" \
  --container-name "$CONTAINER_NAME" \
  --include v \
  --query "[].{VersionId:versionId, LastModified:properties.lastModified}" \
  --output table | tee -a "$LOG_FILE"

# 5️⃣ Log success
{
  echo "-----------------------------------------------"
  echo "✅ Backup completed successfully on $(date)"
  echo "Backup file: $BACKUP_FILE"
  echo "Storage Account: $STORAGE_ACCOUNT"
  echo "Container: $CONTAINER_NAME"
  echo "State File: $STATE_FILE"
  echo "-----------------------------------------------"
} >> "$LOG_FILE"

echo ""
echo "🗂️ Backup Log saved at: $LOG_FILE"
echo "🎉 Terraform remote state backup completed successfully!"
echo "-----------------------------------------------"

