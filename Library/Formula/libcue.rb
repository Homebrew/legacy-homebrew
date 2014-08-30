require 'formula'

class Libcue < Formula
  homepage 'http://sourceforge.net/projects/libcue/'
  url 'https://downloads.sourceforge.net/project/libcue/libcue/1.4.0/libcue-1.4.0.tar.bz2'
  sha1 '3fd31f2da7c0e3967d5f56363f3051a85a8fd50d'

  bottle do
    cellar :any
    sha1 "f982539188f19d20ef527109eb7faa022f477e84" => :mavericks
    sha1 "4e7b91e570acf96f784aea7db8a810d31f3a99d2" => :mountain_lion
    sha1 "bbc375fb8ba03e5353d1481972f5b54ac9eddcac" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
