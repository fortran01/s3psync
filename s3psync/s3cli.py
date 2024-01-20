import os
import subprocess
import time
from multiprocessing import Pool

# A function defined at the module level is picklable because the child process can import the module and access the function.
def sync_file(file_info, parent_dir, aws_profile, s3_bucket):
    relative_path, file = file_info
    abs_path = os.path.join(parent_dir, relative_path) if relative_path != "." else parent_dir + "/"
    s3_path = f"s3://{s3_bucket}/{relative_path}/" if relative_path != "." else f"s3://{s3_bucket}/"
    cmd = ['aws', 's3', 'sync', '--profile', aws_profile, '--exclude' , '*', '--include', f'*{file}', '--quiet', abs_path, s3_path]
    print(f"Running command: {' '.join(cmd)}")
    subprocess.run(cmd, check=True)

class S3CLI:
  def __init__(self, aws_profile):
    self.aws_profile = aws_profile
    
    self._check_awscli()

  def _check_awscli(self):
    try:
      subprocess.check_output(['aws', '--version'])
    except Exception as e:
      print(f"Exception occurred: {e}")

  def get_files(self, parent_dir):
    file_list = []
    if not os.path.isdir(parent_dir):
      print(f"{parent_dir} is not a directory.")
      return file_list
    for root, dirs, files in os.walk(parent_dir):
      if not os.path.isdir(root):
        print(f"{root} is not a directory.")
        continue
      for file in files:
        relative_path = os.path.relpath(root, parent_dir)
        file_list.append((relative_path, file))
    return file_list
  
  def get_total_size(self, parent_dir, file_list):
    """
    This method calculates the total size of all files in the provided list in bytes.
    Each file in the list is represented as a tuple (relative_path, file_name).
    The method iterates over the list, calculates the size of each file and sums them up.
    
    :param parent_dir: The parent directory where the files are located
    :param file_list: List of tuples, where each tuple represents a file as (relative_path, file_name)
    :return: total size of all files in the list in bytes
    """
    total_size = 0
    for relative_path, file in file_list:
      if relative_path == ".":
        relative_path = ""
      abs_path = os.path.join(parent_dir, relative_path, file)
      total_size += os.path.getsize(abs_path)
    return total_size
      
  def sync(self, parent_dir, s3_bucket, parallel_instances):
      file_list = self.get_files(parent_dir)
      total_size = self.get_total_size(parent_dir, file_list)
      start_time = time.time()
      
      # Use a partial function to pass the extra arguments to sync_file
      from functools import partial
      sync_file_with_args = partial(sync_file, parent_dir=parent_dir, aws_profile=self.aws_profile, s3_bucket=s3_bucket)

      with Pool(parallel_instances) as p:
          p.map(sync_file_with_args, file_list)
          p.close()
          p.join()

      end_time = time.time()
      elapsed_time = end_time - start_time
      total_size_mb = total_size / (1024 * 1024)
      total_size_gb = total_size_mb / 1024
      average_rate = total_size_mb / elapsed_time
      print(f"Total size: {total_size_mb} MB or {total_size_gb} GB")
      print(f"Number of files: {len(file_list)}")
      print(f"Elapsed time: {elapsed_time} seconds")
      print(f"Average rate: {average_rate} MB/sec")