require 'formula'

class Tcc < Formula
  homepage 'http://bellard.org/tcc/'
  url 'http://download.savannah.gnu.org/releases/tinycc/tcc-0.9.26.tar.bz2'
  sha1 '7110354d3637d0e05f43a006364c897248aed5d0'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}",
                          "--source-path=#{buildpath}",
                          "--sysincludepaths=/usr/local/include:#{MacOS.sdk_path}/usr/include:{B}/include"
    system "make"
    system "make", "install"
    system "make", "test"
  end

  test do
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/tcc -run hello-c.c")
  end
end
