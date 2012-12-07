require 'formula'

class Collectd < Formula
  homepage 'http://collectd.org/'
  url 'http://collectd.org/files/collectd-5.1.0.tar.bz2'
  sha1 '77545833b77a03ec02219bfb925e6a1f3463ddef'

  # Will fail against Java 1.7
  option "java", "Enable Java 1.6 support"

  depends_on 'pkg-config' => :build

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

    args << "--disable-embedded-perl" if MacOS.version == :leopard
    args << "--disable-java" unless build.include? "java"

    system "./configure", *args
    system "make install"
  end
end
