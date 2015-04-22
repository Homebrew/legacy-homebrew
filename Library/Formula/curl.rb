class Curl < Formula
  homepage "http://curl.haxx.se/"
  url "http://curl.haxx.se/download/curl-7.42.0.tar.bz2"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/cURL/curl-7.42.0.tar.bz2"
  sha256 "32557d68542f5c6cc8437b5b8a945857b4c5c6b6276da909e35b783d1d66d08f"

  bottle do
    cellar :any
    sha256 "43a054056f8c77f6c5586c7206f169018ca7e0855bf193d9a44e2352cc6781b1" => :yosemite
    sha256 "06f71bad05207b3775d537dec3606bfbf3e724ce950138ec06906e3b386381a3" => :mavericks
    sha256 "f75b4c1a50007ed7994b8aa2e5f165bb090981409338e3af6fb7499faec18c01" => :mountain_lion
  end

  keg_only :provided_by_osx

  option "with-libidn", "Build with support for Internationalized Domain Names"
  option "with-rtmpdump", "Build with RTMP support"
  option "with-libssh2", "Build with scp and sftp support"
  option "with-c-ares", "Build with C-Ares async DNS support"
  option "with-gssapi", "Build with GSSAPI/Kerberos authentication support."
  option "with-libmetalink", "Build with libmetalink support."
  option "with-libressl", "Build with LibreSSL instead of Secure Transport or OpenSSL"
  option "with-nghttp2", "Build with HTTP/2 support (requires OpenSSL or LibreSSL)"

  deprecated_option "with-idn" => "with-libidn"
  deprecated_option "with-rtmp" => "with-rtmpdump"
  deprecated_option "with-ssh" => "with-libssh2"
  deprecated_option "with-ares" => "with-c-ares"

  # HTTP/2 support requires OpenSSL 1.0.2+ or LibreSSL 2.1.3+ for ALPN Support
  # which is currently not supported by Secure Transport (DarwinSSL).
  if MacOS.version < :mountain_lion || (build.with?("nghttp2") && build.without?("libressl"))
    depends_on "openssl"
  else
    option "with-openssl", "Build with OpenSSL instead of Secure Transport"
    depends_on "openssl" => :optional
  end

  depends_on "pkg-config" => :build
  depends_on "libidn" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "libssh2" => :optional
  depends_on "c-ares" => :optional
  depends_on "libmetalink" => :optional
  depends_on "libressl" => :optional
  depends_on "nghttp2" => :optional

  def install
    # Throw an error if someone actually tries to rock both SSL choices.
    # Long-term, make this singular-ssl-option-only a requirement.
    if build.with?("libressl") && build.with?("openssl")
      ohai <<-EOS.undent
      --with-openssl and --with-libressl are both specified and
      curl can only use one at a time; proceeding with libressl.
      EOS
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    # cURL has a new firm desire to find ssl with PKG_CONFIG_PATH instead of using
    # "--with-ssl" any more. "when possible, set the PKG_CONFIG_PATH environment
    # variable instead of using this option". Multi-SSL choice breaks w/o using it.
    if build.with? "libressl"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["libressl"].opt_prefix}/lib/pkgconfig"
      args << "--with-ssl=#{Formula["libressl"].opt_prefix}"
      args << "--with-ca-bundle=#{etc}/libressl/cert.pem"
    elsif MacOS.version < :mountain_lion || build.with?("openssl") || build.with?("nghttp2")
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl"].opt_prefix}/lib/pkgconfig"
      args << "--with-ssl=#{Formula["openssl"].opt_prefix}"
      args << "--with-ca-bundle=#{etc}/openssl/cert.pem"
    else
      args << "--with-darwinssl"
    end

    args << (build.with?("libssh2") ? "--with-libssh2" : "--without-libssh2")
    args << (build.with?("libidn") ? "--with-libidn" : "--without-libidn")
    args << (build.with?("libmetalink") ? "--with-libmetalink" : "--without-libmetalink")
    args << (build.with?("gssapi") ? "--with-gssapi" : "--without-gssapi")
    args << (build.with?("rtmpdump") ? "--with-librtmp" : "--without-librtmp")

    if build.with? "c-ares"
      args << "--enable-ares=#{Formula["c-ares"].opt_prefix}"
    else
      args << "--disable-ares"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", stable.url, "-o", filename
    filename.verify_checksum stable.checksum
  end
end
