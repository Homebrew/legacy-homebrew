require 'formula'

class Igraph < Formula
  homepage 'http://igraph.sourceforge.net'
  url 'http://downloads.sourceforge.net/sourceforge/igraph/igraph-0.6.tar.gz'
  md5 '1590c524b7849ecf9b25705b746756e2'

  # GMP is optional, and doesn't have a universal build
  depends_on 'gmp' => :optional unless ARGV.build_universal?

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
