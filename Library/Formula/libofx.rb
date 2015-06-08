require 'formula'

class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage 'http://libofx.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/libofx/libofx/0.9.9/libofx-0.9.9.tar.gz'
  sha1 'b8ea875cee16953166449de8ddd1b69fb181f61b'

  bottle do
    revision 1
    sha1 "29eeb5e7ddc45ea4c3a5a3f47304082a44046413" => :yosemite
    sha1 "f1c1939e7ea13ba07997f563c8d275195dae9679" => :mavericks
    sha1 "ac76937c8a7dded8bb89f1ece1ea9ede2f8e41a4" => :mountain_lion
  end

  depends_on 'open-sp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
