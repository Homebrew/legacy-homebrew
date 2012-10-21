require 'formula'

class Vimpc < Formula
  homepage 'http://sourceforge.net/projects/vimpc/'
  url 'http://downloads.sourceforge.net/project/vimpc/Release%200.06.1/vimpc-0.06.1.tar.gz'
  sha1 '72c13e3a2fd10b3089fbd6d47509838fd3c3b9e4'

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
