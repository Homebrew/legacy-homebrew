require 'formula'

class Corkscrew < Formula
  homepage 'http://www.agroman.net/corkscrew/'
  url 'http://www.agroman.net/corkscrew/corkscrew-2.0.tar.gz'
  sha1 '8bdb4c0dc71048136c721c33229b9bf795230b32'

  depends_on "libtool" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/config/config.*"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
