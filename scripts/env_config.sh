#!/bin/bash

# Environment Configuration Script for CropFresh Farmers App
# This script helps manage environment configuration for different environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}$1${NC}"
}

# Function to show usage
show_usage() {
    print_header "CropFresh Environment Configuration Script"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  setup [env]      Setup environment configuration"
    echo "  validate [env]   Validate environment configuration"
    echo "  switch [env]     Switch to different environment"
    echo "  secrets          Manage secrets configuration"
    echo "  backup           Backup current configuration"
    echo "  restore [file]   Restore configuration from backup"
    echo "  clean            Clean temporary configuration files"
    echo ""
    echo "Environments:"
    echo "  development      Development environment (default)"
    echo "  staging          Staging environment"
    echo "  production       Production environment"
    echo ""
    echo "Examples:"
    echo "  $0 setup development"
    echo "  $0 validate production"
    echo "  $0 switch staging"
    echo "  $0 secrets"
    echo ""
}

# Function to setup environment
setup_environment() {
    local env=${1:-development}
    
    print_header "Setting up $env environment..."
    
    # Check if environment file exists
    if [[ ! -f ".env.$env" ]]; then
        print_error "Environment file .env.$env not found!"
        return 1
    fi
    
    # Create .env.local from environment template
    cp ".env.$env" ".env.local"
    print_status "Created .env.local from .env.$env"
    
    # If not production, copy example secrets
    if [[ "$env" != "production" ]]; then
        print_warning "Using example secrets for $env environment"
        print_warning "Please update .env.local with your actual secrets"
    fi
    
    # Set flutter flavor
    echo "FLUTTER_FLAVOR=$env" >> ".env.local"
    
    print_status "Environment setup complete for $env"
    print_warning "Remember to run 'flutter pub get' to refresh dependencies"
}

# Function to validate environment
validate_environment() {
    local env=${1:-development}
    local env_file=".env.$env"
    
    if [[ "$env" == "local" ]]; then
        env_file=".env.local"
    fi
    
    print_header "Validating $env environment configuration..."
    
    if [[ ! -f "$env_file" ]]; then
        print_error "Environment file $env_file not found!"
        return 1
    fi
    
    # Required variables for production
    local required_vars=()
    if [[ "$env" == "production" ]]; then
        required_vars=(
            "API_BASE_URL"
            "FIREBASE_PROJECT_ID"
            "FIREBASE_API_KEY"
            "JWT_SECRET_KEY"
            "ENCRYPTION_KEY"
        )
    fi
    
    # Check required variables
    local missing_vars=()
    for var in "${required_vars[@]}"; do
        if ! grep -q "^$var=" "$env_file" || grep -q "^$var=$" "$env_file"; then
            missing_vars+=("$var")
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        print_error "Missing required variables for $env:"
        printf '%s\n' "${missing_vars[@]}"
        return 1
    fi
    
    # Check for placeholder values
    local placeholders=(
        "your_api_key_here"
        "your_secret_here"
        "changeme"
        "placeholder"
    )
    
    for placeholder in "${placeholders[@]}"; do
        if grep -q "$placeholder" "$env_file"; then
            print_warning "Found placeholder value '$placeholder' in $env_file"
        fi
    done
    
    print_status "Environment validation complete for $env"
}

# Function to switch environment
switch_environment() {
    local env=${1:-development}
    
    print_header "Switching to $env environment..."
    
    # Backup current .env.local if it exists
    if [[ -f ".env.local" ]]; then
        cp ".env.local" ".env.local.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Backed up current .env.local"
    fi
    
    # Setup new environment
    setup_environment "$env"
}

