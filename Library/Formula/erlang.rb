require 'formula'

class ErlangManuals < Formula
  url 'http://erlang.org/download/otp_doc_man_R16B01.tar.gz'
  sha1 '57ef01620386108db83ef13921313e600d351d44'
end

class ErlangHtmls < Formula
  url 'http://erlang.org/download/otp_doc_html_R16B01.tar.gz'
  sha1 '6741e15e0b3e58736987e38fb8803084078ff99f'
end

class ErlangHeadManuals < Formula
  url 'http://erlang.org/download/otp_doc_man_R16B01.tar.gz'
  sha1 '57ef01620386108db83ef13921313e600d351d44'
end

class ErlangHeadHtmls < Formula
  url 'http://erlang.org/download/otp_doc_html_R16B01.tar.gz'
  sha1 '6741e15e0b3e58736987e38fb8803084078ff99f'
end

# Major releases of erlang should typically start out as separate formula in
# Homebrew-versions, and only be merged to master when things like couchdb and
# elixir are compatible.
class Erlang < Formula
  homepage 'http://www.erlang.org'
  # Download tarball from GitHub; it is served faster than the official tarball.
  url 'https://github.com/erlang/otp/archive/OTP_R16B01.tar.gz'
  sha1 'ddbff080ee39c50b86b847514c641f0a9aab0333'

  head 'https://github.com/erlang/otp.git', :branch => 'master'

  bottle do
    sha1 'febb0a5d56258dabd3ccdca22cc3eaa60b16fbf1' => :mountain_lion
    sha1 '2d1456b7e28942d08f78952993d31219206bc08a' => :lion
    sha1 '222b389b09cf290ea07a5600d94c08fa7a1fcc01' => :snow_leopard
  end

  depends_on :automake
  depends_on :libtool
  depends_on 'unixodbc' if MacOS.version >= :mavericks
  depends_on 'fop' => :optional # enables building PDF docs

  fails_with :llvm do
    build 2334
  end

  option 'disable-hipe', "Disable building hipe; fails on various OS X systems"
  option 'halfword', 'Enable halfword emulator (64-bit builds only)'
  option 'time', '`brew test --time` to include a time-consuming test'
  option 'no-docs', 'Do not install documentation'

  def install
    ohai "Compilation takes a long time; use `brew install -v erlang` to see progress" unless ARGV.verbose?

    if ENV.compiler == :llvm
      # Don't use optimizations. Fixes build on Lion/Xcode 4.2
      ENV.remove_from_cflags /-O./
      ENV.append_to_cflags '-O0'
    end
    ENV.append "FOP", "#{HOMEBREW_PREFIX}/bin/fop" if build.with? 'fop'

    # Do this if building from a checkout to generate configure
    system "./otp_build autoconf" if File.exist? "otp_build"

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--enable-kernel-poll",
            "--enable-threads",
            "--enable-dynamic-ssl-lib",
            "--enable-shared-zlib",
            "--enable-smp-support"]

    args << "--with-dynamic-trace=dtrace" unless MacOS.version <= :leopard or not MacOS::CLT.installed?

    unless build.include? 'disable-hipe'
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << '--enable-hipe'
    end

    if MacOS.prefer_64_bit?
      args << "--enable-darwin-64bit"
      args << "--enable-halfword-emulator" if build.include? 'halfword' # Does not work with HIPE yet. Added for testing only
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Install is not thread-safe; can try to create folder twice and fail
    system "make install"

    unless build.include? 'no-docs'
      manuals = build.head? ? ErlangHeadManuals : ErlangManuals
      manuals.new.brew { (lib/'erlang').install 'man' }
      htmls = build.head? ? ErlangHeadHtmls : ErlangHtmls
      htmls.new.brew { doc.install Dir['*'] }
    end
  end

  def caveats; <<-EOS.undent
    Man pages can be found in:
      #{opt_prefix}/lib/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  def test
    `#{bin}/erl -noshell -eval 'crypto:start().' -s init stop`

    # This test takes some time to run, but per bug #120 should finish in
    # "less than 20 minutes". It takes about 20 seconds on a Mac Pro (2009).
    if build.include?("time") && !build.head?
      `#{bin}/dialyzer --build_plt -r #{lib}/erlang/lib/kernel-2.16.2/ebin/`
    end
  end
end
