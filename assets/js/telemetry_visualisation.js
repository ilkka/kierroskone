import * as THREE from 'three';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js';
import { FBXLoader } from 'three/examples/jsm/loaders/FBXLoader.js'

export default function(parentElement, telemetry) {
	const scene = new THREE.Scene();
	scene.background = new THREE.Color(0xFFFFFF)
	const camera = new THREE.PerspectiveCamera( 90, parentElement.clientWidth / parentElement.clientHeight, 0.1, 2000 );

	const renderer = new THREE.WebGLRenderer();
	renderer.setSize( parentElement.clientWidth, parentElement.clientHeight );
	parentElement.appendChild( renderer.domElement );

	const directionalLight = new THREE.DirectionalLight(0xFFFFFF, 1)
	scene.add(directionalLight)

	const ambientLight = new THREE.AmbientLight(0xFFFFFF, 1);
	scene.add(ambientLight);

	const geometry = new THREE.BoxGeometry();
	const material = new THREE.MeshPhongMaterial( { color: 0x00ff00 } );
	const cube = new THREE.Mesh( geometry, material );
	cube.position.x = 6;
	cube.position.y = 0;
	cube.position.z = 3;
	//scene.add( cube );

	const car = new THREE.Mesh( geometry, material );
	car.scale.x = 0.4
	car.scale.y = 0.4
	car.scale.z = 0.4

	// scene.add( car );


	// const loader = new GLTFLoader();
	// 
	// loader.load(new URL('./static/models/japanese_sedan/scene.gltf', import.meta.url).toString(), function ( gltf ) {
	// 
	// 	scene.add( gltf.scene );
	// 
	// }, undefined, function ( error ) {
	// 	console.log("error")
	// 	console.error( error );
	// 
	// } );
	const position = telemetry[0].WorldPosition;

	console.log(position)

	const coordinateScale = 0.1;

	const route = telemetry.map(tItem => ([
		tItem.WorldPosition[0] * coordinateScale,
		tItem.WorldPosition[1] * coordinateScale,
		tItem.WorldPosition[2] * coordinateScale
	]));

	const routeLength = route.length

	const min = { x: null, y: null, z: null }
	const max = { x: null, y: null, z: null }

	for (let i = 0; i < routeLength; ++i) {
		const [x, y, z] = route[i];
		min['x'] = min['x'] === null ? x : Math.min(x, min['x'])
		min['y'] = min['y'] === null ? y : Math.min(y, min['y'])
		min['z'] = min['z'] === null ? z : Math.min(z, min['z'])
		max['x'] = Math.max(x, max['x'])
		max['y'] = Math.max(y, max['y'])
		max['z'] = Math.max(z, max['z'])
	}

	console.dir(min);
	console.dir(max);



	const x_offset = (max.x + min.x) / 2;
	const y_offset = (max.y + min.y) / 2;
	const z_offset = (max.z + min.z) / 2;
	
	const x_size = max.x - min.x;
	const z_size = max.z - min.z;

	console.log(x_offset, y_offset, z_offset);

	camera.position.set(x_offset, Math.max(80, Math.max(x_size, z_size) * 0.6), z_offset)
	camera.lookAt(new THREE.Vector3(x_offset, y_offset, z_offset));
	console.log(camera.position)

	const fbxLoader = new FBXLoader()
	fbxLoader.load('/models/low_poly/Low-Poly-Racing-Car.fbx', player1 => {
		console.log(player1)
		player1.traverse( function ( child ) {

			if ( child.isMesh ) {
				// console.log( child.name, child.geometry.attributes.uv );
				// child.material.map = texture; // assign your diffuse texture here
			}

		} );

		scene.add(player1)
		player1.scale.x = 0.02
		player1.scale.y = 0.02
		player1.scale.z = 0.02

	
		let currentPoint = 0;
		let step = 0;

		console.log("Initial step", step);


		const nextPt = route[1];
		player1.lookAt(nextPt[0], nextPt[1], nextPt[2]);

		// camera.lookAt(car.position);
		function animate(timestamp) {
			if (timestamp !== undefined && step === 0 || (timestamp - step > 100)) {
				step = timestamp;
				if (currentPoint < routeLength - 1) {
					++currentPoint;
				} else {
					currentPoint = 0;
				}

				const pos = route[currentPoint];
				const nextPoint = route[(currentPoint + 1) % routeLength];
				//car.position.x = pos[0] / 100;
				//car.position.y = pos[1] / 100;
				//car.position.z = pos[2] / 100;
			
				player1.position.x = pos[0];
				player1.position.y = pos[1];
				player1.position.z = pos[2];
			
			
				// console.log(car.position);
				const material = new THREE.MeshPhongMaterial( { color: 0x111111 } );
				const crumb = new THREE.Mesh( geometry, material );
				crumb.position.x = pos[0];
				crumb.position.y = pos[1] - 1;
				crumb.position.z = pos[2];
				crumb.scale.x = 1;
				crumb.scale.y = 0.1;
				crumb.scale.z = 1;
				scene.add(crumb);
				//const nextDirection2D = (new THREE.Vector3(nextPoint[0], 0, nextPoint[2])).sub(new THREE.Vector3(currentPoint[0], 0, currentPoint[2]));
				//player1.rotateY(carDirection2D.angleTo(nextDirection2D));
				//carDirection2D = nextDirection2D;
				//player1.rotation.setFromVector3((new THREE.Vector3()).fromArray(nextPos).sub((new THREE.Vector3()).fromArray(pos)))
				player1.lookAt(nextPoint[0], nextPoint[1], nextPoint[2]);
				camera.lookAt(player1.position);
				camera.zoom = Math.max(1, camera.position.distanceTo(crumb.position) * 0.02);
				camera.updateProjectionMatrix();
			}
		
			requestAnimationFrame( animate );
			renderer.render( scene, camera );
		
		}
		animate()


	});
}
