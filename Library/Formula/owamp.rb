require "formula"

class Owamp < Formula
  homepage "http://www.internet2.edu/performance/owamp/"
  url "http://software.internet2.edu/sources/owamp/owamp-3.4-10.tar.gz"
  sha1 "acf7502eef15fc0ac14d1b1d86e28759b4bc39fe"

  bottle do
    cellar :any
    sha1 "e1746058ddd62ec75ec1b62be837e22c3527c37a" => :yosemite
    sha1 "45429f2d582a54caa0979b9aa533f6dff1c74ec1" => :mavericks
    sha1 "1020642e1ca36fd067828ed344799023aca8ff09" => :mountain_lion
  end

  depends_on "i2util"

  # Fix to prevent tests hanging under certain circumstances.
  # Provided by Aaron Brown via perfsonar-user mailing list:
  # https://lists.internet2.edu/sympa/arc/perfsonar-user/2014-11/msg00131.html
  patch do
    url "http://ndb1.internet2.edu/~aaron/owamp_time_fix.patch"
    sha1 "9e5588d57b357f438ae1a785a713f0deaea5a5ba"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/owping", "-h"
  end
end
