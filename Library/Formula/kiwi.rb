require 'formula'

class Kiwi < Formula
  url 'https://github.com/visionmedia/kiwi/tarball/0.3.1'
  homepage 'https://github.com/visionmedia/kiwi'
  md5 '2ae655e5dc3861f3852d7592b7ab9533'

  depends_on 'rlwrap' => :recommended

  def install
    inreplace "Makefile", "/usr/local", prefix
    system "make install"
  end

  def caveats
    <<-EOS.undent
    By default, installs libraries to:
      ~/.node_libraries
    EOS
  end
end
