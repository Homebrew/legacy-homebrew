class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.37.tgz"
  sha256 "fa999413651b3bd994547a10ffe3127b4a85a88b1b9a253f2de798888718dbfa"

  bottle do
    cellar :any
    sha256 "40965861e708196ec3c18f9a99943f75a54dac2494c88aed96b3df70cd46d4fa" => :el_capitan
    sha256 "4e256b38d10e905ece1c874a5655612f2f2cc8e7911bfe1d72b07ea2e209244a" => :yosemite
    sha256 "0c8a97e409b389b5e696330123a1f185ebf17c91728274634a25dc7adfa72866" => :mavericks
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "openssl"
  depends_on "xz" => :optional

  def install
    system "autoreconf", "-iv" if build.head?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bash-completion-dir=#{bash_completion}
    ]
    args << "--without-lzma" << "--without-lzmadec" if build.without? "xz"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"tarsnap", "-c", "--dry-run", testpath
  end
end
