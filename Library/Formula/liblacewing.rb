class Liblacewing < Formula
  desc "Cross-platform, high-level C/C++ networking library"
  homepage "http://lacewing-project.org/"
  head "https://github.com/udp/lacewing.git"
  url "https://github.com/udp/lacewing/archive/0.5.4.tar.gz"
  sha256 "c24370f82a05ddadffbc6e79aaef4a307de926e9e4def18fb2775d48e4804f5c"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha1 "9b3c6627a900002583cd2d179997f507c23e2967" => :yosemite
    sha1 "13c32999ea5cdb9e5c231cd3854d35ebb5bb82d2" => :mavericks
    sha1 "dd1d9ee994fe2a4114063a382712c341591da3f5" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    # https://github.com/udp/lacewing/issues/104
    mv "#{lib}/liblacewing.dylib.0.5", "#{lib}/liblacewing.0.5.dylib"
  end
end
