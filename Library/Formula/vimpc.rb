require 'formula'

class Vimpc < Formula
  homepage 'http://sourceforge.net/projects/vimpc/'
  url 'http://downloads.sourceforge.net/project/vimpc/Release%200.08.1/vimpc-0.08.1.tar.gz'
  sha1 '2620e7148b4cac7472952690e5b5df199188d3c8'

  head 'https://github.com/boysetsfrog/vimpc.git'

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
