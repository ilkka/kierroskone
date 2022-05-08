import * as THREE from "three";
import { FBXLoader } from "three/examples/jsm/loaders/FBXLoader.js";

export default function (parentElement, data) {
  const telemetry = data[0];
  const recordTelemetry = data.length > 1 ? data[1] : null;
  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0xffffff);
  const camera = new THREE.PerspectiveCamera(
    90,
    parentElement.clientWidth / parentElement.clientHeight,
    0.1,
    2000
  );

  const renderer = new THREE.WebGLRenderer();
  renderer.setSize(parentElement.clientWidth, parentElement.clientHeight);
  parentElement.appendChild(renderer.domElement);

  const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
  scene.add(directionalLight);

  const ambientLight = new THREE.AmbientLight(0xffffff, 1);
  scene.add(ambientLight);

  const geometry = new THREE.BoxGeometry();

  const position = telemetry[0].WorldPosition;

  console.log(position);

  const coordinateScale = 0.1;

  const toScaledWorldPosition = (scale) => (tItem) =>
    [
      tItem.WorldPosition[0] * scale,
      tItem.WorldPosition[1] * scale,
      tItem.WorldPosition[2] * scale,
    ];
  const route = telemetry.map(toScaledWorldPosition(coordinateScale));
  const recordRoute = recordTelemetry?.map(
    toScaledWorldPosition(coordinateScale)
  );

  const routeLength = route.length;

  const min = { x: null, y: null, z: null };
  const max = { x: null, y: null, z: null };

  for (let i = 0; i < routeLength; ++i) {
    const [x, y, z] = route[i];
    min["x"] = min["x"] === null ? x : Math.min(x, min["x"]);
    min["y"] = min["y"] === null ? y : Math.min(y, min["y"]);
    min["z"] = min["z"] === null ? z : Math.min(z, min["z"]);
    max["x"] = Math.max(x, max["x"]);
    max["y"] = Math.max(y, max["y"]);
    max["z"] = Math.max(z, max["z"]);
  }

  console.dir(min);
  console.dir(max);

  const x_offset = (max.x + min.x) / 2;
  const y_offset = (max.y + min.y) / 2;
  const z_offset = (max.z + min.z) / 2;

  const x_size = max.x - min.x;
  const z_size = max.z - min.z;

  console.log(x_offset, y_offset, z_offset);

  camera.position.set(
    x_offset,
    Math.max(80, Math.max(x_size, z_size) * 0.6),
    z_offset
  );
  camera.lookAt(new THREE.Vector3(x_offset, y_offset, z_offset));
  console.log(camera.position);

  const fbxLoader = new FBXLoader();
  fbxLoader.load("/models/low_poly/Low-Poly-Racing-Car.fbx", (player1) => {
    console.log(player1);
    player1.traverse(function (child) {
      if (child.isMesh) {
        // console.log( child.name, child.geometry.attributes.uv );
        // child.material.map = texture; // assign your diffuse texture here
      }
    });

    scene.add(player1);
    player1.scale.x = 0.02;
    player1.scale.y = 0.02;
    player1.scale.z = 0.02;

    const recordHolder = player1.clone();
    scene.add(recordHolder);
    recordHolder.scale.x = 0.02;
    recordHolder.scale.y = 0.02;
    recordHolder.scale.z = 0.02;

    let playerPosIdx = 0;
    let playerPos = route[playerPosIdx];
    let playerTelemetryItem = telemetry[playerPosIdx];
    let nextPlayerPosIdx = (playerPosIdx + 1) % route.length;
    let nextPlayerPos = route[nextPlayerPosIdx];
    let nextPlayerTelemetryItem = telemetry[nextPlayerPosIdx];

    let recordPosIdx = 0;
    let recordPos = recordRoute[recordPosIdx];
    let recordTelemetryItem = recordTelemetry[recordPosIdx];
    let nextRecordPosIdx = (recordPosIdx + 1) % recordRoute.length;
    let nextRecordPos = recordRoute[nextRecordPosIdx];
    let nextRecordTelemetryItem = recordTelemetry[nextRecordPosIdx];

    player1.position.set(playerPos[0], playerPos[1], playerPos[2]);
    player1.lookAt(nextPlayerPos[0], nextPlayerPos[1], nextPlayerPos[2]);
    recordHolder.position.set(recordPos[0], recordPos[1] - 0.5, recordPos[2]);
    recordHolder.lookAt(
      nextRecordPos[0],
      nextRecordPos[1] - 0.5,
      nextRecordPos[2]
    );

    const worldTimeScaleFactor = 3;
    let lastFrameTimestamp = 0;

    function animate(timestamp) {
      const scaledWorldTime =
        playerTelemetryItem.LapTime +
        (timestamp - lastFrameTimestamp) * worldTimeScaleFactor;
      // update player to next point if
      // - next point laptime < timestamp (we moved)
      // - next point laptime < current point laptime (we looped)
      if (
        nextPlayerTelemetryItem.LapTime <= scaledWorldTime ||
        nextPlayerTelemetryItem.LapTime < playerTelemetryItem.LapTime
      ) {
        playerPosIdx = nextPlayerPosIdx;
        playerPos = nextPlayerPos;
        playerTelemetryItem = nextPlayerTelemetryItem;
        nextPlayerPosIdx = (playerPosIdx + 1) % route.length;
        nextPlayerPos = route[nextPlayerPosIdx];
        nextPlayerTelemetryItem = telemetry[nextPlayerPosIdx];
        lastFrameTimestamp = timestamp;
      }

      // update record holder to next point if next point laptime < timestamp but only as long as the time increases
      // (stop when the record lap ends)
      if (
        nextRecordTelemetryItem.LapTime > recordTelemetryItem.LapTime &&
        nextRecordTelemetryItem.LapTime <= scaledWorldTime
      ) {
        recordPosIdx = nextRecordPosIdx;
        recordPos = nextRecordPos;
        recordTelemetryItem = nextRecordTelemetryItem;
        nextRecordPosIdx = (recordPosIdx + 1) % recordRoute.length;
        nextRecordPos = recordRoute[nextRecordPosIdx];
        nextRecordTelemetryItem = recordTelemetry[nextRecordPosIdx];
      }

      // if player idx rolls over, reset record idx
      if (playerPosIdx === 0) {
        recordPosIdx = 0;
        recordPos = recordRoute[recordPosIdx];
        recordTelemetryItem = recordTelemetry[recordPosIdx];
        nextRecordPosIdx = (recordPosIdx + 1) % recordRoute.length;
        nextRecordPos = recordRoute[nextRecordPosIdx];
        nextRecordTelemetryItem = recordTelemetry[nextRecordPosIdx];
      }

      player1.position.set(playerPos[0], playerPos[1], playerPos[2]);
      player1.lookAt(nextPlayerPos[0], nextPlayerPos[1], nextPlayerPos[2]);
      recordHolder.position.set(recordPos[0], recordPos[1] - 0.5, recordPos[2]);
      recordHolder.lookAt(
        nextRecordPos[0],
        nextRecordPos[1] - 0.5,
        nextRecordPos[2]
      );

      const material = new THREE.MeshPhongMaterial({ color: 0x111111 });
      const crumb = new THREE.Mesh(geometry, material);
      crumb.position.set(playerPos[0], playerPos[1] - 1, playerPos[2]);
      crumb.scale.x = 1;
      crumb.scale.y = 0.1;
      crumb.scale.z = 1;
      scene.add(crumb);

      camera.lookAt(player1.position);
      camera.zoom = Math.max(
        1,
        camera.position.distanceTo(crumb.position) * 0.02
      );
      camera.updateProjectionMatrix();

      requestAnimationFrame(animate);
      renderer.render(scene, camera);
    }

    requestAnimationFrame(animate);
  });
}
