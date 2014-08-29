require 'formula'

class Libpst < Formula
  homepage 'http://www.five-ten-sg.com/libpst/'
  url 'http://www.five-ten-sg.com/libpst/packages/libpst-0.6.55.tar.gz'
  sha1 'c81df95509494c99222b0b603f7500dd9caceff1'

  bottle do
    cellar :any
    sha1 "a909e2b078fb8d76a1c05441a97b1585597160b8" => :mavericks
    sha1 "46f92a8ff5ef9e1ef43179692e73f15a42830862" => :mountain_lion
    sha1 "d63f916829648d4772d2affcf215e570a9a6fd40" => :lion
  end

  option 'pst2dii', 'Build pst2dii using gd'

  depends_on :python => :optional
  depends_on 'gd' if build.include? 'pst2dii'

  if build.with? "python"
    depends_on "boost" => "with-python"
  else
    depends_on "boost"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << '--disable-dii' unless build.include? 'pst2dii'
    if build.with? 'python'
      args << '--enable-python' << '--with-boost-python=mt'
    else
      args << '--disable-python'
    end
    system "./configure", *args
    system "make install"
  end
end
