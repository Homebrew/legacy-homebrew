require 'formula'

class Halibut < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/halibut/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.0.tar.gz'
  sha1 '1e4643faf2bb4e1843740b8c70635d3d33bb7989'

  bottle do
    cellar :any
    sha1 "23b5d68b11cf6a8edcfe7d691b0db7a64e7251c9" => :mavericks
    sha1 "a1c3f434f9a017a6777e04e1f820daf9b2d4b756" => :mountain_lion
    sha1 "4d7826b3adb0f4da43f2011a4fa2cb049b0ee21d" => :lion
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
