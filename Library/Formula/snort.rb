class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.7.0.tar.gz"
  sha256 "9738afea45d20b7f77997cc00055e7dd70f6aea0101209d87efec4bc4eace49b"

  bottle do
    cellar :any
    revision 1
    sha256 "336919a67861f4273ff6b85b725e5dae8e2f9f107f9a3220753df7fbdc370c07" => :yosemite
    sha256 "df0fc95331633b5b7cdac54081ac722ddca7ddf19b51994d7c10549e631bf978" => :mavericks
    sha256 "8cee5d29d41e5d54491871ade0dfdc59caf05151814d58bebaf73e0d32ed4597" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "daq"
  depends_on "libdnet"
  depends_on "pcre"
  depends_on "openssl"

  option "with-debug", "Compile Snort with debug options enabled"

  deprecated_option "enable-debug" => "with-debug"

  def install
    openssl = Formula["openssl"]

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/snort
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-gre
      --enable-mpls
      --enable-targetbased
      --enable-sourcefire
      --with-openssl-includes=#{openssl.opt_include}
      --with-openssl-libraries=#{openssl.opt_lib}
      --enable-active-response
      --enable-normalizer
      --enable-reload
      --enable-react
      --enable-flexresp3
    ]

    if build.with? "debug"
      args << "--enable-debug"
      args << "--enable-debug-msgs"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make", "install"

    rm Dir[buildpath/"etc/Makefile*"]
    (etc+"snort").install Dir[buildpath/"etc/*"]
  end

  def caveats; <<-EOS.undent
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod 644 /dev/bpf*
    or you could create a startup item to do this for you.
    EOS
  end

  test do
    system bin/"snort", "-V"
  end
end
