# Intro

This project originated from https://github.com/tuler/s3-check-action and was created in response to the set-output deprecated issue

# GitHub Action to check if a file exists in an S3 Bucket

> **⚠️ Note:** To use this action, you must have access to the [GitHub Actions](https://github.com/features/actions) feature. GitHub Actions are currently only available in public beta. You can [apply for the GitHub Actions beta here](https://github.com/features/actions/signup/).

This simple action uses the [vanilla AWS CLI](https://docs.aws.amazon.com/cli/index.html) to check if a file exists in an S3 bucket, and set an output to true or false. This is useful to "short-circuit" a job and not do unnecessary subsequent steps.

## Usage

This action is particularly useful for scheduled builds (a.k.a nightly builds).
You don't need to do all the work again if you already have the results from the previous execution, and nothing has changed since then.

GitHub Actions does not provide a way to verify this, so you have to rely on an external `flag` to control this behaviour.

This action relies on an file you host in a S3 bucket. Your build can write a file with the name of the ${GITHUB_SHA}, and before executing the build steps check if the file already exists. If it exists the build does not fail, but creates an output variable that you can check before running the build steps.

### `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

```yaml
name: Check if Static file exists in S3 Bucket
on:
  schedule:
    - cron: '0 0 * * *'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - uses: SilverNine/s3-file-exists-action@master
        id: check
        env:
          FILE: ${{ github.sha }}
          AWS_S3_REGION: 'us-east-1'
          AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      - name: Fail if Static file does not exist
        run: echo "ERROR: Static file not found in S3 bucket"
        if: steps.check.outputs.exists == 'false'
      - name: Success if Static file does exist
        run: echo "Write a file to S3 bucket with name \${GITHUB_SHA}"
        if: steps.check.outputs.exists == 'true'
```

### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository.

| Key                     | Value                                                                                                                                                                                                                     | Suggested Type | Required |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------- |
| `AWS_ACCESS_KEY_ID`     | Your AWS Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                       | `secret`       | **Yes**  |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key. [More info here.](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)                                                                                                | `secret`       | **Yes**  |
| `AWS_S3_BUCKET`         | The name of the bucket you're syncing to. For example, `jarv.is`.                                                                                                                                                         | `secret`       | **Yes**  |
| `AWS_REGION`            | The region where you created your bucket in. For example, `us-east-1`. [Full list of regions here.](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) | `env`          | **Yes**  |
| `FILE`                  | The file to check                                                                                                                                                                                                         | `env`          | **Yes**  |

## License

This project is distributed under the [MIT license](LICENSE.md).
