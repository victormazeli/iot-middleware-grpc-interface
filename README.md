# iot-middleware-grpc-interface

Shared gRPC, REST (grpc-gateway), and event contract for the IoT middleware and backend services.

## Import

```go
import iotv1 "github.com/victormazeli/iot-middleware-grpc-interface/gen/go/iot/v1"
```

### gRPC client (backend)

```go
conn, err := grpc.NewClient("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
client := iotv1.NewDeviceServiceClient(conn)
resp, err := client.CheckoutStandard(ctx, &iotv1.CheckoutRequest{
    DeviceId: "DEVICE001",
    OrderId:  "order-123",
})
```

### REST client

When the middleware HTTP gateway is enabled (`HTTP_LISTEN_ADDR`, default `:8080`):

```bash
curl http://localhost:8080/v1/health
curl -X POST http://localhost:8080/v1/devices/DEVICE001/checkout/standard \
  -H 'Content-Type: application/json' \
  -d '{"order_id":"order-123"}'
```

JSON field names follow proto JSON mapping (`device_id`, `order_id`, snake_case).

### OpenAPI / Postman

Generated Swagger 2.0 spec (committed):

```
gen/openapi/iot/v1/device.swagger.json
```

Import into Postman: **Import → File** (use path above) or **Import → Link** → `http://localhost:8080/openapi.json` when the server is running.

Interactive docs: `http://localhost:8080/docs` (Swagger UI).

### Event consumption (RabbitMQ)

Events are published as JSON `EventEnvelope` messages. Deserialize with `protojson`:

```go
import "google.golang.org/protobuf/encoding/protojson"

var env iotv1.EventEnvelope
protojson.Unmarshal(body, &env)
```

## Versioning

Tag semver releases (`v0.1.0`, `v1.0.0`). Pin the same version in middleware and all backend `go.mod` files.

## Development

```bash
make generate   # requires buf CLI
make lint
```

Generated Go is committed so consumers do not need protoc/buf.

## Local development

In consumer `go.mod`:

```
replace github.com/victormazeli/iot-middleware-grpc-interface => ../iot-middleware-grpc-interface
```

Or use a `go.work` file at the monorepo root.
