#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base commands
kibot_base="kibot"
first_command_options="--skip-pre all -c kibot_yaml/kibot_main.yaml testpoints"
second_command_options="-c kibot_yaml/kibot_main.yaml -i testpoints"

# Default options
variant="RELEASED" # Default variant
first_command_additional_options=""
second_command_additional_options=""

# Display help
function display_help() {
    echo -e "USAGE"
    echo -e "  ./kibot_launch.sh [OPTIONS]"
    echo
    echo -e "OPTIONS"
    echo -e "  -v, --variant VARIANT       Specify a variant name."
    echo -e "                              This adds '-g variant=<VARIANT>' and '-d Variant_Outputs/<VARIANT>' to the kibot commands."
    echo
    echo -e "  --no-check                  Skip ERC (Electrical Rule Check) and DRC (Design Rule Check)."
    echo
    echo -e "  -h, --help                  Display this help message."
    echo
    echo -e "EXAMPLES"
    echo -e "  ./kibot_launch.sh                        Run with default options."
    echo
    echo -e "  ./kibot_launch.sh -v VARIANT             Run with a specified variant."
    echo
    echo -e "  ./kibot_launch.sh --no-check             Skip ERC and DRC."
    echo -e "  ./kibot_launch.sh -v VARIANT --no-check  Combine options."
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --variant|-v)
            if [[ -n $2 && $2 != -* ]]; then
                variant="$2"
                # Exclude '-d' option for specific variants
                if [[ "$variant" != "DRAFT" && "$variant" != "PRELIMINARY" && "$variant" != "CHECKED" && "$variant" != "RELEASED" ]]; then
                    first_command_additional_options+=" -g variant=$variant -d Variant_Outputs/$variant"
                    second_command_additional_options+=" -g variant=$variant -d Variant_Outputs/$variant"
                else
                    first_command_additional_options+=" -g variant=$variant"
                    second_command_additional_options+=" -g variant=$variant"
                fi
                shift
            else
                echo -e "${YELLOW}Warning: --variant|-v requires a value.${NC}"
                exit 1
            fi
            ;;
        --no-check)
            second_command_additional_options+=" --skip-pre erc,drc"
            ;;
        -h|--help)
            display_help
            ;;
        *)
            echo -e "${YELLOW}Warning: Unrecognized argument passed: $1${NC}"
            ;;
    esac
    shift
done

# Construct full commands
first_command="$kibot_base$first_command_additional_options $first_command_options"
second_command="$kibot_base$second_command_additional_options $second_command_options"

# Execute the commands
echo -e "${GREEN}Running: $first_command${NC}"
eval $first_command

echo -e "${GREEN}Running: $second_command${NC}"
eval $second_command