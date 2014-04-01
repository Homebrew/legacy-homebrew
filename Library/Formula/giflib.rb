require 'formula'

class Giflib < Formula
  homepage 'http://giflib.sourceforge.net/'
  # 4.2.0 has breaking API changes; don't update until
  # things in $(brew uses giflib) are compatible
  url 'https://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.1.6/giflib-4.1.6.tar.bz2'
  sha1 '22680f604ec92065f04caf00b1c180ba74fb8562'

  bottle do
    cellar :any
    sha1 "2209a7375d900a30fedb891bab76d083e2527bcd" => :mavericks
    sha1 "ff9967bdafa5a99db65a62f314f6ea991a0c57d0" => :mountain_lion
    sha1 "59942fcaeba8bb7a9ca20fc8a450b92cda28a1b4" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
