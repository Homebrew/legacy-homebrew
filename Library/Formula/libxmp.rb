class Libxmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.6/libxmp-4.3.6.tar.gz"
  sha256 "9894456dd3a8cea9b77de084c29f7cbb6ec16fd4d0005389913e8b205c02b750"

  bottle do
    cellar :any
    sha256 "03e06b3182491c292cee3efc6b1b5718d1874c5233f4ccf9c4ebc4cdb2fdf9a6" => :yosemite
    sha256 "208465d33f34a909397aabbe88139e952bebfeda428f1c79819dfb50f5832dde" => :mavericks
    sha256 "615b556b2c0cb26f624c483db529a29add9cfe44ec168a562d90705a09af9d7d" => :mountain_lion
  end

  head do
    url "git://git.code.sf.net/p/xmp/libxmp"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
