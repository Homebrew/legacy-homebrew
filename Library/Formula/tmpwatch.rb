require 'formula'

class Tmpwatch < Formula
  homepage 'https://fedorahosted.org/tmpwatch/'
  url 'https://fedorahosted.org/releases/t/m/tmpwatch/tmpwatch-2.11.tar.bz2'
  sha1 'c578dd98e5ea64ad987a95ae55926685a0df0659'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
