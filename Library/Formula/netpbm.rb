require 'formula'

class Netpbm < Formula
  homepage 'http://netpbm.sourceforge.net'
  url 'svn+http://netpbm.svn.sourceforge.net/svnroot/netpbm/advanced/', :revision => 1724
  version "10.59.02"
  head 'http://netpbm.svn.sourceforge.net/svnroot/netpbm/trunk'

  depends_on "libtiff"
  depends_on "jasper"
  depends_on :libpng

  def patches
    {:p0 => 
      [
       "https://trac.macports.org/export/95870/trunk/dports/graphics/netpbm/files/patch-clang-sse-workaround.diff",
       "https://trac.macports.org/export/95870/trunk/dports/graphics/netpbm/files/patch-converter-other-giftopnm.c-strcaseeq.diff"
      ]}
  end

  def install
    config = "config.mk"
    (buildpath/"config.mk.in").cp config
    inreplace config do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
      s.change_make_var! "NETPBMLIBTYPE", "dylib"
      s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
      s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{HOMEBREW_PREFIX}/include/jasper"
    end

    ENV.deparallelize
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"
    (buildpath/"stage"/"bin"/"doc.url").unlink # non executable
    cd 'stage' do
      prefix.install %w{ bin include lib misc }
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir['man/man1/*.1']
      man5.install Dir['man/man5/*.5']
      lib.install Dir['link/*.a']
    end
  end
end
