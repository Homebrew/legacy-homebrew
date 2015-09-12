# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063

class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "http://ftpmirror.gnu.org/wget/wget-1.16.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/wget/wget-1.16.3.tar.xz"
  sha256 "67f7b7b0f5c14db633e3b18f53172786c001e153d545cfc85d82759c5c2ffb37"

  bottle do
    sha256 "36e966088b7f94c5a1084e1f5fefeeb6b00aa57053a11fb26c323239851c00e5" => :el_capitan
    sha256 "9202d7ea3d0419921bf3c34d16fe6be1f3c835afd0dbeeb4f97c222e96b00806" => :yosemite
    sha256 "4ba8249466dc7bd1fa4c0cae1b7195e5bd23996e0920e516daa7b262292efe29" => :mavericks
    sha256 "76c509f6d93dbec0207de5ada9830b0988211c3211c465f41ed100226950d8f8" => :mountain_lion
  end

  head do
    url "git://git.savannah.gnu.org/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-iri" => "with-iri"
  deprecated_option "enable-debug" => "with-debug"

  option "with-iri", "Enable iri support"
  option "with-debug", "Build with debug support"

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "libidn" if build.with? "iri"
  depends_on "pcre" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
    ]

    if build.with? "libressl"
      args << "--with-libssl-prefix=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-libssl-prefix=#{Formula["openssl"].opt_prefix}"
    end

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-iri" if build.without? "iri"
    args << "--disable-pcre" if build.without? "pcre"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "-", "https://google.com"
  end
end
