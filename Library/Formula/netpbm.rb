require 'formula'

class Netpbm <Formula
  homepage 'http://netpbm.sourceforge.net'
  url 'http://sourceforge.net/projects/netpbm/files/super_stable/10.35.77/netpbm-10.35.77.tgz'
  md5 '65d1b81d72341530f65d66dcd95786ad'

  depends_on "libtiff"
  depends_on "jasper"

  def install
    ENV.x11 # For PNG

    system "cp", "Makefile.config.in", "Makefile.config"

    inreplace "Makefile.config" do |s|
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

    stage_dir = Pathname(Dir.pwd) + 'stage'
    system "make", "package", "pkgdir=#{stage_dir}"

    Dir.chdir stage_dir do
      prefix.install %w{ bin include lib misc }
      share.install Dir['man']
      lib.install Dir['link/*.a']
    end
  end
end
