require "formula"

class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "http://www.tm.uka.de/software/pktanon/index.html"
  url "http://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha1 "458530c2b167694ee7a29653033e86f0b23e54bd"

  depends_on "xerces-c"
  depends_on "boost"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %{#include "Timer.h"\r\n},
      %{#include "Timer.h"\r\n#include "unistd.h"\r\n}

    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
