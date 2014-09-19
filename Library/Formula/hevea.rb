require "formula"

class Hevea < Formula
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/distri/hevea-2.18.tar.gz"
  sha1 "1fc764a6fc946069b4ca91b29fa1e71c405265d9"

  bottle do
    cellar :any
    sha1 "714586cc3e98c410ca04a5ce7e74e8f97a6ce81f" => :mavericks
    sha1 "34bf91a61ab4e2c4121832185cb2b6295277305c" => :mountain_lion
    sha1 "4451bc3e788a14866faa76eea794f86baf182c4c" => :lion
  end

  depends_on "objective-caml"
  depends_on "ghostscript" => :optional

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
