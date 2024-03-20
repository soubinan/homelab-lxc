const url = process.env.API_ENDPOINT;
const max_builds = process.env.MAX_BUILDS;
const buildsByAppsGQL = {
  query: `
    query BuildsByApps {
      applications (where: {isForTest: false}, orderBy: updatedAt_DESC) {
        name
        builds (orderBy: updatedAt_DESC) {
          buildId
          updatedAt
        }
      }
    }
  `,
}
const headers = {
  "content-type": "application/json;charset=UTF-8",
  "Accept": "application/json",
  "Authorization": `Bearer ${process.env.API_TOKEN}`
}
const buildsByAppsRequest = {
  body: JSON.stringify(buildsByAppsGQL),
  method: "POST",
  headers: headers
  ,
};

async function gatherResponse(response) {
  const { headers } = response;
  const contentType = headers.get("content-type") || "";
  if (contentType.includes("application/json")) {
    return (await response.json());
  }
}

async function deleteBuilds(appName, buildsIds) {
  const deleteBuildsGQL = {
    query: `
      mutation deleteBuilds {
        unpublishManyBuilds(where: {buildId_in: ${JSON.stringify(buildsIds)}}) {
          count
        }
      }
    `,
  }
  const deleteBuildsRequest = {
    body: JSON.stringify(deleteBuildsGQL),
    method: "POST",
    headers: headers,
  };
  const response = await fetch(url, deleteBuildsRequest);

  if (response.status == 200 && buildsIds.length > 0) {
    const publishApplicationGQL = {
      query: `
        mutation publishApplication {
          publishApplication(where: {name: "${appName}"}) {
            id
          }
        }
      `,
    }
    const publishApplicationRequest = {
      body: JSON.stringify(publishApplicationGQL),
      method: "POST",
      headers: headers,
    };

    fetch(url, publishApplicationRequest);

    console.info("All the selected builds has been successfully deleted.")
  } else {
    console.error("Build deletion failed: ", response.statusText)
  }
}

async function cleanupEligibleBuilds() {
  const buildsByAppsResponse = await fetch(url, buildsByAppsRequest);
  const buildsByAppsJsonData = await gatherResponse(buildsByAppsResponse);
  
  let eligibleBuilds = []
  
  buildsByAppsJsonData.data.applications.forEach(app => {
    let localEligibleBuilds = []
    
    if (app.builds.length > max_builds) {
      app.builds.slice(max_builds).forEach((build) => {
        console.info("The following build will be deleted: ", build.buildId);
        eligibleBuilds.push(build.buildId);
        localEligibleBuilds.push(build.buildId);
      });

      deleteBuilds(app.name, localEligibleBuilds);
    } else {
      console.info(`No build to be deleted for ${app.name}`);
    }
  });

  return (await eligibleBuilds)
}

cleanupEligibleBuilds().then((builds) => {
  const { exec } = require('child_process');
  
  builds.forEach((build) => {
    exec(`rclone delete cloudflare:lxc-images/${build}-root.tar.xz`, (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return;
      }
      if (stdout) {console.debug(`stdout: ${stdout}`);}
      if (stderr) {console.error(`stderr: ${stderr}`);}
    });
    exec(`rclone delete cloudflare:lxc-images/${build}-meta.tar.xz`, (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return;
      }
      if (stdout) {console.debug(`stdout: ${stdout}`);}
      if (stderr) {console.error(`stderr: ${stderr}`);}
    });
  });
});