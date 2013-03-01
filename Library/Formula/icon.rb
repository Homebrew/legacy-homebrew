require 'formula'

class Icon < Formula
  homepage 'http://www.cs.arizona.edu/icon/'
  url 'http://www.cs.arizona.edu/icon/ftp/packages/unix/icon-v950src.tgz'
  sha1 '0e26ba1eef6db81f3b0be942daec82ea51d33718'
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
