require 'formula'

class ErlangManuals <Formula
  url 'http://www.erlang.org/download/otp_doc_man_R13B04.tar.gz'
  md5 '681aaef70affc64743f4e8c0675034af'
end

class Erlang <Formula
  version 'R13B04'
  url "http://erlang.org/download/otp_src_#{version}.tar.gz"
  md5 'ca6da4921e438891967900aa6a084341'

  # Use `brew install erlang --HEAD` to download from (faster than tarball) GitHub repo.
  head "git://github.com/erlang/otp.git", :tag => "OTP_R13B04"
  homepage 'http://www.erlang.org'

  # we can't strip the beam executables or any plugins
  # there isn't really anything else worth stripping and it takes a really
  # long time to run `file` over everything in lib because there is almost
  # 4000 files (and really erlang guys! what's with that?! Most of them should
  # be in share/erlang!)
  skip_clean 'lib'
  # may as well skip this too, everything is just shell scripts
  skip_clean 'bin'

  def install
    ENV.deparallelize
    fails_with_llvm "see http://github.com/mxcl/homebrew/issues/#issue/120"

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
  end

  def test
    "erl -noshell -eval 'crypto:start().' -s init stop"
  end
end
