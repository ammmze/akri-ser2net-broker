# akri-ser2net-broker

Broker for [akri](https://github.com/deislabs/akri) that provides ser2net functionality.

This broker expects to be used with the udev discovery available with Akri.

When configured properly, Akri should be able to create this container and inject `UDEV_DEVNODE` environment
variable. When this environment variable is present we will start ser2net for the device at `UDEV_DEVNODE`.

This image has a few configuration properties that will be used in the ser2net command.
See more about the `ser2net` configuration [here](https://linux.die.net/man/8/ser2net).

| Name | Default | Description |
| --- | --- | --- |
| `PORT` | `2000` | The port that ser2net will listen on for this device |
| `STATE` | `raw` | Either raw or rawlp or telnet or off |
| `TIMEOUT` | `0` | The time (in seconds) before the port will be disconnected if there is no activity on it. A zero value disables this funciton. |
| `DEVICE_OPTIONS` | _not set_ | Device configuration options such as baud rate, stop bits, etc. | 

An example configuration for this could be something like this:

```yaml
apiVersion: akri.sh/v0
kind: Configuration
metadata:
  name: ti-cc2531
  namespace: host-system
spec:
  # how many things can claim a found device resource
  capacity: 1
​
  discoveryHandler:
    name: udev
    discoveryDetails: |+
      udevRules:
        - ATTRS{bDeviceClass}=="02", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="16a8", SUBSYSTEM=="tty"
  
  brokerPodSpec:
    containers:
      - name: ti-cc2531-broker
        image: ammmze/akri-ser2net-broker:latest
        imagePullPolicy: IfNotPresent
        securityContext:
          privileged: true
        env:
          - name: DEVICE_OPTIONS
            value: "9600"
        ports:
          - name: device
            containerPort: 2000
        resources:
          requests:
            "{{PLACEHOLDER}}": '1'
            cpu: 10m
            memory: 50Mi
          limits:
            "{{PLACEHOLDER}}": '1'
            cpu: 100m
            memory: 200Mi
​
  configurationServiceSpec:
    type: ClusterIP
    ports:
      - name: device
        port: 2000
        protocol: TCP
        targetPort: device
```