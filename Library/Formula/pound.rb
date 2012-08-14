require 'formula'

class Pound < Formula
  homepage 'http://www.apsis.ch/pound'
  url 'http://www.apsis.ch/pound/Pound-2.6.tgz'
  md5 '8c913b527332694943c4c67c8f152071'

  depends_on 'pcre'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Manual install to get around group issues
    sbin.install "pound", "poundctl"
    man8.install "pound.8", "poundctl.8"
  end
end
