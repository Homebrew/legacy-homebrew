require 'formula'

class Znc < Formula
  url 'http://znc.in/releases/archive/znc-0.202.tar.gz'
  md5 '3c6ff4620e139e3d9745cd53111bab20'
  homepage 'http://en.znc.in/wiki/ZNC'
  head 'https://github.com/znc/znc.git'

  depends_on 'pkg-config' => :build
  depends_on 'c-ares' => :optional

  skip_clean 'bin/znc'
  skip_clean 'bin/znc-config'
  skip_clean 'bin/znc-buildmod'

  def options
    [['--enable-debug', "Compile ZNC with --enable-debug"]]
  end

  def patches
    # Pass AF_UNSPEC to ares when the socket address says so. Ares only attempts
    # a A lookup after a failed AAAA lookup if AF_UNSPEC was specified in the
    # original request.
    "https://raw.github.com/gist/1380715/6af4fe00a2c34f733443e44768869278a2223294/znc-0.202-ipv6-fix"
  end

  def install
    if ARGV.build_head?
      ENV['ACLOCAL_FLAGS'] = "--acdir=#{HOMEBREW_PREFIX}/share/aclocal"
      system "./autogen.sh"
    end

    args = ["--prefix=#{prefix}", "--enable-extra"]
    args << "--enable-debug" if ARGV.include? '--enable-debug'
    system "./configure", *args
    system "make install"
  end
end
