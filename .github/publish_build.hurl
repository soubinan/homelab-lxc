### create application
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation CreateApplication {
  upsertApplication(
    upsert: {create: {name: "{{app_name}}", source: "{{source}}", categories: {{categories}}, isForTest: {{is_for_test}}}, update: {categories: {{categories}}, isForTest: {{is_for_test}}, name: "{{app_name}}", source: "{{source}}"}}
    where: {name: "{{app_name}}"}
  ) {
    id
  }
}
```

### create build
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation CreateBuild {
  upsertBuild(
    upsert: {create: {buildId: "{{build_id}}", size: "{{size}}", version: "{{app_name}}-{{app_version}}", architecture: "{{arch}}", distribution: "{{dist}}", distRelease: "{{dist_release}}", application: {connect: {name: "{{app_name}}"}}}, update: {architecture: "{{arch}}", buildId: "{{build_id}}", distRelease: "{{dist}}", distribution: "{{dist_release}}", size: "{{size}}", version: "{{app_name}}-{{app_version}}", application: {connect: {name: "{{app_name}}"}}}}
    where: {buildId: "{{build_id}}"}
  ) {
    id
  }
}
```

### publish build
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation PublishBuild {
  publishBuild(where: {buildId: "{{build_id}}"}) {
    id
  }
}
```

### publish application
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation PublishApplication {
  publishApplication(where: {name: "{{app_name}}"}) {
    id
  }
}
```