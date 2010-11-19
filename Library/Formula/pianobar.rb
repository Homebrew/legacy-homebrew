require 'formula'

class Pianobar <Formula
  url 'https://github.com/PromyLOPh/pianobar/tarball/2010.11.06'
  version '2010.11.06'
  homepage 'https://github.com/PromyLOPh/pianobar/'
  md5 '7a43df6abed644a35a43274eb350eb33'

  head 'git://github.com/PromyLOPh/pianobar.git'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'

  skip_clean :bin

  def install
    ENV.delete "CFLAGS"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
