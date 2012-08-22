require 'formula'

class Netpbm < Formula
  homepage 'http://netpbm.sourceforge.net'
  url 'http://sourceforge.net/projects/netpbm/files/super_stable/10.35.82/netpbm-10.35.82.tgz'
  md5 'fcae2fc7928ad7d31b0540ec0c3e710b'

  devel do
    url 'svn+http://netpbm.svn.sourceforge.net/svnroot/netpbm/advanced/', 
        :revision => 1724
    version "10.59.02"
  end
  head 'http://netpbm.svn.sourceforge.net/svnroot/netpbm/trunk'

  depends_on "libtiff"
  depends_on "jasper"
  depends_on :libpng

  def install
    if ARGV.build_head? or ARGV.build_devel?
      # patch apply to trunk and devel only
      NetpbmAdvanced.new("netpbm").brew do
        patched = ["pm_config.in.h", "converter/other/giftopnm.c"]
        patched.each do |file|
          (Pathname.pwd/file).cp buildpath/file
        end
      end
    end
    
    if ARGV.build_head? or ARGV.build_devel?
      config = "config.mk"
    else
      config = "Makefile.config"
    end
    (buildpath/(config+".in")).cp config
    
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
    if ARGV.build_head? or ARGV.build_devel?
      (buildpath/"stage"/"bin"/"doc.url").unlink 
    end
    cd 'stage' do
      prefix.install %w{ bin include lib misc }
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir['man/man1/*.1']
      man5.install Dir['man/man5/*.5']
      lib.install Dir['link/*.a']
    end
  end
end

class NetpbmAdvanced < Formula
  netpbm = Netpbm.new("netpbm")
  url netpbm.devel.url, netpbm.devel.specs
  version netpbm.devel.version
  head netpbm.head.url

  # these patch available only 10.59.xx or trunk
  def patches
    {:p0 => 
      [
       "https://trac.macports.org/export/95870/trunk/dports/graphics/netpbm/files/patch-clang-sse-workaround.diff",
       "https://trac.macports.org/export/95870/trunk/dports/graphics/netpbm/files/patch-converter-other-giftopnm.c-strcaseeq.diff"
      ]}
  end
end
