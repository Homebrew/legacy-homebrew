require "formula"

class Delegate < Formula
  homepage "http://www.delegate.org/delegate/"
  url "http://www.delegate.org/anonftp/DeleGate/delegate9.9.9.tar.gz"
  sha1 "6ae841d1b0fc694a6777a1881499c730bd824be2"

  def install
    system "make -j1"  # make will fails if running with multi-threads
    bin.install "src/delegated"
    doc.install "doc/Manual.htm", "doc/tutor-en.htm", "doc/tutor-jp.htm"
    info.install "COPYRIGHT", "CHANGES", "README", "DG9note.html"
  end

  test do
    system "#{bin}/delegated -Fseltest"
  end
end
