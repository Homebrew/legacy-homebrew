require 'formula'

class Cairo < Formula
  homepage 'http://cairographics.org/'
  url 'http://www.cairographics.org/releases/cairo-1.12.0.tar.gz'
  sha1 '63e0d1372a7919956b6d959709dfdf35d3cecc02'

  depends_on 'pkg-config' => :build
  depends_on 'pixman'

  keg_only :provided_by_osx,
            "The Cairo provided by Leopard is too old for newer software to link against."

  fails_with :llvm do
    build 2336
    cause "Throws an 'lto could not merge' error during build."
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-x
    ]
    args << '--enable-xcb' unless MacOS.leopard?

    system "./configure", *args
    system "make install"
  end
end
