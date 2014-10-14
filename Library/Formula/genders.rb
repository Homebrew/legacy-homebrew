require 'formula'

class Genders < Formula
  homepage 'https://computing.llnl.gov/linux/genders.html'
  url 'https://downloads.sourceforge.net/project/genders/genders/1.20-1/genders-1.20.tar.gz'
  sha1 '3a1f3f7897c5443edb4d06bd8093b505078454e8'

  option "with-non-shortened-hostnames", "Allow non shortened hostnames that can include dots e.g. www.google.com"

  def install
    args = ["--prefix=#{prefix}"]

    args << "--with-non-shortened-hostnames" if build.with? "non-shortened-hostnames"

    system "./configure", *args
    system "make install"
  end
end
