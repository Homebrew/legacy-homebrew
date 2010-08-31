require 'formula'

class Chicken <Formula
  url 'http://www.call-with-current-continuation.org/chicken-4.4.0.tar.gz'
  homepage 'http://www.call-with-current-continuation.org/'
  md5 '598e7ea036807a67297c3e2bf4a454c4'

  def install
    ENV.deparallelize
    settings = "PREFIX=#{prefix} PLATFORM=macosx"
    settings << " ARCH=x86-64" if snow_leopard_64?
    system "make #{settings}"
    system "make install #{settings}"
  end
end
