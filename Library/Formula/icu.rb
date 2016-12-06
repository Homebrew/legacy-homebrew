require 'formula'

class Icu < Formula
  url 'http://download.icu-project.org/files/icu4c/4.6.1/icu4c-4_6_1-src.tgz'
  homepage 'http://site.icu-project.org/'
  md5 'da64675d85f0c2191cef93a8cb5eea88'

  def install
    cd "source" do
      system "./configure --prefix=#{prefix}"
      system "make install"
    end
  end
end
