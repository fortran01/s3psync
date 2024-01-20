# S3 Parallel Sync

This script is used to sync files and folders to an S3 bucket in parallel, leveraging the `aws s3 sync` command. The `aws s3 sync` command supports multipart uploads and can utilize up to 10 threads, making it particularly useful when you have a large number of large files to upload. This script allows you to specify the number of parallel instances of `aws s3 sync` to use.

## Requirements

- Python 3.10 or higher
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- AWS profile with the necessary permissions to perform S3 uploads (see [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) for more information on how to set up AWS profiles)
- Make utility ([Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm), Make for Linux and Mac is usually pre-installed)
  
## Usage

Next, you need to set up the environment using the provided Makefile. Follow these steps:

1. Ensure you have `make` installed on your system. You can check this by running `make --version` in your terminal. Install or update `make` if needed.

2. Install the necessary dependencies by running `make install` or `make all`.

3. Create a Python virtual environment by running `python3 -m venv --prompt s3psync venv`. Activate it by running `source venv/bin/activate`.

4. Verify the installation by running `s3psync --version`. If the tool is installed correctly, it should display the version number.

5. Exit the virtual environment by running `deactivate`.

To sync files and folders to an S3 bucket in parallel, run the following command:

```bash
madb --help
```

```text
Usage: s3psync [OPTIONS]

Options:
  --version
  --aws-profile TEXT            AWS profile name  [required]
  --parent-dir TEXT             Parent directory to sync  [required]
  --s3-bucket TEXT              S3 bucket to sync to  [required]
  --parallel-instances INTEGER  Number of parallel instances for aws s3 sync,
                                default is 1
  --help                        Show this message and exit.
```

Here is an example of how to use the tool:

```bash
s3psync \
  --aws-profile tmpuser_for_data_upload \
  --s3-bucket premtests1232 \
  --parent-dir "/path/to/testdir" \
  --parallel-instances 30
```

Note that you need to have the necessary AWS permissions to perform S3 uploads. The tool will use the AWS CLI to perform the upload, so you need to have the AWS CLI installed and configured with the appropriate credentials. You can use the `--aws-profile` option to specify the AWS profile to use.
