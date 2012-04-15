require 'formula'

class Libzzip < Formula
  url 'http://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.61/zziplib-0.13.61.tar.bz2'
  homepage 'http://sourceforge.net/projects/zziplib/'
  sha1 'c7e526165e674962303d62798963d89524636813'

  depends_on 'pkg-config' => :build

  def options
    [[ '--universal', 'Build a universal binary' ]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    ENV["ac_cv_sizeof_long"] = "(LONG_BIT/8)" if ARGV.build_universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
    ENV.deparallelize     # fails without this when a compressed file isn't ready.
    system "make check"   # runing this after install bypasses DYLD issues.
  end
end
