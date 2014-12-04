require "formula"

class Mawk < Formula
  homepage "http://invisible-island.net/mawk/"
  url "ftp://invisible-island.net/mawk/mawk-1.3.4-20141027.tgz"
  sha1 "a0a54bde0c76a351fa073a6fa10ce912a1260144"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make install"
  end

  test do
    version=`mawk '/version/ { print $2 }' #{prefix}/README`
    assert_equal version, "#{version}"
  end

end
