require 'formula'

class Robodoc < Formula
  homepage 'http://rfsber.home.xs4all.nl/Robo/robodoc.html'
  url 'http://rfsber.home.xs4all.nl/Robo/robodoc-4.99.41.tar.gz'
  sha1 'f2dfb53c667681bf0c5424be9b14f3a1e7edab9b'

  head do
    url 'https://github.com/gumpu/ROBODoc.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-f", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
