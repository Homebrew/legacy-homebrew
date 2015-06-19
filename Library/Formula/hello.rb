require "formula"

class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "http://ftpmirror.gnu.org/hello/hello-2.10.tar.gz"
  sha1 "f7bebf6f9c62a2295e889f66e05ce9bfaed9ace3"

  bottle do
    cellar :any
    sha1 "91dbdb51264005a4b5be16dc34726c6ddd358e59" => :yosemite
    sha1 "ce8368b741ae6c8ceda6eb8b570864cc4e9f4c45" => :mavericks
    sha1 "31f4537c7c3d231bf48fa50a14c1d82a958066c4" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
     system "#{bin}/hello", "--greeting=brew"
  end
end
