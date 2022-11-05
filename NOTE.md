# Generating server files
protoc -Iproto \
--go_out=. \
--go_opt=module=github.com/chittapon/grpc_chat/server \
--go-grpc_out=. \
--go-grpc_opt=require_unimplemented_servers=false \
--go-grpc_opt=module=github.com/chittapon/grpc_chat/server proto/service.proto

# Generating client files
dart pub global activate protoc_plugin
protoc -Iproto --dart_out=grpc:lib/generated proto/service.proto