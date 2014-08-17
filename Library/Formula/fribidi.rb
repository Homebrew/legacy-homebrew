require 'formula'

class Fribidi < Formula
  homepage 'http://fribidi.org/'
  url 'http://fribidi.org/download/fribidi-0.19.6.tar.bz2'
  sha1 '5a6ff82fdee31d27053c39e03223666ac1cb7a6a'

  bottle do
    cellar :any
    sha1 "8812ccbad33ce5501fbf5d716fe22703d72fccc5" => :mavericks
    sha1 "52bf002f388fb7e05b86b0ab8fa9e2c68a032baf" => :mountain_lion
    sha1 "5926065336b491bf2c7ef3f45e53e31ede031b92" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
