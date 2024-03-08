### create application
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation CreateApplication {
    createApplication(data: {name: "{{app_name}}", source: "{{source}}"}) {
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

### create build
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation CreateBuild {
  createBuild(data: {buildId: "{{build_id}}", size: "{{size}}", version: "{{app_name}}-{{app_version}}", architecture: "{{arch}}", distribution: "{{dist}}", distRelease: "{{dist_release}}", application: {connect: {name: "{{app_name}}"}}}) {
    id
  }
}
```

### publish build
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation PublishBuild {
  publishBuild(where: {version: "{{app_name}}-{{app_version}}"}) {
    id
  }
}
```
