require 'formula'

class Znc < Formula
  url 'http://znc.in/releases/archive/znc-0.204.tar.gz'
  md5 '7c7247423fc08b0c5c62759a50a9bca3'
  homepage 'http://wiki.znc.in/ZNC'
  head 'https://github.com/znc/znc.git'

  depends_on 'pkg-config' => :build
  depends_on 'c-ares' => :optional

  skip_clean 'bin/znc'
  skip_clean 'bin/znc-config'
  skip_clean 'bin/znc-buildmod'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def options
    [['--enable-debug', "Compile ZNC with --enable-debug"]]
  end

  def install
    args = ["--prefix=#{prefix}", "--enable-extra"]
    args << "--enable-debug" if ARGV.include? '--enable-debug'

    system "./autogen.sh" if ARGV.build_head?
    system "./configure", *args
    system "make install"
  end
end
