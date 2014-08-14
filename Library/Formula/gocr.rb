require 'formula'

class Gocr < Formula
  homepage 'http://jocr.sourceforge.net/'
  url 'http://www-e.uni-magdeburg.de/jschulen/ocr/gocr-0.50.tar.gz'
  sha1 '2018ddf7be1c95dcc12f63f7ac40ad98da06f8a4'

  bottle do
    cellar :any
    sha1 "f230e6056541648f1e0c0a869fbb4a5e1715822d" => :mavericks
    sha1 "2f07d5b621f299c7faaa992127fc106637a4e90c" => :mountain_lion
    sha1 "7137e18511cfd756baa7d19e81ce33cd5bdbf8c5" => :lion
  end

  option 'with-lib', 'Install library and headers'

  depends_on 'netpbm' => :optional

  # Edit makefile to install libs per developer documentation
  patch do
    url "https://gist.githubusercontent.com/mcs07/6229210/raw/2ba2d697b6b5b25dc4b811854abe4928c4e647d6/gocr-libs.diff"
    sha1 "a297e5921af0256fbf0025b8a205cc83ed79278e"
  end if build.with? "lib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! 'mandir', '/share/man'
    end

    system "make libs" if build.with? "lib"
    system "make install"
  end

  test do
    system "#{bin}/gocr -h"
  end
end
