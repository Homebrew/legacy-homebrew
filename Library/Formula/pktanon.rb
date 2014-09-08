require 'formula'

class Pktanon < Formula
  homepage 'http://www.tm.uka.de/software/pktanon/index.html'
  url 'http://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz'
  sha1 '458530c2b167694ee7a29653033e86f0b23e54bd'

  depends_on 'xerces-c'
  depends_on 'boost'

  def install
    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
