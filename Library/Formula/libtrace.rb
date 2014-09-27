require "formula"

class Libtrace < Formula
  homepage "http://research.wand.net.nz/software/libtrace.php"
  url "http://research.wand.net.nz/software/libtrace/libtrace-3.0.21.tar.bz2"
  sha1 "208908ceee0dde9a556dc4cf1d5dac7320f6bae3"

  bottle do
    sha1 "8a81dce47f39b1f226cde176f818dfadd93baf6d" => :mavericks
    sha1 "fcad7f2f195f8fc54baeca27b183d58172e6f5e1" => :mountain_lion
    sha1 "027b68f4638e318801693a85fc699c33b91065b6" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
