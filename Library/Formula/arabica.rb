class Arabica < Formula
  desc "XML toolkit written in C++"
  homepage "http://www.jezuk.co.uk/cgi-bin/view/arabica"
  url "https://github.com/jezhiggins/arabica/archive/2016-January.tar.gz"
  version "20160214"
  sha256 "ea6940773ae95ec02c6736c0ba688bdfb5c7691e7d2c8da1b331eca74949d73a"
  head "https://github.com/jezhiggins/arabica.git"

  bottle do
    cellar :any
    sha256 "185edd120b5759f25d1e69b9f24840eef6a404b1001c90e684546e359cf75928" => :el_capitan
    sha256 "1882f30edf8da8d98df603a6006c3dce96e21941e4266103366930b3e5a922c2" => :yosemite
    sha256 "5d247d4d5819106404bc7091e3b6141b4d298c77636bee39bfc524a3c5481e7f" => :mavericks
  end

  option "without-test", "Skip compile-time make checks (Not Recommended)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost" => :recommended

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
