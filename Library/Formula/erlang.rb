require 'formula'

class ErlangManuals <Formula
  url 'http://www.erlang.org/download/otp_doc_man_R13B04.tar.gz'
  md5 '681aaef70affc64743f4e8c0675034af'
end

class Erlang <Formula
  # Download from  GitHub repo, which is much faster than using the official tarball
  url "git://github.com/erlang/otp.git"
  homepage 'http://www.erlang.org'
  version 'R13B04'
  @specs = {:tag => "OTP_R13B04"}

  # We can't strip the beam executables or any plugins, there isn't really
  # anything else worth stripping and it takes a really, long time to run
  # `file` over everything in lib because there is almost 4000 files (and
  # really erlang guys! what's with that?! Most of them should be in share/erlang!)
  # may as well skip bin too, everything is just shell scripts
  skip_clean ['lib', 'bin']

  def install
    ENV.deparallelize
    fails_with_llvm "see http://github.com/mxcl/homebrew/issues/issue/120"

    # If building from GitHub, this step is required (but not for tarball downloads.)
    system "./otp_build autoconf" if File.exist? "otp_build"

    config_flags = ["--disable-debug",
                    "--prefix=#{prefix}",
                    "--enable-kernel-poll",
                    "--enable-threads",
                    "--enable-dynamic-ssl-lib",
                    "--enable-smp-support"]

    unless ARGV.include? '--disable-hipe'
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      config_flags << '--enable-hipe'
    end

    if Hardware.is_64_bit? and MACOS_VERSION >= 10.6
      config_flags << "--enable-darwin-64bit"
    end

    system "./configure", *config_flags
    system "touch lib/wx/SKIP" if MACOS_VERSION >= 10.6
    system "make"
    system "make install"

    ErlangManuals.new.brew { man.install Dir['man/*'] }

    # See: http://github.com/mxcl/homebrew/issues/issue/1317
    (lib+"erlang/lib/tools-2.6.5.1/emacs").install "lib/tools/emacs/erlang-skels.el"
  end

  def test
    `erl -noshell -eval 'crypto:start().' -s init stop`
  end
end
