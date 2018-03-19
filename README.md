# dynamic-parameters
Relist service-catalog parameters after a specific kubernetes resource changes.

Choose the resource you want to trigger a catalog relist by editing
dynamic-params.yml:
```yaml
    - name: RESOURCE
      value: "pod"
```

Create the pod.
```
oc create -f dynamic-params.yml
```
