class Ngrep < Formula
  desc "network grep"
  homepage "http://ngrep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ngrep/ngrep/1.45/ngrep-1.45.tar.bz2"
  sha256 "aea6dd337da8781847c75b3b5b876e4de9c58520e0d77310679a979fc6402fa7"
  revision 1

  bottle do
    cellar :any
    sha256 "eda4947ad23c1dd1c13fc7225686f30c1d7b2a20a294f4d5a3339ff5773d7ab1" => :mavericks
    sha256 "49c45453a57f68cf5eb30184c101a0e9585ec0c486e4fa5f7e663456d82599dd" => :mountain_lion
    sha256 "c380a98ece9cc122e3ba008a9f9a07aadccc5f2e393b5a68f55acd40f9fd325b" => :lion
  end

  # http://sourceforge.net/p/ngrep/bugs/27/
  patch do
    url "https://launchpadlibrarian.net/44952147/ngrep-fix-ipv6-support.patch"
    sha256 "f1bcc0a344e5f454207254746cab5b1d216d3de3efaf08f59732f2182d42bbb1"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-ipv6",
                          "--prefix=#{prefix}",
                          # this line required to make configure succeed
                          "--with-pcap-includes=#{MacOS.sdk_path}/usr/include/pcap",
                          # this line required to avoid segfaults
                          # see https://github.com/jpr5/ngrep/commit/e29fc29
                          # https://github.com/Homebrew/homebrew/issues/27171
                          "--disable-pcap-restart"
    system "make", "install"
  end
end
