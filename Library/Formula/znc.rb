require 'formula'

class Znc < Formula
  url 'http://znc.in/releases/archive/znc-0.098.tar.gz'
  md5 '5667b4acb1f01309d6eded77abac700c'
  homepage 'http://en.znc.in/wiki/ZNC'
  head 'git://github.com/znc/znc.git'

  depends_on 'pkg-config' => :build
  depends_on 'c-ares' => :optional

  skip_clean 'bin/znc'
  skip_clean 'bin/znc-config'
  skip_clean 'bin/znc-buildmod'

  def options
    [['--enable-debug', "Compile ZNC with --enable-debug"]]
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
