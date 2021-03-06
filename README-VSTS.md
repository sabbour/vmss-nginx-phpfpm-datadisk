# How to setup the CI/CD pipeline through VSTS

## Build Variables

Create Build Variables and fill them with the required values.

![](docs/bv1.png)

![](docs/bv2.png)

![](docs/bv3.png)

![](docs/bv4.png)

## Set the Build Number Format

![](docs/bnf.png)

```
$(MajorVersion).$(MinorVersion).$(Date:yyMMdd)$(Rev:.r)
```

This will generate build numbers like `1.0.180506.1` and `1.0.180506.2` for each build per day and will reset on the next day like so `1.0.180507.1`.

When you do major changes, make sure to update the Major/Minor build variables accordingly.

## Build Pipeline

- Select Hosted Build Agent Linux

- Use a Shell task to run `ci/getpacker.sh`

- Use a Shell task to run `ci/runpacker.sh`

![](docs/build-pipeline.png)

Configure build triggers as you wish.

When this runs, you should end up with a new VM image created in the Resource Group you specified.

![](docs/images.png)

## Release Variables

Set the variables for the release accordingly.

![](docs/release-vars.png)
## Release Pipeline

- Add an ARM deployment step and overwrite the parameters

![](docs/create-update-vmss.png)

![](docs/override-arm-param.png)