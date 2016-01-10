class Cronolog < Formula
  desc "Web log rotation"
  homepage "https://web.archive.org/web/20140209202032/http://cronolog.org/"
  url "https://fossies.org/linux/www/old/cronolog-1.6.2.tar.gz"
  sha256 "65e91607643e5aa5b336f17636fa474eb6669acc89288e72feb2f54a27edb88e"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "964df15660a5c0ec25bedec56aeb128ae93794a8ad721c1c600e377df9be1c2d" => :el_capitan
    sha256 "f3f485105f7466422a507bafef3acfd741f18b8ab26438c267d10dbf4701282e" => :yosemite
    sha256 "288bcd1671de08659b7d2f67141aa5178d797870597837c569dccfaae460afd8" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end
end
