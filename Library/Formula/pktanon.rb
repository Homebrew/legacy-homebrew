require "formula"

class Pktanon < Formula
  homepage "http://www.tm.uka.de/software/pktanon/index.html"
  url "http://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha1 "458530c2b167694ee7a29653033e86f0b23e54bd"

  depends_on "xerces-c"
  depends_on "boost"

  # fix compile failure caused by undefined function 'sleep'.
  patch <<-EOS.undent
    diff --git a/src/Timer.cpp b/src/Timer.cpp
    index f97be1d..6fb7d53 100644
    --- a/src/Timer.cpp
    +++ b/src/Timer.cpp
    @@ -17,6 +17,7 @@
     //\r
     \r
     #include "Timer.h"\r
    +#include <unistd.h> // for ::sleep(unsigned int)\r
     \r
     Timer::Timer ()\r
     :	userdata	(NULL),\r

  EOS

  def install
    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
