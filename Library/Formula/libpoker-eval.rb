require "formula"

class LibpokerEval < Formula
  homepage "http://pokersource.sourceforge.net"
  url "http://download.gna.org/pokersource/sources/poker-eval-138.0.tar.gz"
  sha1 "b31e8731dd1cd6717002e175a00d309fc8b02781"

  bottle do
    cellar :any
    sha1 "527615af40e97768abaf974cd012c6dd9d01c7d5" => :mavericks
    sha1 "2b6055b7c47012297522906ff2e77ba857bcf502" => :mountain_lion
    sha1 "3a438207551d9d9f41ea9252e9621affa42ca170" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
