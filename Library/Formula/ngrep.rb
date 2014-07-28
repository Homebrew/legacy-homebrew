require 'formula'

class Ngrep < Formula
  homepage 'http://ngrep.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ngrep/ngrep/1.45/ngrep-1.45.tar.bz2'
  sha1 'f26090a6ac607db66df99c6fa9aef74968f3330f'
  revision 1

  bottle do
    cellar :any
    sha1 "4954b0c218b60337906b83e39fed7e80252e1890" => :mavericks
    sha1 "3fa3364523d8027c7222e10f66d6509b6d05bf29" => :mountain_lion
    sha1 "83a26db0ace21d12c72bb1fbb3a8435c726ff9b7" => :lion
  end

  # http://sourceforge.net/p/ngrep/bugs/27/
  patch do
    url  'https://launchpadlibrarian.net/44952147/ngrep-fix-ipv6-support.patch'
    sha1 '84ff02f59b4fab8692a3ff2a61b45a4b9d067177'
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-ipv6",
                          "--prefix=#{prefix}",
                          # this line required to make configure succeed
                          "--with-pcap-includes=/usr/include",
                          # this line required to avoid segfaults
                          # see https://github.com/jpr5/ngrep/commit/e29fc29
                          # https://github.com/Homebrew/homebrew/issues/27171
                          "--disable-pcap-restart"
    system "make install"
  end
end
