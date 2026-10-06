#!/usr/bin/env bash

set -euo pipefail

script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
package_directory="$(cd "${script_directory}/.." && pwd)"
generator_directory="${SOTO_CODEGENERATOR_DIRECTORY:-${package_directory}/../soto-codegenerator}"
source_directory="${package_directory}/Sources/FeatherSotoSES"

if [[ ! -f "${generator_directory}/Package.swift" ]]; then
    echo "Soto code generator package not found: ${generator_directory}" >&2
    echo "Set SOTO_CODEGENERATOR_DIRECTORY to a local soto-codegenerator checkout." >&2
    exit 1
fi

swift run \
    --package-path "${generator_directory}" \
    SotoCodeGenerator \
    --input-file "${source_directory}/sesv2-2019-09-27.json" \
    --config "${source_directory}/soto.config.json" \
    --prefix sesv2_2019_09_27 \
    --output-folder "${source_directory}"

# Keep generated sources compatible with this package's strict import and
# existential settings. SES models use FoundationEssentials internally but do
# not expose its types in public declarations.
for generated_file in "${source_directory}"/sesv2_2019_09_27_*.swift; do
    perl -pi -e 's/^public import FoundationEssentials$/import FoundationEssentials/; s/^public import Foundation$/import Foundation/; s/from decoder: Decoder/from decoder: any Decoder/g; s/to encoder: Encoder/to encoder: any Encoder/g; s/AWSErrorShape\.Type/any AWSErrorShape.Type/g; s/AWSMiddlewareProtocol\?/(any AWSMiddlewareProtocol)?/g' "${generated_file}"
done
