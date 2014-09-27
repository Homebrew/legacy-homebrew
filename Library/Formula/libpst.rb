require 'formula'

class Libpst < Formula
  homepage 'http://www.five-ten-sg.com/libpst/'
  url 'http://www.five-ten-sg.com/libpst/packages/libpst-0.6.55.tar.gz'
  sha1 'c81df95509494c99222b0b603f7500dd9caceff1'
  revision 1

  bottle do
    cellar :any
    sha1 "74460b2a89a76274742f7c8bddc49098c597706d" => :mavericks
    sha1 "50d0c1941aae81430f13ff5ee4179ae06dde4696" => :mountain_lion
    sha1 "78e07b11405753acdf6c88904aa7a592d817808c" => :lion
  end

  option 'pst2dii', 'Build pst2dii using gd'

  depends_on :python => :optional
  depends_on 'gd' if build.include? 'pst2dii'
  depends_on "boost"
  depends_on "boost-python" if build.with? "python"

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
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
