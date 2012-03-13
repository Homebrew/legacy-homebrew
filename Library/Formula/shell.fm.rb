require 'formula'

class ShellFm < Formula
  url 'https://github.com/jkramer/shell-fm/tarball/v0.8'
  homepage 'http://nex.scrapping.cc/shell-fm/'
  md5 'ce5c45ead71a299edbff280d4007ad99'
  head 'https://github.com/jkramer/shell-fm.git'

  # homepage says that libao is optional, but it doesn't seem
  # to build without it
  depends_on 'pkg-config' => :build
  depends_on 'libao'
  depends_on 'mad'

  def install
    system "make"
    bin.install 'source/shell-fm'
    man1.install 'manual/shell-fm.1.gz'
  end
end
