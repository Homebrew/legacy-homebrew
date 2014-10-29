require "formula"

class Talloc < Formula
  homepage "http://talloc.samba.org/"
  url "http://www.samba.org/ftp/talloc/talloc-2.1.1.tar.gz"
  sha1 "380bb786274dfd1a4a8179d31cd88cbee15c97bf"

  bottle do
    cellar :any
    sha1 "95140108cb3675eedb25493d9a6ae51681b293eb" => :yosemite
    sha1 "48d9ed5b9dc8d86b9787d2911df70a4dd2ef1307" => :mavericks
    sha1 "d573466b7e520fcb1cf46fba2d7cd1314a3f1025" => :mountain_lion
  end

  conflicts_with "samba", :because => "both install `include/talloc.h`"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--disable-python"
    system "make install"
  end
end
