require 'formula'

class S3cmd < Formula
  homepage 'http://s3tools.org/s3cmd'
  url 'http://downloads.sourceforge.net/project/s3tools/s3cmd/1.0.1/s3cmd-1.0.1.tar.gz'
  sha1 '89eb9974cb523e0410db735d9d9991b355d053c1'

  devel do
    url 'http://downloads.sourceforge.net/project/s3tools/s3cmd/1.1.0-beta3/s3cmd-1.1.0-beta3.zip'
    sha1 '4e8e8dd0b60c0e3e146550f34ac2e8cf0a088a25'
  end

  def install
    libexec.install 's3cmd', 'S3'
    man1.install 's3cmd.1'
    bin.install_symlink libexec+'s3cmd'
  end
end
