# Major releases of erlang should typically start out as separate formula in
# Homebrew-versions, and only be merged to master when things like couchdb and
# elixir are compatible.
class Erlang < Formula
  desc "Erlang Programming Language"
  homepage "http://www.erlang.org"

  stable do
    # Download tarball from GitHub; it is served faster than the official tarball.
    url "https://github.com/erlang/otp/archive/OTP-18.0.1.tar.gz"
    sha256 "6d8ad3c1e93d3226d1837e2b55435174d084fa4eb720d98cc3858f44a3f14176"
  end

  head "https://github.com/erlang/otp.git"

  bottle do
    sha256 "7d67c222e2fc1c388e772ddac7add5620b43f4577535a0fbcd6efcf40c98d7ac" => :yosemite
    sha256 "e42c5d38d9b311452adc9b5630cd72476bd7ba1a66463cd6bd370714def4a3e4" => :mavericks
    sha256 "70f73ae014b67eba372560239d188d2ace3dcd72cade495fb3f28db179a0a88c" => :mountain_lion
  end

  resource "man" do
    url "http://www.erlang.org/download/otp_doc_man_18.0.tar.gz"
    sha256 "e44f0ec36ee0683867bc2aa9cc7fbb020d9dfd57338f37b98dcd0771f5b95673"
  end

  resource "html" do
    url "http://www.erlang.org/download/otp_doc_html_18.0.tar.gz"
    sha256 "e5a766f68406f5025f921ec32e8959937189ed1245e24b03a74156a8898b03b2"
  end

  option "without-hipe", "Disable building hipe; fails on various OS X systems"
  option "with-native-libs", "Enable native library compilation"
  option "with-dirty-schedulers", "Enable experimental dirty schedulers"
  option "without-docs", "Do not install documentation"

  deprecated_option "disable-hipe" => "without-hipe"
  deprecated_option "no-docs" => "without-docs"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "unixodbc" if MacOS.version >= :mavericks
  depends_on "fop" => :optional # enables building PDF docs
  depends_on "wxmac" => :recommended # for GUI apps like observer

  fails_with :llvm

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    ENV["FOP"] = "#{HOMEBREW_PREFIX}/bin/fop" if build.with? "fop"

    # Do this if building from a checkout to generate configure
    system "./otp_build autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-kernel-poll
      --enable-threads
      --enable-sctp
      --enable-dynamic-ssl-lib
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --enable-shared-zlib
      --enable-smp-support
    ]

    args << "--enable-darwin-64bit" if MacOS.prefer_64_bit?
    args << "--enable-native-libs" if build.with? "native-libs"
    args << "--enable-dirty-schedulers" if build.with? "dirty-schedulers"
    args << "--enable-wx" if build.with? "wxmac"

    if MacOS.version >= :snow_leopard && MacOS::CLT.installed?
      args << "--with-dynamic-trace=dtrace"
    end

    if build.without? "hipe"
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << "--disable-hipe"
    else
      args << "--enable-hipe"
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Install is not thread-safe; can try to create folder twice and fail
    system "make", "install"

    if build.with? "docs"
      (lib/"erlang").install resource("man").files("man")
      doc.install resource("html")
    end
  end

  def caveats; <<-EOS.undent
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
