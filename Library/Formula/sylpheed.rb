class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "http://sylpheed.sraoss.jp/en/"
  url "http://sylpheed.sraoss.jp/sylpheed/v3.5/sylpheed-3.5.0.tar.bz2"
  sha256 "4a0b62d17bca6f1a96ab951ef55a9a67813d87bc1dc3ee55d8ec2c045366a05c"

  bottle do
    sha256 "fced00597f19a4f6d5c1eea145582ba35e6a7885d4de94c234a47021b0ce2939" => :el_capitan
    sha256 "0743231958dd2029e227fda080acbe73d3fe038b3a59ff1826f3ea8290743bb4" => :yosemite
    sha256 "e547604d5b9059de979bcb412820c6ae137975f49b2a247491588b988e73c308" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-updatecheck"
    system "make", "install"
  end

  test do
    system "#{bin}/sylpheed", "--version"
  end
end
