class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.12.tar.gz"
  sha256 "fefea5d9481555cc150ab799b9b1e957564e7fd2ead99fa19e87258f263f7c37"

  bottle do
    cellar :any
    sha256 "a39a144c679b2ae1dfdde6c3062fd9aefefb9d20c44be0943439a17cd1a81a85" => :yosemite
    sha256 "f908fdb42132f3cc2904accf4cefa3623f461a5a683bc37f93c258b144d0c465" => :mavericks
    sha256 "fc3c6f4a0a89f97da20ffea1b99a153e16fc5d9359f73f3c45ca3776912a68e8" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
