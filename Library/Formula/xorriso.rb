require "formula"

class Xorriso < Formula
  homepage "https://www.gnu.org/software/xorriso/"
  url "http://ftpmirror.gnu.org/xorriso/xorriso-1.3.6.pl01.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.3.6.pl01.tar.gz"
  sha1 "b9d8f38726993e707c7bb512c73e591644905e9c"

  bottle do
    cellar :any
    sha1 "90dd3a3725745ec28354c9023a586060fd98e657" => :mavericks
    sha1 "093c903091d37eed55fd4f5401d86cd15f9d3458" => :mountain_lion
    sha1 "cd35b61fc76fb00f0aef3b12b8468b32b25827c7" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/xorriso", "--help"
  end
end
