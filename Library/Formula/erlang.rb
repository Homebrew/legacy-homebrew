require 'formula'

class ErlangManuals < Formula
  url 'http://erlang.org/download/otp_doc_man_R15B01.tar.gz'
  md5 'd87412c2a1e6005bbe29dfe642a9ca20'
end

class ErlangHtmls < Formula
  url 'http://erlang.org/download/otp_doc_html_R15B01.tar.gz'
  md5 '7569cae680eecd64e7e5d952be788ee5'
end

class ErlangHeadManuals < Formula
  url 'http://erlang.org/download/otp_doc_man_R15B01.tar.gz'
  md5 'd87412c2a1e6005bbe29dfe642a9ca20'
end

class ErlangHeadHtmls < Formula
  url 'http://erlang.org/download/otp_doc_html_R15B01.tar.gz'
  md5 '7569cae680eecd64e7e5d952be788ee5'
end

class Erlang < Formula
  homepage 'http://www.erlang.org'
  # Download tarball from GitHub; it is served faster than the official tarball.
  url 'https://github.com/erlang/otp/tarball/OTP_R15B01'
  sha1 'efc06b5058605e25bfde41d614a2040f282c2601'

  bottle do
    sha1 'e6f74fdab17d12026fe364d9658b906e58824076' => :mountainlion
    # Lion bottle built on OS X 10.7.2 using Xcode 4.1 using:
    #   brew install erlang --build-bottle --use-gcc
    sha1 '4dfc11ed455f8f866ab4627e8055488fa1954fa4' => :lion
    sha1 '8a4adc813ca906c8e685ff571de03653f316146c' => :snowleopard
  end

  head 'https://github.com/erlang/otp.git', :branch => 'dev'

  # We can't strip the beam executables or any plugins, there isn't really
  # anything else worth stripping and it takes a really, long time to run
  # `file` over everything in lib because there is almost 4000 files (and
  # really erlang guys! what's with that?! Most of them should be in share/erlang!)
  # may as well skip bin too, everything is just shell scripts
  skip_clean ['lib', 'bin']

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
            "--enable-smp-support",
            "--with-dynamic-trace=dtrace"]

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
    system "touch lib/wx/SKIP" if MacOS.snow_leopard?
    ENV.j1 # Parallel builds not working again as of at least R15B01
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
