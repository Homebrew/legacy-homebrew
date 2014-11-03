require 'formula'

class Ilmbase < Formula
  homepage 'http://www.openexr.com/'
  url 'http://download.savannah.gnu.org/releases/openexr/ilmbase-2.1.0.tar.gz'
  mirror 'http://download-mirror.savannah.gnu.org/releases/openexr/ilmbase-2.1.0.tar.gz'
  sha1 '306d76e7a2ac619c2f641f54b59dd95576525192'

  bottle do
    cellar :any
    revision 1
    sha1 "54e793d8813ee0fdf354d4bee73d01e28fbfde03" => :yosemite
    sha1 "34c4d4dfc3fe428e82bf52e92ae74dad395b2b04" => :mavericks
    sha1 "3e5f72f788db233cdd7088349dbec90e4de950db" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

