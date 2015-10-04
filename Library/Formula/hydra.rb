class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://www.thc.org/thc-hydra/"
  url "https://www.thc.org/releases/hydra-8.1.tar.gz"
  sha256 "e4bc2fd11f97a8d985a38a31785c86d38cc60383e47a8f4a5c436351e5135f19"

  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    sha256 "351f9f45c6350f4fb41c223e2c802b5169889176cf9d5418ce2d3fdda5090d1f" => :el_capitan
    sha1 "1e4448de82ef48e4dd8290b0ebec5fc84690437e" => :yosemite
    sha1 "df94e14ed8bf4553590545da8a9ac1cdcb72fd8d" => :mavericks
    sha1 "16c8738d0cdf625c6144c2c2939d3922e2f3b697" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on :mysql
  depends_on "openssl"
  depends_on "subversion" => :optional
  depends_on "libidn" => :optional
  depends_on "libssh" => :optional
  depends_on "pcre" => :optional
  depends_on "gtk+" => :optional

  def install
    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end
end
