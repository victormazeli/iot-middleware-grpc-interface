# iot-middleware-grpc-interface

Shared gRPC and event contract for the IoT middleware and backend services.

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
