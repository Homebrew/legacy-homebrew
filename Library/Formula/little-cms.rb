require 'formula'

class LittleCms < Formula
  homepage 'http://www.littlecms.com/'
  url 'https://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz'
  sha1 'd5b075ccffc0068015f74f78e4bc39138bcfe2d4'

  bottle do
    cellar :any
    sha1 "7e3ecf535e5ac5181868966ed55a9a494a807833" => :mavericks
    sha1 "bc44cdeb45039f9e5705e4dfe8fb77aa512f5d0c" => :mountain_lion
    sha1 "ed99362dd9703c2012b977cefacf34d8125f1ff8" => :lion
  end

  option :universal

  depends_on :python => :optional
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :recommended

  def install
    ENV.universal_binary if build.universal?
    args = %W{--disable-dependency-tracking --disable-debug --prefix=#{prefix}}
    args << "--with-python" if build.with? "python"
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make install"
  end
end
