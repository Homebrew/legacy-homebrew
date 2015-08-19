class Mboxgrep < Formula
  desc "Scan a mailbox for messages matching a regular expression"
  homepage "http://www.mboxgrep.org"
  url "https://downloads.sourceforge.net/project/mboxgrep/mboxgrep/0.7.9/mboxgrep-0.7.9.tar.gz"
  sha256 "78d375a05c3520fad4bca88509d4da0dbe9fba31f36790bd20880e212acd99d7"

  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mboxgrep", "--version"
  end
end
