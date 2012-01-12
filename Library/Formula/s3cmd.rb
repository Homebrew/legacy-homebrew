require 'formula'

class S3cmd < Formula
  url 'http://downloads.sourceforge.net/project/s3tools/s3cmd/1.0.1/s3cmd-1.0.1.tar.gz'
  homepage 'http://s3tools.org/s3cmd'
  md5 'dc62becc03a3e6100843611ebe2707c2'

  def install
    libexec.install Dir['s3cmd', 'S3']
    man1.install 's3cmd.1'
    bin.mkpath
    ln_s libexec+'s3cmd', bin
  end
end
