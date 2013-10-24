require 'formula'

class S3cmd < Formula
  homepage 'http://s3tools.org/s3cmd'
  url 'https://github.com/s3tools/s3cmd/archive/v1.0.1.zip'
  sha1 '4a6f7bfb9300b728ca466967b91aa07521ef6f80'
  head 'https://github.com/s3tools/s3cmd.git'

  def install
    libexec.install 's3cmd', 'S3'
    man1.install 's3cmd.1'
    bin.install_symlink libexec+'s3cmd'
  end
end
