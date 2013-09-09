require 'formula'

class Cloog < Formula
  homepage 'http://www.cloog.org/'
  url 'http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.0.tar.gz'
  sha1 '85f620a26aabf6a934c44ca40a9799af0952f863'

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
