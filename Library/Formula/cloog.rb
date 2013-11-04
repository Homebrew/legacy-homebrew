require 'formula'

class Cloog < Formula
  homepage 'http://www.cloog.org/'
  url 'http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.1.tar.gz'
  sha1 '2dc70313e8e2c6610b856d627bce9c9c3f848077'

  bottle do
    sha1 '5ef24be06c4c61d4f37208e128d2f930373d1409' => :mountain_lion
    sha1 '016b2ef75d40ee74be87be43c8642aa47b3abea2' => :lion
    sha1 '6a85fb754c31b9b577e71b13f736d273fd71a3b0' => :snow_leopard
  end

  depends_on 'pkg-config' => :build
  depends_on 'gmp'
  depends_on 'isl'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula.factory("gmp").opt_prefix}",
                          "--with-isl=system",
                          "--with-isl-prefix=#{Formula.factory("isl").opt_prefix}"
    system "make install"
  end

  test do
    cloog_source = <<-EOS.undent
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    require 'open3'
    Open3.popen3("#{bin}/cloog", "/dev/stdin") do |stdin, stdout, _|
      stdin.write(cloog_source)
      stdin.close
      assert_match /Generated from \/dev\/stdin by CLooG/, stdout.read
    end
  end
end
