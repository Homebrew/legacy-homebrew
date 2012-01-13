require 'formula'

class Vimpc < Formula
  url 'http://downloads.sourceforge.net/project/vimpc/Release%200.04/vimpc-0.04.tar.gz'
  homepage 'http://sourceforge.net/projects/vimpc/'
  md5 '5ccc7b8fa3cde6f750b12b39c39778a7'

  head 'https://github.com/richoH/vimpc.git'

  depends_on 'pkg-config' => :build
  depends_on 'pcre++'
  depends_on 'libmpdclient'

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
    system "vimpc -v"
  end
end
