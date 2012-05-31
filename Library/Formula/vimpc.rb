require 'formula'

class Vimpc < Formula
  homepage 'http://sourceforge.net/projects/vimpc/'
  url 'http://downloads.sourceforge.net/project/vimpc/Release%200.05/vimpc-0.05.tar.gz'
  md5 'f96cdc10827ddfbb53318e9ab4bab93b'

  head 'https://github.com/richo/vimpc.git'

  depends_on 'pkg-config' => :build
  depends_on 'pcre++'
  depends_on 'libmpdclient'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if ARGV.build_head?
      ENV['ACLOCAL_FLAGS'] = "-I #{HOMEBREW_PREFIX}/share/aclocal"
      system "./autogen.sh"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/vimpc", "-v"
  end
end
