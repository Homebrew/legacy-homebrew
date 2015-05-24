require "formula"

class Fswatch < Formula
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.4.7/fswatch-1.4.7.tar.gz"
  sha1 "bfc41da5a56ab810b28945506a0ad4198b13ffef"

  bottle do
    sha1 "11c520a2f84b858ed4b7f1af0390cc35b2a0572c" => :yosemite
    sha1 "6fa6c0691c4156ea0afd4eb7bd3e8ba9635140e1" => :mavericks
    sha1 "355272841f59a7ab5cb248acc48940bec005e5f8" => :mountain_lion
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
