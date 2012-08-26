require 'formula'

class Robodoc < Formula
  homepage 'http://rfsber.home.xs4all.nl/Robo/robodoc.html'
  url 'http://rfsber.home.xs4all.nl/Robo/robodoc-4.99.41.tar.gz'
  md5 '986ff954e0ba5a9c407384fc4b05303d'

  head 'https://github.com/gumpu/ROBODoc.git'

  build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "autoreconf", "-f", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
