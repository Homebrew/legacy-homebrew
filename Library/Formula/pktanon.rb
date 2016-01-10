class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.uka.de/software/pktanon/index.html"
  url "https://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"

  bottle do
    cellar :any
    sha256 "1ca8732fc3e2bce08bb98b04c08051bb697d475f9229207594b2312c65846682" => :el_capitan
    sha256 "22b28b5c1ac0558f57bec4cbcdb774f2fdc4033c1f382c6fd747b8edd3f26fb6" => :yosemite
    sha256 "571a0c0c5212bc3064a705c27d1a3f8626e98e2a7cdef3a8447ddd68eeaad607" => :mavericks
  end

  depends_on "xerces-c"
  depends_on "boost"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %(#include "Timer.h"\r\n),
      %(#include "Timer.h"\r\n#include "unistd.h"\r\n)

    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
