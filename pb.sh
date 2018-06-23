#!/usr/bin/env bash

# Echo every command to the console.
set -x

: ------------------- VARIABLES AND VALUES -------------------
: PROTOC_GEN_GO_LOCATION = ${PROTOC_GEN_GO_LOCATION} # Location of protoc-gen-go executable's parent directory, should probably be "~/Go/bin".
: PROTOC_GEN_TS_LOCATION = ${PROTOC_GEN_TS_LOCATION} # Location of protoc-gen-ts executable, should probably be "<evolve-ui-project-root>/node_modules/.bin", after running npm install on evolve-ui.
: GO_OUTPUT_LOCATION = ${GO_OUTPUT_LOCATION} # Location to place generated Go files, should probably be "<evolve-rpc-project-root>/pkg/pb". Make sure this destination already exists.
: JS_OUTPUT_LOCATION = ${JS_OUTPUT_LOCATION} # Location to place generated JS files, should probably be "<evolve-ui-project-root>/src/app/pb". Make sure this destination already exists.
: TS_OUTPUT_LOCATION = ${TS_OUTPUT_LOCATION} # Location to place generated TS files, should probably be the same as JS_OUTPUT_LOCATION.

: ------------------- PROCEDURE -------------------
# Puts the path to "protoc-gen-go" in your PATH variable for this bash session. This MUST be provided as an environment variable for this script for it to function (at least on my machine).
export PATH="$PATH:$PROTOC_GEN_GO_LOCATION"

# --plugin = Register the protoc-gen-ts plugin with this build and point to where its located.
# --go_out = Signals that this compilation should output to Go and should use the gRPC plugin, then specifies where to put the generated Go source.
# --js_out = Generates the JavaScript for RPC specification and where to put it.
# --ts_out = Generated the TypeScript type definitions for the RPC specification and where to put it.
# -I = Protocol buffers files root.
# Lastly is/are the protoc argument(s) which is/are what file(s) to compile.
protoc --plugin=protoc-gen-ts="$PROTOC_GEN_TS_LOCATION" --go_out=plugins=grpc:"$GO_OUTPUT_LOCATION" --js_out=import_style=commonjs,binary:"$JS_OUTPUT_LOCATION" --ts_out=service=true:"$TS_OUTPUT_LOCATION" -I="./src" "./src/evolve.proto"

# The rest is just overhead to determine if protoc exited successfully and then to display that to the user.
protocReturnValue=$?
if [ ${protocReturnValue} != 0 ]; then
    : ================================================== FAILURE ==================================================
    exit ${protocReturnValue}
fi

: ================================================== SUCCESS ==================================================
exit 0