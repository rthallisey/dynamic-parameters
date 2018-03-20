#!/usr/bin/env python

import json
import os
import subprocess

json_data=open("/opt/apb/bundle.json").read()
data = json.loads(json_data)
print(data)

bash = "oc get pods --no-headers | awk '{ print $1 }'"
process = subprocess.Popen(['bash', "-c",  bash], stdout=subprocess.PIPE)
output, error = process.communicate()
pods = output.split('\n')[:-1]

for plan in data['spec']['plans']:
    for param in plan['parameters']:
        param['enum'] = pods


print data['spec']['plans'][0]['parameters'][0]['enum']

with open('/opt/apb/patch.json', 'w') as outfile:
    json.dump(data, outfile)
