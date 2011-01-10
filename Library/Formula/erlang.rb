require 'formula'

class ErlangManuals <Formula
  url 'http://erlang.org/download/otp_doc_man_R14B01.tar.gz'
  md5 '55376d3b1994d083cd21c9d849517c6c'
end

class ErlangHeadManuals <Formula
  url 'http://erlang.org/download/otp_doc_man_R14B01.tar.gz'
  md5 '55376d3b1994d083cd21c9d849517c6c'
end

class Erlang <Formula
  # Download from GitHub. Much faster than official tarball.
  url "git://github.com/erlang/otp.git", :tag => "OTP_R14B01"
  version 'R14B01'
  homepage 'http://www.erlang.org'

  head "git://github.com/erlang/otp.git", :branch => "dev"

  # We can't strip the beam executables or any plugins, there isn't really
  # anything else worth stripping and it takes a really, long time to run
  # `file` over everything in lib because there is almost 4000 files (and
  # really erlang guys! what's with that?! Most of them should be in share/erlang!)
  # may as well skip bin too, everything is just shell scripts
  skip_clean ['lib', 'bin']

  def options
    [
      ['--disable-hipe', "Disable building hipe; fails on various OS X systems."],
      ['--time', '"brew test --time" to include a time-consuming test.']
    ]
  end

  def install
    ENV.deparallelize
    fails_with_llvm "See https://github.com/mxcl/homebrew/issues/issue/120", :build => 2326

    # If building from GitHub, this step is required (but not for tarball downloads.)
    system "./otp_build autoconf" if File.exist? "otp_build"

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--enable-kernel-poll",
            "--enable-threads",
            "--enable-dynamic-ssl-lib",
            "--enable-smp-support"]

    unless ARGV.include? '--disable-hipe'
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << '--enable-hipe'
    end

    args << "--enable-darwin-64bit" if snow_leopard_64?

    system "./configure", *args
    system "touch lib/wx/SKIP" if MACOS_VERSION >= 10.6
    system "make"
    system "make install"

    manuals = ARGV.build_head? ? ErlangHeadManuals : ErlangManuals
    manuals.new.brew { man.install Dir['man/*'] }
  end

  def test
    `erl -noshell -eval 'crypto:start().' -s init stop`

    # This test takes some time to run, but per bug #120 should finish in
    # "less than 20 minutes". It takes a few minutes on a Mac Pro (2009).
    if ARGV.include? "--time"
      `dialyzer --build_plt -r #{lib}/erlang/lib/kernel-2.14.1/ebin/`
    end
  end
end
