require 'formula'

class Icon < Formula
  homepage 'http://www.cs.arizona.edu/icon/'
  url 'http://www.cs.arizona.edu/icon/ftp/packages/unix/icon-v950src.tgz'
  md5 '3f9b89bb8f2c0fb3e9c75d1b52fb5690'
  version '9.5.0'

  def install
    ENV.deparallelize
    system 'make', 'Configure', 'name=posix'
    system 'make'
    bin.install 'bin/icon', 'bin/icont', 'bin/iconx'
    doc.install Dir['doc/*']
    man1.install Dir['man/man1/*.1']
  end
end
