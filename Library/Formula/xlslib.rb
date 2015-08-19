require "formula"

class Xlslib < Formula
  desc "C++/C library to construct Excel .xls files in code"
  homepage "http://sourceforge.net/projects/xlslib"
  url "https://downloads.sourceforge.net/project/xlslib/xlslib-package-2.4.0.zip"
  sha1 "73447c5c632c0e92c1852bd2a2cada7dd25f5492"

  bottle do
    cellar :any
    revision 1
    sha1 "0161ba098ddc20603702218aafb04d6e26a9e135" => :yosemite
    sha1 "39b190165018891f8df7711851d9bd0efd24026e" => :mavericks
    sha1 "3935bcbc13fb51f5646dc55126f0cd921cde6f63" => :mountain_lion
  end

  def install
    cd "xlslib"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
