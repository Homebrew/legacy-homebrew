require 'formula'

class Mlxcc < Formula
  homepage 'http://community.marklogic.com/code/libmlxcc'
  url 'http://community.marklogic.com/download/code/libmlxcc/releases/src/mlxcc-0.5.3.tar.gz'
  md5 '2dae6b8cc21e71ecdc65b514aa382d11'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    mktemp do
      (Pathname.pwd / "test.c").write("int main(void) { return 0; }")

      system ENV.cc, "-lmlxcc", "test.c"
    end
  end
end
