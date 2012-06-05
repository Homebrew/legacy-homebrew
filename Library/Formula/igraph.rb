require 'formula'

class Igraph < Formula
  homepage 'http://igraph.sourceforge.net'
  url 'http://downloads.sourceforge.net/sourceforge/igraph/igraph-0.5.4.tar.gz'
  md5 '47963ece64fe5f793e154e238bc6c3c3'

  # GMP is optional, and doesn't have a universal build
  depends_on 'gmp' => :optional unless ARGV.build_universal?

  def options
    [["--universal", "Build a universal binary."]]
  end

  # Fix for llvm-gcc. This is already merged in upstream and
  # will not be required for igraph >= 0.5.5
  def patches
    "https://raw.github.com/gist/1209951/e337ad8c2d8cb613872e5381a99f411d314576a1/igraph-0.5.4_llvm-gcc.patch"
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
