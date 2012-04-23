require 'formula'

class Collectd < Formula
  url 'http://collectd.org/files/collectd-5.0.2.tar.bz2'
  homepage 'http://collectd.org/'
  md5 '47f70ae20801f10be355dc8109d696aa'

  depends_on 'pkg-config' => :build

  skip_clean :all

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      Clang interacts poorly with the collectd-bundled libltdl,
      causing configure to fail.
      EOS
  end

  def install
    # Use system Python; doesn't compile against 2.7
    # -C enables the cache and resolves permissions errors
    args = %W[-C
              --disable-debug
              --disable-dependency-tracking
              --prefix=#{prefix}
              --localstatedir=#{var}
              --with-python=/usr/bin]

    args << "--disable-embedded-perl" if MacOS.leopard?

    system "./configure", *args
    system "make install"
  end
end
