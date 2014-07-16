require 'formula'

class Xlslib < Formula
  homepage 'http://sourceforge.net/projects/xlslib'
  url 'https://downloads.sourceforge.net/project/xlslib/xlslib-package-2.4.0.zip'
  sha1 '73447c5c632c0e92c1852bd2a2cada7dd25f5492'

  bottle do
    cellar :any
    sha1 "3c59ef7c51a220426327497d48aab6188aa80d3a" => :mavericks
    sha1 "69812c1e71bd582d61f1693bd00edc07a426360b" => :mountain_lion
    sha1 "d9fc2ec1a71a7845fd48b41e2e63641bfb5d75f9" => :lion
  end

  def install
    cd 'xlslib'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
