### create application
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation CreateApplication {
  upsertApplication(
    upsert: {
      create: {
        name: "{{app_name}}",
        source: "{{source}}",
        description: "{{description}}",
        categories: {{categories}},
        isForTest: {{is_for_test}}
      },
      update: {
        name: "{{app_name}}",
        source: "{{source}}"
        description: "{{description}}",
        categories: {{categories}},
        isForTest: {{is_for_test}},
      }
    }
    where: {
      name: "{{app_name}}"
    }
  ) { id }
}
```

### create build
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation CreateBuild {
  upsertBuild(
    upsert: {
      create: {
        buildId: "{{build_id}}",
        version: "{{app_name}}-{{app_version}}",
        distribution: "{{dist}}",
        distRelease: "{{dist_release}}",
        architecture: "{{arch}}",
        size: "{{size}}",
        application: {
          connect: {
            name: "{{app_name}}"
          }
        }
      },
      update: {
        buildId: "{{build_id}}",
        version: "{{app_name}}-{{app_version}}",
        distribution: "{{dist}}",
        distRelease: "{{dist_release}}",
        architecture: "{{arch}}",
        size: "{{size}}",
        application: {
          connect: {
            name: "{{app_name}}"
          }
        }
      }
    }
    where: {
      buildId: "{{build_id}}"
    }
  ) { id }
}
```

### publish build
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation PublishBuild {
  publishBuild(
    where: {
      buildId: "{{build_id}}"
    }
  ) { id }
}
```

### publish application
POST {{endpoint_url}}
Authorization: Bearer {{token}}

```graphql
mutation PublishApplication {
  publishApplication(
    where: {
      name: "{{app_name}}"
    }
  ) { id }
}
```
