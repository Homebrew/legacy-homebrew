require 'formula'

class Pianobar <Formula
  head 'git://github.com/PromyLOPh/pianobar.git', :revison => '8ac0b9532a34383d22b76ff7e274e32780891dc1'
  version '2a1e81927ef6fbf0d9c5'
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
