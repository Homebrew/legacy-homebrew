require 'formula'

class Libopkele < Formula
  homepage 'http://kin.klever.net/libopkele/'

  stable do
    url "http://kin.klever.net/dist/libopkele-2.0.4.tar.bz2"
    sha1 "0c403d118efe6b4ee4830914448078c0ee967757"

    patch do
      url "https://github.com/hacker/libopkele/commit/9ff6244998b0d41e71f7cc7351403ad590e990e4.diff"
      sha1 "dd86d5a493a54f57ac3bc842878cba5c6608aa7e"
    end
  end

  option 'with-docs', 'Also install library documentation'

  head do
    url 'https://github.com/hacker/libopkele.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'doxygen' => :build if build.with? 'docs'

  depends_on 'pkg-config' => :build

  def install
    system "./autogen.bash" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    if build.with? 'docs'
      system "make", "dox"
      doc.install Dir['doxydox/html']
    end
  end
end
