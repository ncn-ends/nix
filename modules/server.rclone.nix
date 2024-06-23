# make storage account on azure, then turn it into cool storage
# `rclone config` then go through the process self explanatory. set the name to the unique dns name chosen in the azure dashboard. only set the key to the access key in the azure dashboard, then set the rest as defaults. 
# rclone mkdir azure-backup:test                                         --- make file in bucket - good test command
# rclone lsd azure-backup:                                               --- list all buckets/containers
# rclone ls azure-backup:test-bucket                                     --- list files in the bucket
# rclone sync /path/to/directory azure-backup:test                       --- sync a directory 1 time with
# rclone copy /path/to/directory azure-backup:test/directory             --- upload a folder - use -P flag for more verbosity
# use the ---filter-from flag to use ignore files, similar to gitignore
# rclone mount azure-backup:test /home/one/azure-backup --daemon         --- mounts the bucket to a local directory, make sure directory exists first
#   - avoid mounting for now, so that cost can be compared in isolation later
# fusermount -u /home/one/azure-backup                                   --- unmounts

{...}: {
  # to make gpg work on nixos for encrypting tarball before uploading with rclone
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;
}