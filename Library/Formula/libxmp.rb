require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/xmp/libxmp/4.2.7/libxmp-4.2.7.tar.gz'
  sha1 'cc7b1340bd8664d933311d23550ae4279abf2ecc'

  bottle do
    cellar :any
    sha1 "3f6f84b50d66073e99e7dbb582296a5f99b2131c" => :mavericks
    sha1 "1f27fb8648e5d507b769f23303208c15f992a8ab" => :mountain_lion
    sha1 "fb1018e367794aa2870f003f1fcb68ab871703af" => :lion
  end

  head do
    url 'git://git.code.sf.net/p/xmp/libxmp'
    depends_on :autoconf
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
