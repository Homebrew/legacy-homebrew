require 'formula'

class Pound <Formula
  url 'http://www.apsis.ch/pound/Pound-2.5.tgz'
  homepage 'http://www.apsis.ch/pound'
  md5 '8a39f5902094619afcda7d12d9d8342c'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # Manual install to get around group issues
    sbin.install ["pound", "poundctl"]
    man8.install ["pound.8", "poundctl.8"]
  end
end