# Function to manage secrets
manage_secrets() {
    print_header "Secrets Management"
    echo ""
    echo "1. Generate new encryption key"
    echo "2. Generate JWT secret"
    echo "3. Show current secrets (masked)"
    echo "4. Validate secrets format"
    echo "5. Back to main menu"
    echo ""
    read -p "Select option (1-5): " choice
    
    case $choice in
        1)
            generate_encryption_key
            ;;
        2)
            generate_jwt_secret
            ;;
        3)
            show_masked_secrets
            ;;
        4)
            validate_secrets_format
            ;;
        5)
            return 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
}

# Function to generate encryption key
generate_encryption_key() {
    local key=$(openssl rand -hex 32)
    print_status "Generated new encryption key:"
    echo "ENCRYPTION_KEY=$key"
    echo ""
    print_warning "Please add this to your .env.local file"
}

# Function to generate JWT secret
generate_jwt_secret() {
    local secret=$(openssl rand -base64 64 | tr -d "=+/" | cut -c1-64)
    print_status "Generated new JWT secret:"
    echo "JWT_SECRET_KEY=$secret"
    echo ""
    print_warning "Please add this to your .env.local file"
}

# Function to show masked secrets
show_masked_secrets() {
    if [[ ! -f ".env.local" ]]; then
        print_error ".env.local not found!"
        return 1
    fi
    
    print_status "Current secrets (masked):"
    grep -E "(KEY|SECRET|TOKEN|PASSWORD)" ".env.local" | sed 's/=.*/=***/'
}

# Function to validate secrets format
validate_secrets_format() {
    if [[ ! -f ".env.local" ]]; then
        print_error ".env.local not found!"
        return 1
    fi
    
    print_status "Validating secrets format..."
    
    # Check encryption key length
    local encryption_key=$(grep "^ENCRYPTION_KEY=" ".env.local" | cut -d'=' -f2)
    if [[ ${#encryption_key} -ne 64 ]]; then
        print_warning "Encryption key should be 64 characters long"
    fi
    
    # Check JWT secret length
    local jwt_secret=$(grep "^JWT_SECRET_KEY=" ".env.local" | cut -d'=' -f2)
    if [[ ${#jwt_secret} -lt 32 ]]; then
        print_warning "JWT secret should be at least 32 characters long"
    fi
    
    print_status "Secrets format validation complete"
}

# Function to backup configuration
backup_configuration() {
    local backup_dir="backups"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$backup_dir/env_backup_$timestamp.tar.gz"
    
    print_header "Backing up configuration..."
    
    # Create backup directory if it doesn't exist
    mkdir -p "$backup_dir"
    
    # Create backup
    tar -czf "$backup_file" .env.* 2>/dev/null || true
    
    if [[ -f "$backup_file" ]]; then
        print_status "Configuration backed up to $backup_file"
    else
        print_error "Backup failed!"
        return 1
    fi
}

# Function to restore configuration
restore_configuration() {
    local backup_file="$1"
    
    if [[ -z "$backup_file" ]]; then
        print_error "Please specify backup file to restore"
        return 1
    fi
    
    if [[ ! -f "$backup_file" ]]; then
        print_error "Backup file $backup_file not found!"
        return 1
    fi
    
    print_header "Restoring configuration from $backup_file..."
    
    # Extract backup
    tar -xzf "$backup_file"
    
    print_status "Configuration restored from $backup_file"
}

# Function to clean temporary files
clean_configuration() {
    print_header "Cleaning temporary configuration files..."
    
    # Remove backup files older than 30 days
    find . -name ".env.local.backup.*" -mtime +30 -delete 2>/dev/null || true
    
    # Remove temporary files
    rm -f .env.tmp .env.*.tmp 2>/dev/null || true
    
    print_status "Cleanup complete"
}

# Main script logic
main() {
    local command=${1:-help}
    
    case $command in
        setup)
            setup_environment "$2"
            ;;
        validate)
            validate_environment "$2"
            ;;
        switch)
            switch_environment "$2"
            ;;
        secrets)
            manage_secrets
            ;;
        backup)
            backup_configuration
            ;;
        restore)
            restore_configuration "$2"
            ;;
        clean)
            clean_configuration
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
