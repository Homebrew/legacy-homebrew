require 'formula'

class Kiwi <Formula
  url 'http://github.com/visionmedia/kiwi/zipball/0.2.2'
  homepage 'http://github.com/visionmedia/kiwi'
  md5 '7c5291a42f3cc848a3ae5a29b1028eff'
  version '0.2.2'

  depends_on 'rlwrap' => :recommended

  def install
    inreplace "Makefile", "/usr/local", "#{prefix}"
    bin.mkpath
    system "make install"
  end

  def caveats
    <<-EOS.undent
    By default, installs libraries to:
      ~/.node_libraries
    EOS
  end
end
