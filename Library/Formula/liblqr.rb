require 'formula'

class Liblqr < Formula
  homepage 'http://liblqr.wikidot.com/'
  url 'http://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.2.tar.bz2'
  version '0.4.2'
  sha1 '69639f7dc56a084f59a3198f3a8d72e4a73ff927'

  head 'git://repo.or.cz/liblqr.git'

  bottle do
    cellar :any
    revision 1
    sha1 "7bbd4ffd6c1a531d35781943ca2b69187c3dc435" => :yosemite
    sha1 "3d4a549790100beea4b5382a29dd725e300acebe" => :mavericks
    sha1 "bd524e0373ad841ccd7c838eccb279f710502633" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
