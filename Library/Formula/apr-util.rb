class AprUtil < Formula
  homepage "https://apr.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.5.4.tar.bz2"
  sha1 "b00038b5081472ed094ced28bcbf2b5bb56c589d"

  bottle do
    sha1 "c0807fd64a46a6c0d1dfd3e3a5cfff3812356251" => :yosemite
    sha1 "c3d8fa3f0b6d5c4923ab8bda382614d81d412c0b" => :mavericks
    sha1 "4af28090bda520eabde6dfc039ea7d20da4f3db6" => :mountain_lion
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
