require 'formula'

class Gforth < Formula
  homepage 'http://bernd-paysan.de/gforth.html'
  url 'http://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.0.tar.gz'
  sha1 '5bb357268cba683f2a8c63d2a4bcab8f41cb0086'

  depends_on :libtool
  depends_on 'libffi'
  depends_on 'pcre'

  def darwin_major_version
    # kern.osrelease: 11.4.2
    full_version = `/usr/sbin/sysctl -n kern.osrelease`
    full_version.split("\.")[0]
  end

  def install
    ENV.j1 # Parallel builds won't work
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if MacOS.prefer_64_bit?
      args << "--build=x86_64-apple-darwin#{darwin_major_version}"
    end

    system "./configure", *args
    system "make" # Separate build steps.
    system "make install"
  end
end
