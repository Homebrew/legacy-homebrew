require 'formula'

class Halibut < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/halibut/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.0.tar.gz'
  sha1 '1e4643faf2bb4e1843740b8c70635d3d33bb7989'

  bottle do
    cellar :any
    revision 1
    sha1 "27a4552810abd6b9df1cf35d4f9b6b450de08dc9" => :yosemite
    sha1 "bfc2c0ca0bea4953fc0beea4f6dd009617b72f89" => :mavericks
    sha1 "8cfc5a662b31be69a88f92dd492c005db936e21e" => :mountain_lion
  end

  def install
    bin.mkpath
    man1.mkpath

    system "make", "prefix=#{prefix}", "mandir=#{man}", "all"
    system "make", "-C", "doc", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    # Initial sanity test
    system "#{bin}/halibut", "--version"

    # Test converting to HTML.
    (testpath/'sample.but').write('Hello, world!')
    system "#{bin}/halibut", "--html=sample.html", "sample.but"

    assert_match /<p>\nHello, world!\n<\/p>/, (testpath/'sample.html').read()
  end
end
