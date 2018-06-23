#!/usr/bin/env bash

# Echo every command to the console.
set -x

: ------------------- VARIABLES AND VALUES -------------------
: PROTOC_GEN_GO_LOCATION = ${PROTOC_GEN_GO_LOCATION}
: PROTOC_GEN_TS_LOCATION = ${PROTOC_GEN_TS_LOCATION}
: GO_OUTPUT_LOCATION = ${GO_OUTPUT_LOCATION}
: JS_OUTPUT_LOCATION = ${JS_OUTPUT_LOCATION}
: TS_OUTPUT_LOCATION = ${TS_OUTPUT_LOCATION}

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