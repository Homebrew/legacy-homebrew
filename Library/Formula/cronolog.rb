require "formula"

class Cronolog < Formula
  desc "Web log rotation"
  homepage "https://web.archive.org/web/20140209202032/http://cronolog.org/"
  url "https://fossies.org/linux/www/old/cronolog-1.6.2.tar.gz"
  sha256 "65e91607643e5aa5b336f17636fa474eb6669acc89288e72feb2f54a27edb88e"

  bottle do
    cellar :any
    sha256 "0a229d22fc4a3904d379178bc48ed1c1ab1a7ddc2668bb829be35d37ed145871" => :yosemite
    sha256 "36e3687b4a057e474f8fe9f03741e41757ed4c7e5e59f65bb547abaf8b4c77eb" => :mavericks
    sha256 "298aa5f354a548972161038371eba48204d6785e67ea16d301f5214ba67c3d5f" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end
