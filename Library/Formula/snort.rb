class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.7.6.tar.gz"
  sha256 "842e8575e26d919a9e74b9ad0c10d1098f7b5ff2189a8422eb51a9a5b6ebbf63"

  bottle do
    cellar :any
    sha256 "500a6e7527ccd71d95cad8dc6fa2ee4c09ea516c7c866357efecda0dca70389f" => :yosemite
    sha256 "a9a9f2afbe4ebcad4814da730399510ca68c6eed201ca71e17069cc97ce6092c" => :mavericks
    sha256 "2b4871dcf9ac94c842458fcf190ee35390ecc49be2c077cce1c074b3ebc306fb" => :mountain_lion
  end

  option "with-debug", "Compile Snort with debug options enabled"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "daq"
  depends_on "libdnet"
  depends_on "pcre"
  depends_on "openssl"

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
    (etc/"snort").install Dir[buildpath/"etc/*"]
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
