require 'formula'

class Vimpc < Formula
  homepage 'http://sourceforge.net/projects/vimpc/'
  url 'http://downloads.sourceforge.net/project/vimpc/Release%200.05/vimpc-0.05.tar.gz'
  sha1 '7853b901eb3ef3748204e52ac6de973c43fa6ea3'

  head 'https://github.com/richo/vimpc.git'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'pcre++'
  depends_on 'libmpdclient'

  def install
    if build.head?
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
