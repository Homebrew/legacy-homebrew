require 'formula'

class Netpbm < Formula
  homepage 'http://netpbm.sourceforge.net'
  head 'http://netpbm.svn.sourceforge.net/svnroot/netpbm/trunk'

  depends_on "libtiff"
  depends_on "jasper"

  def install
    ENV.x11 # For PNG

    system "cp", "config.mk.in", "config.mk"
    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
      s.change_make_var! "NETPBMLIBTYPE", "dylib"
      s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
      s.change_make_var! "LDSHLIB", "--shared -o $(SONAME) -install_name @executable_path/../lib/libnetpbm.$(MAJ).$(MIN).dylib"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{HOMEBREW_PREFIX}/include/jasper"
    end

    ENV.no_optimization # any optimization cflags cause runtime problem with libpng (https://github.com/mxcl/homebrew/pull/12451#issuecomment-6002756)
    ENV.append_to_cflags '-D_BSD_SOURCE'
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"
    cd 'stage' do
      prefix.install %w{ bin include lib misc }
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir['man/man1/*.1']
      man5.install Dir['man/man5/*.5']
      lib.install Dir['link/*.a']
    end
  end
end
