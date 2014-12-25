class AprUtil < Formula
  homepage "https://apr.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.5.4.tar.bz2"
  sha1 "b00038b5081472ed094ced28bcbf2b5bb56c589d"

  keg_only :provided_by_osx, "Apple's CLT package contains apr."

  depends_on "apr"
  depends_on "openssl"
  depends_on "postgresql" => :optional

  def install
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
