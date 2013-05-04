require 'formula'

class Mlxcc < Formula
  homepage 'http://community.marklogic.com/code/libmlxcc'
  url 'http://community.marklogic.com/download/code/libmlxcc/releases/src/mlxcc-0.5.3.tar.gz'
  sha1 'b786fce623e69e5f17c73a0917b2b0bac9bd992b'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    (testpath/"test.c").write("int main(void) { return 0; }")
    system ENV.cc, "-lmlxcc", "test.c"
  end
end
