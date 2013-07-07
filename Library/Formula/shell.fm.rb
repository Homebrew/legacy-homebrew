require 'formula'

class ShellFm < Formula
  url 'https://github.com/jkramer/shell-fm/archive/v0.8.tar.gz'
  homepage 'http://nex.scrapping.cc/shell-fm/'
  sha1 '13d8c1f6ce9c24a99d0c3ee6a3ce138835d504a1'
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
