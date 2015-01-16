require 'formula'

class S3cmd < Formula
  homepage 'http://s3tools.org/s3cmd'
  url 'http://downloads.sourceforge.net/project/s3tools/s3cmd/1.5.0/s3cmd-1.5.0.tar.gz'
  sha1 '53ebc485329cb15cad8f61ca0c8c2d06563ee2f3'
  head 'https://github.com/s3tools/s3cmd.git'

  def install
    libexec.install 's3cmd', 'S3'
    man1.install 's3cmd.1'
    bin.install_symlink libexec+'s3cmd'
  end
end
