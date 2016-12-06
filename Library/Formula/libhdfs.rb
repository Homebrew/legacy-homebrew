require 'formula'

class Libhdfs < Formula
  homepage 'http://wiki.apache.org/hadoop/LibHDFS'
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/core/hadoop-1.1.2/hadoop-1.1.2.tar.gz'
  sha1 '0142847f35485894bd833d87945d4bc59483ce5a'

  def install
    Dir.chdir("src/c++/libhdfs") do
      File.chmod(0755, "configure")
      File.chmod(0755, "install-sh")
      system "./configure", "--prefix=#{prefix}"

      arch = `java -d64 -version`
      ENV["JVM_ARCH"] = arch =~ /java version/ ? "64" : "32"

      inreplace "hdfsJniHelper.c", "#include <error.h>", ""

      system "make install"
    end

    include.install Dir["src/c++/libhdfs/*.h"]
  end

  test do
    (testpath/"test.c").write(<<-C)
      int main() {
        return 0;
      }
      C
    system ENV.cc, "-lhdfs", "test.c"
  end
end
