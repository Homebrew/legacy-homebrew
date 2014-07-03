require 'formula'

class Libart < Formula
  homepage 'http://freshmeat.net/projects/libart/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libart_lgpl/2.3/libart_lgpl-2.3.20.tar.bz2'
  sha1 '40aa6c6c5fb27a8a45cd7aaa302a835ff374d13a'

  bottle do
    cellar :any
    sha1 "9f94f4fdc6a9817aa3c5949a2b7fea26d576418c" => :mavericks
    sha1 "2641e109b753dc8156fa35cffe72a9f1b36e4809" => :mountain_lion
    sha1 "153050c4f1160411d33ac4fb57477bf5efb79568" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
