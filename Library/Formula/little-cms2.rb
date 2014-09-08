require 'formula'

class LittleCms2 < Formula
  homepage 'http://www.littlecms.com/'
  url 'https://downloads.sourceforge.net/project/lcms/lcms/2.6/lcms2-2.6.tar.gz'
  sha1 'b0ecee5cb8391338e6c281d1c11dcae2bc22a5d2'

  bottle do
    cellar :any
    sha1 "255a843608552eb947b8a4e382100b9f5988cf6a" => :mavericks
    sha1 "273a1346148048ddca06daad09aaa5edcd88c631" => :mountain_lion
    sha1 "8ece1c144bcb52d6da58baac0595a04a4e9eb32d" => :lion
  end

  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :recommended

  option :universal

  def install
    ENV.universal_binary if build.universal?

    args = %W{--disable-dependency-tracking --prefix=#{prefix}}
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make install"
  end
end
