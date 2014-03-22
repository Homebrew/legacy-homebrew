require 'formula'

class Libopkele < Formula
  homepage 'http://kin.klever.net/libopkele/'

  stable do
    url "http://kin.klever.net/dist/libopkele-2.0.4.tar.bz2"
    sha1 "0c403d118efe6b4ee4830914448078c0ee967757"

    patch do
      url "https://github.com/hacker/libopkele/commit/9ff6244998b0d41e71f7cc7351403ad590e990e4.patch"
      sha1 "f799213b0e65d42b96ff78eb3b5be4f0ec06afa5"
    end
  end

  head do
    url 'https://github.com/hacker/libopkele.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build

  def install
    system "./autogen.bash" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
