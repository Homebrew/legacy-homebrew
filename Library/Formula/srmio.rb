require 'formula'

class Srmio < Formula
  homepage 'http://www.zuto.de/project/srmio/'
  url 'http://www.zuto.de/project/files/srmio/srmio-0.1.1~git1.tar.gz'
  sha1 '0db685d6046fca38ad64df05840d01b5f3b27499'
  version '0.1.1~git1'

  head do
    url 'https://github.com/rclasen/srmio.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    if build.head?
       system "chmod u+x genautomake.sh"
      system "./genautomake.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/srmcmd", "--version"
  end
end
