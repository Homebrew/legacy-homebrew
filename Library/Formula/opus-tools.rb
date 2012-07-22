require 'formula'

class OpusTools < Formula
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-tools-0.1.3.tar.gz'
  sha1 '82f9f2cbabfbfac9bea4354a043a0fcaf2e03a47'

  head 'https://git.xiph.org/opus-tools.git'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'opus'
  depends_on 'libogg'

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
