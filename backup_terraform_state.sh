#!/bin/bash

# ================================================================
# Terraform Remote State Backup Script (Azure Storage Backend)
# Author: Sudhir D (with Robo 🤖)
# Purpose: Safely back up and version your Terraform remote state
# ================================================================

# ====== USER CONFIGURATION ======
RESOURCE_GROUP="rg-devsecops-prod"
STORAGE_ACCOUNT="tfstateprodstore"
CONTAINER_NAME="tfstate"
STATE_FILE="infra-prod.tfstate"
BACKUP_DIR="$HOME/terraform_backups"
LOG_FILE="$BACKUP_DIR/backup_log_$(date +%Y%m%d_%H%M).log"
# ================================

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

echo "-----------------------------------------------"
echo "🌐 Starting Terraform Remote State Backup..."
echo "Date: $(date)"
echo "Storage Account: $STORAGE_ACCOUNT"
echo "Container: $CONTAINER_NAME"
echo "State File: $STATE_FILE"
echo "-----------------------------------------------"

# 1️⃣ Check if Azure CLI is logged in
az account show > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ You are not logged into Azure CLI. Please run: az login"
  exit 1
fi

# 2️⃣ Download current state file with timestamp
BACKUP_FILE="$BACKUP_DIR/${STATE_FILE}_backup_$(date +%Y%m%d_%H%M%S).tfstate"

az storage blob download \
  --account-name "$STORAGE_ACCOUNT" \
  --container-name "$CONTAINER_NAME" \
  --name "$STATE_FILE" \
  --file "$BACKUP_FILE" \
  --only-show-errors

if [ $? -eq 0 ]; then
  echo "✅ Terraform state file downloaded successfully."
  echo "📁 Saved at: $BACKUP_FILE"
else
  echo "❌ Backup failed while downloading blob."
  exit 1
fi

# 3️⃣ List available blob versions (if enabled)
echo ""
echo "🔍 Checking for version history (if versioning is enabled)..."
az storage blob list \
  --account-name "$STORAGE_ACCOUNT" \
  --container-name "$CONTAINER_NAME" \
  --include v \
  --query "[].{Name:name, VersionId:versionId, LastModified:properties.lastModified}" \
  --output table | tee -a "$LOG_FILE"

# 4️⃣ Log details
{
  echo "-----------------------------------------------"
  echo "✅ Backup completed successfully on $(date)"
  echo "Backup file: $BACKUP_FILE"
  echo "Azure Blob Versions logged above."
  echo "-----------------------------------------------"
} >> "$LOG_FILE"

echo ""
echo "🗂️ Backup Log saved at: $LOG_FILE"
echo "-----------------------------------------------"
echo "🎉 Terraform state backup completed successfully!"

