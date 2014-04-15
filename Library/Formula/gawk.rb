require 'formula'

class Gawk < Formula
  homepage 'http://www.gnu.org/software/gawk/'
  url 'http://ftpmirror.gnu.org/gawk/gawk-4.1.1.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/gawk/gawk-4.1.1.tar.xz'
  sha1 '547feb48d20e923aff58daccee97c94e047fdc18'

  bottle do
    sha1 "c65a78da9b8bc8eceb24f1bbae2892c16aa0c202" => :mavericks
    sha1 "db98589dfcbf0875e172b41bc4b08148737e46bd" => :mountain_lion
    sha1 "a90fa8c6c4ce4ffec0a103f567db5eec319bb3bf" => :lion
  end

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-readline",
                          "--without-mpfr",
                          "--without-libsigsegv-prefix"
    system "make"
    system "make check"
    system "make install"
  end

  test do
    output = `echo "Macrobrew" | '#{bin}/gawk'  '{ gsub(/Macro/, "Home"); print }' -`
    assert_equal 'Homebrew', output.strip
    assert_equal 0, $?.exitstatus
  end
end
