require "formula"

class Bip < Formula
  homepage "http://bip.milkypond.org"
  url "https://projects.duckcorp.org/attachments/download/61/bip-0.8.9.tar.gz",
    :using => CurlUnsafeDownloadStrategy
  sha1 "6c6828dde0ec9c41237bac42a679aa8237bdeffe"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
