class GroongaNormalizerMysql < Formula
  homepage "https://github.com/groonga/groonga-normalizer-mysql"
  url "http://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.0.9.tar.gz"
  sha1 "9057570c1f0e3b5974bf7ac58877af8971ef2a25"

  depends_on "pkg-config" => :build
  depends_on "groonga"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
