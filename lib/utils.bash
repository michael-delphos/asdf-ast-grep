#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/ast-grep/ast-grep"
TOOL_NAME="ast-grep"
TOOL_TEST="ast-grep --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if ast-grep is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	# Find the latest version if "latest" is specified
	if [ "$version" = "latest" ]; then
		version=$(list_all_versions | sort_versions | tail -n1)
		if [ -z "$version" ]; then
			fail "No releases found for $TOOL_NAME."
		fi
		echo "Using latest version: $version"
	fi

	# https://github.com/ast-grep/ast-grep/releases/download/0.38.7/app-aarch64-apple-darwin.zip
	url="$GH_REPO/releases/download/${version}/$(get_llvm_triplet_variant "$version").zip"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

get_llvm_triplet_variant() {
	local version="$1"
	case "$(uname -s)" in
	Linux)
		case "$(uname -m)" in
		x86_64) echo app-x86_64-unknown-linux-gnu ;;
		aarch64 | arm64) echo aarch64-unknown-linux-gnu ;;
		*) fail "$(uname -m) is not supported on linux" ;;
		esac
		;;
	Darwin)
		case "$(uname -m)" in
		x86_64) echo app-x86_64-apple-darwin ;;
		arm64) echo app-aarch64-apple-darwin ;;
		*) fail "$(uname -m) is not supported on macos" ;;
		esac
		;;
	*) fail "$(uname -s) is not supported" ;;
	esac
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
