require 'formula'

class Znc < Formula
  homepage 'http://wiki.znc.in/ZNC'
  url 'http://znc.in/releases/archive/znc-0.206.tar.gz'
  sha1 'c5fe2575ef29187d2de5d08a08e17458c0ce54b9'

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
