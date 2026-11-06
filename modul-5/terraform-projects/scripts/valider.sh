#!/usr/bin/env bash

# Finn repo-roten uavhengig av hvor skriptet startes.
set -u
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$REPO_ROOT" || exit 1

feilet=""

# Terraform-mapper som inngår i kontrollen.
TERRAFORM_MAPPER=(
  "modul-5/terraform-projects/backend"
  "modul-5/terraform-projects/stacks/webapp"
)

TFLINT_CONFIG="$REPO_ROOT/modul-5/terraform-projects/.tflint.hcl"
CHECKOV_CONFIG="$REPO_ROOT/modul-5/terraform-projects/.checkov.yaml"

echo "=== 1/4 Terraform fmt ==="
for mappe in "${TERRAFORM_MAPPER[@]}"; do
  if ! terraform fmt -check -recursive "$mappe"; then
    feilet="$feilet fmt($mappe)"
  fi
done

echo "=== 2/4 Terraform validate ==="
for mappe in "${TERRAFORM_MAPPER[@]}"; do
  echo "--- $mappe"
  if ! (
    cd "$mappe" &&
    terraform init -backend=false -input=false -no-color > /dev/null &&
    terraform validate -no-color
  ); then
    feilet="$feilet validate($mappe)"
  fi
done

echo "=== 3/4 TFLint ==="
if ! (cd "modul-5/terraform-projects" && tflint --init); then
  feilet="$feilet tflint-init"
fi

for mappe in "${TERRAFORM_MAPPER[@]}"; do
  echo "--- $mappe"
  if ! tflint --chdir="$mappe" --config="$TFLINT_CONFIG"; then
    feilet="$feilet tflint($mappe)"
  fi
done

echo "=== 4/4 Checkov ==="
for mappe in "${TERRAFORM_MAPPER[@]}"; do
  echo "--- $mappe"
  if ! checkov -d "$mappe" --config-file "$CHECKOV_CONFIG"; then
    feilet="$feilet checkov($mappe)"
  fi
done

echo
if [ -z "$feilet" ]; then
  echo "Alle kontrollene er grønne."
  exit 0
else
  echo "Feilet:$feilet"
  exit 1
fi