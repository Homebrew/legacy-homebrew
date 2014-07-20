require 'formula'

class Liblqr < Formula
  homepage 'http://liblqr.wikidot.com/'
  url 'http://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.2.tar.bz2'
  version '0.4.2'
  sha1 '69639f7dc56a084f59a3198f3a8d72e4a73ff927'

  head 'git://repo.or.cz/liblqr.git'

  bottle do
    cellar :any
    sha1 "fae0de618015a4f7dd0c2aac8a1985cb4d3677d9" => :mavericks
    sha1 "6c30f4fc12c409563331db4cee50748db9ae06d3" => :mountain_lion
    sha1 "cf93eddf8f11497d4354023f7763d5a60ef5d6c5" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
