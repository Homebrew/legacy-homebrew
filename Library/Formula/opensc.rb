require "formula"

class Opensc < Formula
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://downloads.sourceforge.net/project/opensc/OpenSC/opensc-0.14.0/opensc-0.14.0.tar.gz"
  sha1 "4a898e351b0a6d2a5d81576daa7ebed45baf9138"
  revision 1

  bottle do
    sha1 "82b08c2bd2b58b7080797a441f8c641cbb101064" => :mavericks
    sha1 "b5107cad1a7b5c7808d8b93f497bfe64127fcbce" => :mountain_lion
    sha1 "26bc12047a4ca119fd37ff76ea4055226d88dc34" => :lion
  end

  head do
    url "https://github.com/OpenSC/OpenSC.git"

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option "with-man-pages", "Build manual pages"

  depends_on "docbook-xsl" if build.with? "man-pages"
  depends_on "openssl"

  def install
    args = []

    if build.with? "man-pages"
      args << "--with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end

    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sm",
                          "--enable-openssl",
                          "--enable-pcsc",
                          *args

    system "make", "install"
  end

  test do
    system "#{bin}/opensc-tool", "-i"
  end
end
