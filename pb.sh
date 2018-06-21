#!/usr/bin/env bash

set -ex

# -I = Proto files root.
# --plugin = Register the protoc-gen-ts plugin with this build and point to where its located.
# --go_out = Signals that this compilation should output to Go and should use the gRPC plugin, then specifies where to put the generated Go source.
# --js_out = Generates the JavaScript for RPC specification and where to put it.
# --ts_out = Generated the TypeScript type definitions for the RPC specification and where to put it.
# Lasatly is/are the protoc argument(s) which is/are what file(s) to compile.
protoc --plugin="protoc-gen-ts=../ui/node_modules/.bin/protoc-gen-ts" -I="./src" --go_out=plugins=grpc:"../rpc/pkg" --js_out="import_style=commonjs,binary:../ui/src/app/pb" --ts_out="../ui/src/app/pb" "./src/evolve.proto"
echo ========================= SUCCESS =========================
