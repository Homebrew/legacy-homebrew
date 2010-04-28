require 'formula'

class ShellFm <Formula
  url 'http://github.com/jkramer/shell-fm/tarball/v0.7'
  homepage 'http://nex.scrapping.cc/shell-fm/'
  md5 'b18615ca869c88566993851319635a2c'

  aka 'shell-fm'

  # homepage says that libao is optional, but it doesn't seem
  # to build without it…
  depends_on 'pkg-config'
  depends_on 'libao'
  depends_on 'mad'

  def install
    system "make"
    bin.install 'source/shell-fm'
    man1.install 'manual/shell-fm.1.gz'
  end
end
