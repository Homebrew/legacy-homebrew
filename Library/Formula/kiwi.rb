require 'formula'

class Kiwi <Formula
  url 'http://github.com/visionmedia/kiwi/tarball/0.2.3'
  homepage 'http://github.com/visionmedia/kiwi'
  md5 'a6ad119593d5817730f57f5aa53e73cf'

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
