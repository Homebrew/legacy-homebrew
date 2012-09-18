require 'formula'

class Pound < Formula
  homepage 'http://www.apsis.ch/pound'
  url 'http://www.apsis.ch/pound/Pound-2.6.tgz'
  sha1 '91ba84c6db579b06dc82fceb790e55e344b1dc40'

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
