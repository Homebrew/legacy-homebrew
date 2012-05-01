require 'formula'

class Libcdio < Formula
  url 'http://ftpmirror.gnu.org/libcdio/libcdio-0.82.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libcdio/libcdio-0.82.tar.gz'
  md5 '1c29b18e01ab2b966162bc727bf3c360'
  homepage 'http://www.gnu.org/software/libcdio/'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    On Snow Leopard 10.6.5 libcdio 0.82 doesn't build with the OSX drivers.
    See: http://savannah.gnu.org/bugs/?30019

    Attempting to force Darwin detection will cause IOKit build errors.
    EOS
  end
end
