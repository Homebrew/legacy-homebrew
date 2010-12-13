require 'formula'

class S3cmd <Formula
  url 'http://downloads.sourceforge.net/project/s3tools/s3cmd/0.9.9.91/s3cmd-0.9.9.91.tar.gz'
  homepage 'http://s3tools.org/s3cmd'
  md5 '0b8334ab4ffb1e09d6964861dc001e0f'

  def install
    libexec.install Dir['s3cmd', 'S3']
    man1.install 's3cmd.1'
    bin.mkpath
    ln_s libexec+'s3cmd', bin
  end
end
