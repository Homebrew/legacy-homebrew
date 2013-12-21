require 'formula'

class Snzip < Formula
  homepage 'https://github.com/kubo/snzip'
  url 'https://github.com/kubo/snzip/archive/1.0.1.tar.gz'
  sha1 '3aac364c0a508cdb06d771cede6c5758aeb89666'

  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'snappy'

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "snzip", "-h"
  end
end
