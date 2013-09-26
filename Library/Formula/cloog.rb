require 'formula'

class Cloog < Formula
  homepage 'http://www.cloog.org/'
  url 'http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.0.tar.gz'
  sha1 '85f620a26aabf6a934c44ca40a9799af0952f863'

  bottle do
    sha1 'f8a2a2221ff9f24f7db53d5de810df8cbd33f5d8' => :mountain_lion
    sha1 'ad314e5ad8f54d183272dfa1971bd705e1d5e46b' => :lion
    sha1 '203c6dd5b1fba557715e8fbb92cbd2d4025b1911' => :snow_leopard
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
