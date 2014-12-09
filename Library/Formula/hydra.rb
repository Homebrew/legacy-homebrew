require "formula"

class Hydra < Formula
  homepage "https://www.thc.org/thc-hydra/"
  url "https://www.thc.org/releases/hydra-8.1.tar.gz"
  sha256 "e4bc2fd11f97a8d985a38a31785c86d38cc60383e47a8f4a5c436351e5135f19"

  head "https://github.com/vanhauser-thc/thc-hydra"

  bottle do
    cellar :any
    sha1 "8eef0ef48e07a9b50f51d6b6f62d76be48cd2bb7" => :yosemite
    sha1 "a918878af2ceb50c9ae0cd7193d99c8911fc179b" => :mavericks
    sha1 "57e89de532dc1af0c6fd939357881d9920274597" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on :mysql
  depends_on "openssl"
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
