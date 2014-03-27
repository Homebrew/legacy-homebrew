require 'formula'

class Gifsicle < Formula
  homepage 'http://www.lcdf.org/gifsicle/'
  url 'http://www.lcdf.org/gifsicle/gifsicle-1.81.tar.gz'
  sha1 'c2952fb3cb601dcfcdf5bd5b9522b6c23731f063'

  option 'without-x', 'Build without X11 support'

  depends_on :x11 if build.with? 'x'

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.without? 'x'
      args << '--disable-gifview'
    end

    system "./configure", *args
    system "make install"
  end
end
