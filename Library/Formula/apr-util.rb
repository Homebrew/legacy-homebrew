class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.5.4.tar.bz2"
  sha256 "a6cf327189ca0df2fb9d5633d7326c460fe2b61684745fd7963e79a6dd0dc82e"
  revision 1

  bottle do
    sha256 "f76d6d8ac0152f599ad59d2a4b0a8683741889bad402409c4ca2c18330c6b183" => :el_capitan
    sha256 "6b043e4bf051fce17991f3cafb4ce7d235bf52e01b76e447b5a286f85a69cde9" => :yosemite
    sha256 "aff874c3e72a5ec31b75c066d327771bc84b0a31fedc2243e4e21a56dee78eae" => :mavericks
    sha256 "76f24ef98aebf89eb0b3c7d7fdc31f8074120c39708d8a513575e956fe50fc07" => :mountain_lion
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr."

  option :universal

  depends_on "apr"
  depends_on "openssl"
  depends_on "postgresql" => :optional

  def install
    ENV.universal_binary if build.universal?

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    args = %W[
      --prefix=#{libexec}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-pgsql=#{Formula["postgresql"].opt_prefix}" if build.with? "postgresql"

    system "./configure", *args
    system "make"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/apu-1-config", "--link-libtool", "--libs"
  end
end
