require 'formula'

class Libsgml < Formula
  url 'http://www.hick.org/code/skape/libsgml/libsgml-1.1.4.tar.gz'
  homepage 'http://www.hick.org'
  md5 'a3ba2f8c19faf1a53182d9c6fab22e58'

  def patches
    macports_patches %w[
      patch-examples_variant.c.diff
      patch-src_Variant.c.diff
      patch-Makefile.in.diff
      patch-configure.in.diff
      patch-src_Makefile.in.diff
    ]
  end

  def install
    lib.mkpath
    system "autoreconf -fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end

  def macports_patches(files)
    { :p0 => files.collect { |file| macports_patch_url('textproc', file) } }
  end

  def macports_patch_url(group, file)
    template = 'http://svn.macports.org/repository/macports/trunk/dports/%s/%s/files/%s'
    template % [group, name, file]
  end
end
