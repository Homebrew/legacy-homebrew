class Libbinio < Formula
  desc "Binary I/O stream class library"
  homepage "http://libbinio.sf.net"
  url "https://downloads.sourceforge.net/project/libbinio/libbinio/1.4/libbinio-1.4.tar.bz2"
  sha256 "4a32d3154517510a3fe4f2dc95e378dcc818a4a921fc0cb992bdc0d416a77e75"

  bottle do
    cellar :any
    sha1 "68f94ad8d5fb81408ad97faf1b562384a25b643c" => :yosemite
    sha1 "6d4f265305ae6c4b44c4fd299aca20ceba8f07be" => :mavericks
    sha1 "e59427d1947751afe72244b5387e662dfa91f899" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
