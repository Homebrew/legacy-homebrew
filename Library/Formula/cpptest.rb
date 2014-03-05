require 'formula'

class Cpptest < Formula
  homepage 'http://cpptest.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-1.1.2/cpptest-1.1.2.tar.gz'
  sha1 'c8e69ca98f9b39016c94f1f78659f412ee825049'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
