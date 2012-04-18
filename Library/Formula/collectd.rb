require 'formula'

class Collectd < Formula
  url 'http://collectd.org/files/collectd-5.0.2.tar.bz2'
  homepage 'http://collectd.org/'
  md5 '47f70ae20801f10be355dc8109d696aa'

  depends_on 'pkg-config' => :build

  skip_clean :all

  # won't compile with Clang; use --use-gcc instead
  fails_with :clang do
    build "3.1 build 318"
    cause <<-EOS.undent
      Clang interacts poorly with the collectd-bundled libltdl, the configure fails with "C compiler cannot build executables" in the inner ./configure run when using Clang
      EOS
  end

  def install
    # Use system Python; doesn't compile against 2.7
    args = ["--disable-debug", "--disable-dependency-tracking", "-C",
            "--with-python=/usr/bin",
            "--prefix=#{prefix}",
            "--localstatedir=#{var}"]
    args << "--disable-embedded-perl" if MacOS.leopard?

    system "./configure", *args
    system "make install"
  end
end
