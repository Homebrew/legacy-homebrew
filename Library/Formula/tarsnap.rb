class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.37.tgz"
  sha256 "fa999413651b3bd994547a10ffe3127b4a85a88b1b9a253f2de798888718dbfa"

  bottle do
    cellar :any
    sha256 "939f0d1e0d78974b3253175ea0c4f01c2604a8c6345d89fd691c95e0d8b3e716" => :yosemite
    sha256 "21b78154d96292c8dfb7ebed0d2404d6e7d15859a6341544fd080c50b152a118" => :mavericks
    sha256 "cbf519589c3e09bfc18c3d8d39db958c52c014dc1fca8b1ad5ab2fa17fb9ae0a" => :mountain_lion
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
