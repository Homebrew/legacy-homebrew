require 'formula'

class S3cmd < Formula
  homepage 'http://s3tools.org/s3cmd'
  url 'http://downloads.sourceforge.net/project/s3tools/s3cmd/1.0.1/s3cmd-1.0.1.tar.gz'
  sha1 '89eb9974cb523e0410db735d9d9991b355d053c1'

  devel do
    url 'http://downloads.sourceforge.net/project/s3tools/s3cmd/1.5.0-alpha3/s3cmd-1.5.0-alpha3.tar.gz'
    sha1 '18e980c66bdf5fa1c606c95727d43978a4d90635'
  end

  def install
    libexec.install 's3cmd', 'S3'
    man1.install 's3cmd.1'
    bin.install_symlink libexec+'s3cmd'
  end
end
