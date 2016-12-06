require 'formula'

class Redstore < Formula
  homepage 'http://www.aelius.com/njh/'
  url 'http://www.aelius.com/njh/redstore/redstore-0.5.4.tar.gz'
  sha1 '6de3eb072ea89cdc0d5a9764b5570c87ca01d5fa'

  depends_on 'pkg-config' => :build
  depends_on 'redland'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
