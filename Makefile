createdb:
	docker compose exec -it postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker compose exec -it postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover -short ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination ./db/mock/store.go github.com/Nuriddin-Olimjon/simplebank/db/sqlc Store

proto:
	rm -f pb/*.go
	rm -f docs/swagger/*.swagger.json

	protoc \
	--proto_path=proto \
	--go_out=pb \
	--go_opt=paths=source_relative \
	--go-grpc_out=pb \
	--go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb \
	--grpc-gateway_opt paths=source_relative \
	--openapiv2_out=docs/swagger \
	--openapiv2_opt=allow_merge=true,merge_file_name=simple_bank \
	--experimental_allow_proto3_optional \
	proto/*.proto

	statik -f -src=./docs/swagger -dest=./docs

evans:
	evans --host localhost --port 9090 -r repl

.PHONY: createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc test server mock proto evans
