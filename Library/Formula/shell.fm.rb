require 'formula'

class ShellFm < Formula
  url 'https://github.com/jkramer/shell-fm/tarball/v0.8'
  homepage 'http://nex.scrapping.cc/shell-fm/'
  sha1 'ad35391489a4c5b216740a543f6cb46285f556c7'
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
