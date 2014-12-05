require "formula"

class Owamp < Formula
  homepage "http://www.internet2.edu/performance/owamp/"
  url "http://software.internet2.edu/sources/owamp/owamp-3.4-10.tar.gz"
  sha1 "acf7502eef15fc0ac14d1b1d86e28759b4bc39fe"

  bottle do
    cellar :any
    sha1 "bae5fbfcde1fa634d1a97dcf085722e7d4f3e7cc" => :yosemite
    sha1 "40052c815375a344fecc8985a72612fe91320269" => :mavericks
    sha1 "34531c931ad6b22e4328b3823f2c2f38027db2c6" => :mountain_lion
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
