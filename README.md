# dynamic-parameters
Relist service-catalog parameters after a specific kubernetes resource changes.

Select the resource you want to trigger a catalog relist.
Edit dynamic-params.yml:
```yaml
    - name: RESOURCE
      value: "pod"
```

Create the pod.
```
oc create -f dynamic-params.yml
```
