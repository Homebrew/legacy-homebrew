class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "http://stoken.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.90.tar.gz"
  sha256 "b83d7b95e4ad9b107ab8a5b6c26da0f233001fdfda78d8be76562437d3bd4f7d"
  revision 1

  bottle do
    cellar :any
    sha256 "536418870659b4f96ca4215df1e9fe6d639402881596c7f5a565c7fe83f4015f" => :el_capitan
    sha256 "42152845ecbaec211e89a3fc2d507bf502f48d56ce1269f044687792cc432f1e" => :yosemite
    sha256 "041c46b4fafcf55fe2555b8c88b49cea4c787f77355fbd54fa91acdba9013623" => :mavericks
  end

  depends_on "gtk+3" => :optional
  if build.with? "gtk+3"
    depends_on "gnome-icon-theme"
    depends_on "hicolor-icon-theme"
  end
  depends_on "pkg-config" => :build
  depends_on "nettle"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/stoken", "show", "--random"
  end
end
