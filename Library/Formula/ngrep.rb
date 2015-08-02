require 'formula'

class Ngrep < Formula
  desc "network grep"
  homepage 'http://ngrep.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ngrep/ngrep/1.45/ngrep-1.45.tar.bz2'
  sha1 'f26090a6ac607db66df99c6fa9aef74968f3330f'
  revision 1

  bottle do
    cellar :any
    sha1 "8d06dc84b5e22b309dbf3b2eb1c6933b45478b9c" => :mavericks
    sha1 "a03e65a486e3bd285ad2dd18ce8b6dc7faa04802" => :mountain_lion
    sha1 "03fb46935a159ef96a5905b0f8c39900113a024d" => :lion
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
                          "--with-pcap-includes=#{MacOS.sdk_path}/usr/include",
                          # this line required to avoid segfaults
                          # see https://github.com/jpr5/ngrep/commit/e29fc29
                          # https://github.com/Homebrew/homebrew/issues/27171
                          "--disable-pcap-restart"
    system "make install"
  end
end
