# PingOne Custom DNS with Cloudflare Example

## Create valid certs

Use a service like LetsEncrypt and the [Certbot](https://certbot.eff.org/) tool.

The certificate must not be expired, must not be self signed and the domain must match one of the subject alternative name (SAN) values on the certificate.

Create a new directory `./assets` and set:
* The certificate as `./assets/domain.test.crt`
* The certificate key as `./assets/domain.test.key`
* The trust chain as `./assets/chain.pem`

## Create a PingOne Environment

TBC - Use the web console, only "SSO" capability is required

## Create a PingOne worker client

TBC - Must have `Environment Admin` rights to the PingOne Environment created above

## Set the Environment Variables

Create an environment file:

```shell
cp setenv.sh.template setenv.sh
chmod +x setenv.sh
```

Modify `setenv.sh` as required, then:

```shell
. ./setenv.sh
```

## Run it

Initialise TF
```shell
terraform init
```

Run plan to test connections
```shell
terraform plan -out infra.tfout
```

Run apply to create the config
```shell
terraform apply "infra.tfout"
```

Destroy the config
```shell
terraform destroy
```