require 'formula'

class Lrzip < Formula
  homepage 'http://lrzip.kolivas.org'
  url 'http://ck.kolivas.org/apps/lrzip/lrzip-0.616.tar.bz2'
  sha1 '374a021ff087ee93b2d5894fd16aa3aef26dfa8f'

  depends_on 'pkg-config' => :build
  depends_on "lzo"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lrz
    system bin/"lrzip", "-o", "#{path}.lrz", path
    path.unlink

    # decompress: data.txt.lrz -> data.txt
    system bin/"lrzip", "-d", "#{path}.lrz"
    assert_equal original_contents, path.read
  end
end
