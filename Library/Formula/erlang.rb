require 'formula'

# Major releases of erlang should typically start out as separate formula in
# Homebrew-versions, and only be merged to master when things like couchdb and
# elixir are compatible.
class Erlang < Formula
  homepage 'http://www.erlang.org'

  stable do
    # Download tarball from GitHub; it is served faster than the official tarball.
    url "https://github.com/erlang/otp/archive/OTP-17.3.4.tar.gz"
    sha256 "bb8036c43b1aae12b2940968f2480701e7f431f09d46a0f204d94bf53b0b2b50"
  end

  head 'https://github.com/erlang/otp.git', :branch => 'master'

  bottle do
  end

  resource "man" do
    url "http://www.erlang.org/download/otp_doc_man_17.3.tar.gz"
    sha1 "3f7717186f572bb6431e1a1e5bc6c0f5ffd53171"
  end

  resource "html" do
    url "http://www.erlang.org/download/otp_doc_html_17.3.tar.gz"
    sha1 "fee5762225ef990e8c07aa4baa563a57208b0198"
  end

  option 'disable-hipe', "Disable building hipe; fails on various OS X systems"
  option 'with-native-libs', 'Enable native library compilation'
  option 'with-dirty-schedulers', 'Enable experimental dirty schedulers'
  option 'no-docs', 'Do not install documentation'

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

    ENV["FOP"] = "#{HOMEBREW_PREFIX}/bin/fop" if build.with? 'fop'

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

    if MacOS.version >= :snow_leopard and MacOS::CLT.installed?
      args << "--with-dynamic-trace=dtrace"
    end

    if build.include? 'disable-hipe'
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << '--disable-hipe'
    else
      args << '--enable-hipe'
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Install is not thread-safe; can try to create folder twice and fail
    system "make install"

    unless build.include? 'no-docs'
      (lib/'erlang').install resource('man').files('man')
      doc.install resource('html')
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
