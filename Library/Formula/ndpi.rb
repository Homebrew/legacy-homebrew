require "formula"

class Ndpi < Formula
  homepage "http://www.ntop.org/products/ndpi/"
  url 'https://downloads.sourceforge.net/project/ntop/nDPI/libndpi-1.5.0_r8115.tar.gz'
  version "1.5"

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on 'pkg-config' => :build
  depends_on :libtool => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    `#{bin}/ndpiReader -i en0 -s 5`
    assert_equal 0, $?.exitstatus
  end

end
