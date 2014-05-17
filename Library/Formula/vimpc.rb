require 'formula'

class Vimpc < Formula
  homepage 'http://sourceforge.net/projects/vimpc/'
  url 'https://downloads.sourceforge.net/project/vimpc/Release%200.08.1/vimpc-0.08.1.tar.gz'
  sha1 '2620e7148b4cac7472952690e5b5df199188d3c8'

  head do
    url 'https://github.com/boysetsfrog/vimpc.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'
  depends_on 'pcre'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/vimpc", "-v"
  end
end
