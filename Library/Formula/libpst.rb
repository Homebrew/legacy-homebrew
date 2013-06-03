require 'formula'

class Libpst < Formula
  homepage 'http://www.five-ten-sg.com/libpst/'
  url 'http://www.five-ten-sg.com/libpst/packages/libpst-0.6.55.tar.gz'
  sha1 'c81df95509494c99222b0b603f7500dd9caceff1'

  option 'pst2dii', 'Build pst2dii using gd'

  depends_on 'boost'
  depends_on :python => :optional
  depends_on 'gd' if build.with? 'pst2dii'

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << '--disable-dii' unless build.with? 'pst2dii'
    if build.with? 'python'
      # ENV['PYTHON_EXTRA_LDFLAGS'] = '-u _PyMac_Error'
      args << '--enable-python' << '--with-boost-python=mt'
    else
      args << '--disable-python'
    end
    system "./configure", *args
    system "make install"
  end
end
