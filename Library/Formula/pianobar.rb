require 'formula'

class Pianobar <Formula
  head 'git://github.com/PromyLOPh/pianobar.git', :revison => 'f967ab35735bc3156730bd14c9d501ac0a425051'
  version '2010.10.07'
  homepage 'http://github.com/PromyLOPh/pianobar/'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'

  def install
    ENV.delete "CFLAGS"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
