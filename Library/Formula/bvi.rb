class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "http://bvi.sourceforge.net"
  url "https://downloads.sourceforge.net/bvi/bvi-1.4.0.src.tar.gz"
  sha1 "7b3c0760f0779dba920e08eafcf2fe23a09d70da"

  bottle do
    sha1 "d14b7c6362ffe938f1fd500334a06cc69389c465" => :yosemite
    sha1 "2f84d8f0bf10abe0200ce7e238c0241adbc7af77" => :mavericks
    sha1 "02b757f6d6e79ccd19fec3fdb34a7335440b291f" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system "#{bin}/bvi", "-c", "q"
  end
end
