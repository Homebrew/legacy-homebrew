class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "http://simple-evcorr.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/simple-evcorr/sec/2.7.6/sec-2.7.6.tar.gz"
  sha256 "3714ce9dc9c769cefc63811703905d62f45868618842d186ad6bdc522cd53ad3"

  bottle :unneeded

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
