require 'formula'

class Robotfindskitten < Formula
  url 'http://downloads.sourceforge.net/project/rfk/robotfindskitten-POSIX/rfk%20rises%20from%20the%20dead%21%20%20braaaains.../robotfindskitten-1.7320508.406.tar.gz'
  homepage 'http://robotfindskitten.org/'
  md5 '6b9cf314ffee0de52ed85ac5ba11d66b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # This project installs to 'games', but we want it in 'bin' so it symlinks in.
    # Can't find a ./configure switch, so just rename it.
    (prefix+"games").rename bin
  end
end
