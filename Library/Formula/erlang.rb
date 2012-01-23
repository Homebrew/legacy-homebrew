require 'formula'

class ErlangManuals < Formula
  url 'http://erlang.org/download/otp_doc_man_R14B04.tar.gz'
  md5 'f31e72518daae4007f595c0b224dd59f'
end

class ErlangHtmls < Formula
  url 'http://erlang.org/download/otp_doc_html_R14B04.tar.gz'
  md5 '2a440aa8c1242dd0c79785d69f0d97ca'
end

class ErlangHeadManuals < Formula
  url 'http://erlang.org/download/otp_doc_man_R14B04.tar.gz'
  md5 'f31e72518daae4007f595c0b224dd59f'
end

class ErlangHeadHtmls < Formula
  url 'http://erlang.org/download/otp_doc_html_R14B04.tar.gz'
  md5 '2a440aa8c1242dd0c79785d69f0d97ca'
end

class Erlang < Formula
  homepage 'http://www.erlang.org'
  # Download tarball from GitHub; it is served faster than the official tarball.
  url 'https://github.com/erlang/otp/tarball/OTP_R14B04'
  md5 'f6cd1347dfb6436b99cc1313011a3d24'
  version 'R14B04'

  bottle 'https://downloads.sf.net/project/machomebrew/Bottles/erlang-R14B04-bottle.tar.gz'
  bottle_sha1 'ad262d3d9600e76b816b74fac32b339c4a25c58f'

  head 'https://github.com/erlang/otp.git', :branch => 'dev'

  # We can't strip the beam executables or any plugins, there isn't really
  # anything else worth stripping and it takes a really, long time to run
  # `file` over everything in lib because there is almost 4000 files (and
  # really erlang guys! what's with that?! Most of them should be in share/erlang!)
  # may as well skip bin too, everything is just shell scripts
  skip_clean ['lib', 'bin']

  def options
    [
      ['--disable-hipe', "Disable building hipe; fails on various OS X systems."],
      ['--halfword', 'Enable halfword emulator (64-bit builds only)'],
      ['--time', '"brew test --time" to include a time-consuming test.'],
      ['--no-docs', 'Do not install documentation.']
    ]
  end

  fails_with_llvm :build => 2334

  def install
    ohai "Compilation may take a very long time; use `brew install -v erlang` to see progress"
    ENV.deparallelize
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

    unless ARGV.include? '--disable-hipe'
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << '--enable-hipe'
    end

    if MacOS.prefer_64_bit?
      args << "--enable-darwin-64bit"
      args << "--enable-halfword-emulator" if ARGV.include? '--halfword' # Does not work with HIPE yet. Added for testing only
    end

    system "./configure", *args
    system "touch lib/wx/SKIP" if MacOS.snow_leopard?
    system "make"
    system "make install"

    unless ARGV.include? '--no-docs'
      manuals = ARGV.build_head? ? ErlangHeadManuals : ErlangManuals
      manuals.new.brew { man.install Dir['man/*'] }

      htmls = ARGV.build_head? ? ErlangHeadHtmls : ErlangHtmls
      htmls.new.brew { doc.install Dir['*'] }
    end
  end

  def test
    `#{bin}/erl -noshell -eval 'crypto:start().' -s init stop`

    # This test takes some time to run, but per bug #120 should finish in
    # "less than 20 minutes". It takes a few minutes on a Mac Pro (2009).
    if ARGV.include? "--time"
      `#{bin}/dialyzer --build_plt -r #{lib}/erlang/lib/kernel-2.14.1/ebin/`
    end
  end
end
