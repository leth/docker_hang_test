from __future__ import print_function
import os
import json
import time

import docker

_HERE = os.path.dirname(__file__)

docker_client = docker.Client()
tag = 'img_' + str(time.time())

build_stream = docker_client.build(
    tag=tag,
    path=os.path.join(_HERE, 'test_build'),
    rm=True,
    stream=True,
)

item = None
for blob in build_stream:
    if item is None:
        print('Context upload complete. Build started')
    item = json.loads(blob)
    print(item)
    if 'stream' in item:
        pass
    elif 'status' in item:
        pass
    elif 'error' in item:
        raise Exception(item['error'])
print('Build complete.')

docker_client.remove_image(tag, noprune=True)