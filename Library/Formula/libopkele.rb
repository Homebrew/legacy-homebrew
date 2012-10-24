require 'formula'

class Libopkele < Formula
  url 'http://kin.klever.net/dist/libopkele-2.0.4.tar.bz2'
  homepage 'http://kin.klever.net/libopkele/'
  md5 '47a7efbdd2c9caaaa8e4360eb2beea21'
  head 'git://github.com/hacker/libopkele.git'

  depends_on 'openssl'
  depends_on 'pkg-config' => :build

  fails_with :clang

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "./autogen.bash" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
