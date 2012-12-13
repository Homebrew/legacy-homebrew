require 'formula'

class ErlangManuals < Formula
  url 'http://erlang.org/download/otp_doc_man_R15B03.tar.gz'
  sha1 'a0ea6cc389b208c2a75ffb0027e143afc33c40b3'
end

class ErlangHtmls < Formula
  url 'http://erlang.org/download/otp_doc_html_R15B03.tar.gz'
  sha1 'ff866b07d217f48ee6253fdbed956be5ebf3cb9d'
end

class ErlangHeadManuals < Formula
  url 'http://erlang.org/download/otp_doc_man_R15B03.tar.gz'
  sha1 'a0ea6cc389b208c2a75ffb0027e143afc33c40b3'
end

class ErlangHeadHtmls < Formula
  url 'http://erlang.org/download/otp_doc_html_R15B03.tar.gz'
  sha1 'ff866b07d217f48ee6253fdbed956be5ebf3cb9d'
end

class Erlang < Formula
  homepage 'http://www.erlang.org'
  # Download tarball from GitHub; it is served faster than the official tarball.
  url 'https://github.com/erlang/otp/tarball/OTP_R15B03'
  sha1 '2497d3a0d04b55cae83f81974286440648993309'

  head 'https://github.com/erlang/otp.git', :branch => 'dev'

  bottle do
    sha1 'f158557be51ae5eaa1570c3e318e89967c484825' => :mountainlion
    sha1 '315cd9d75fca13b0c41b27c61ed86bb1d9418ee1' => :lion
    sha1 '613b705ad2acdd2f16f7b4df6b171521d0ba4d29' => :snowleopard
  end

  # remove the autoreconf if possible
  depends_on :automake
  depends_on :libtool

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

    # Do this if building from a checkout to generate configure
    system "./otp_build autoconf" if File.exist? "otp_build"

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--enable-kernel-poll",
            "--enable-threads",
            "--enable-dynamic-ssl-lib",
            "--enable-shared-zlib",
            "--enable-smp-support"]

    args << "--with-dynamic-trace=dtrace" unless MacOS.version == :leopard

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
    touch 'lib/wx/SKIP' if MacOS.version >= :snow_leopard
    system "make"
    system "make install"

    unless build.include? 'no-docs'
      manuals = build.head? ? ErlangHeadManuals : ErlangManuals
      manuals.new.brew { man.install Dir['man/*'] }

      htmls = build.head? ? ErlangHeadHtmls : ErlangHtmls
      htmls.new.brew { doc.install Dir['*'] }
    end
  end

  def test
    `#{bin}/erl -noshell -eval 'crypto:start().' -s init stop`

    # This test takes some time to run, but per bug #120 should finish in
    # "less than 20 minutes". It takes a few minutes on a Mac Pro (2009).
    if build.include? "time"
      `#{bin}/dialyzer --build_plt -r #{lib}/erlang/lib/kernel-2.15/ebin/`
    end
  end
end
