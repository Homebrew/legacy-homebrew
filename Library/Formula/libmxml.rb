require "formula"

class Libmxml < Formula
  homepage "http://www.minixml.org/"
  url "http://www.msweet.org/files/project3/mxml-2.8.tar.gz"
  sha1 "09d88f1720f69b64b76910dfe2a5c5fa24a8b361"

  bottle do
    cellar :any
    revision 1
    sha1 "16c98f2cbfc50c2764876f62e86ff07aa3915ab4" => :yosemite
    sha1 "9e1d0dc2ade33ffa09dec9f0fa6ac382fffce659" => :mavericks
    sha1 "af0671b9ac604a6e8725785079a1eebab66a975a" => :mountain_lion
  end

  depends_on :xcode => :build # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
