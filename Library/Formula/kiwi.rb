require 'formula'

class Kiwi <Formula
  url 'http://github.com/visionmedia/kiwi/tarball/0.3.0'
  homepage 'http://github.com/visionmedia/kiwi'
  md5 '409d15a796677eccd8d1f038d6c86267'

  depends_on 'rlwrap' => :recommended

  def install
    inreplace "Makefile", "/usr/local", "#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    By default, installs libraries to:
      ~/.node_libraries
    EOS
  end
end
