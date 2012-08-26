require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://dl.rust-lang.org/dist/rust-0.3.tar.gz'
  sha256 'b34c895b9596abb6942d1688e6a5189b08b92e2507234779779c1af91e9ae84e'
=======
  url 'http://dl.rust-lang.org/dist/rust-0.3.1.tar.gz'
  sha256 'eb99ff2e745ecb6eaf01d4caddebce397a2b4cda6836a051cb2d493b9cedd018'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
  url 'http://dl.rust-lang.org/dist/rust-0.3.1.tar.gz'
  sha256 'eb99ff2e745ecb6eaf01d4caddebce397a2b4cda6836a051cb2d493b9cedd018'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  fails_with :clang do
    build 318
    cause "cannot initialize a parameter of type 'volatile long long *' with an rvalue of type 'int *'"
  end

  def patches
    # fix for Mountain Lion's clang 4.0
    # should be part of next release (commit 50f2db4)
    DATA
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-clang" if ENV.compiler == :clang
    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/rustc"
    system "#{bin}/rustdoc"
    system "#{bin}/cargo"
  end
end

__END__
diff --git a/configure b/configure
index 06bddcc..040bae9 100755
--- a/configure
+++ b/configure
@@ -400,7 +400,7 @@ then
                       | cut -d ' ' -f 2)

     case $CFG_CLANG_VERSION in
-        (3.0svn | 3.0 | 3.1)
+        (3.0svn | 3.0 | 3.1 | 4.0)
         step_msg "found ok version of CLANG: $CFG_CLANG_VERSION"
         CFG_C_COMPILER="clang"
         ;;
