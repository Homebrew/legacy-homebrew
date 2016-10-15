require "formula"

class Hcompress < Formula
  homepage "http://www.stsci.edu/software/hcompress.html"
  url "http://www.stsci.edu/ftp/software/hcompress/hcompress.tar.Z"
  sha1 "23788fd2ab136013dfd0f517c2e18a9753c52344"
  version "1.0"

  def install
    ENV.deparallelize
    system "cp unix/* source/"

    bin.mkpath
    cd "source" do
      system "make"
      system "make", "install", "INSTALLDIR=#{bin}"
    end
  end

  test do
    system "#{bin}/hcompress"
  end
end
