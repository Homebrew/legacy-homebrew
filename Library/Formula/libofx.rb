require 'formula'

class Libofx < Formula
  homepage 'http://libofx.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/libofx/libofx/0.9.9/libofx-0.9.9.tar.gz'
  sha1 'b8ea875cee16953166449de8ddd1b69fb181f61b'

  bottle do
    sha1 "676b94bdce5b335bd7aefac3a0b2a5e11674516a" => :mavericks
    sha1 "d44ebbd6b9850599b0ea5830424046f0a5f5819a" => :mountain_lion
    sha1 "17ce22023ebc16af6e678b2f5b3f01b1e0e62fa5" => :lion
  end

  depends_on 'open-sp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
