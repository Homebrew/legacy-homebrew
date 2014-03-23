require 'formula'

class Netpbm < Formula
  homepage 'http://netpbm.sourceforge.net'
  # Maintainers: Look at http://netpbm.svn.sourceforge.net/viewvc/netpbm/
  # for versions and matching revisions
  url 'svn+http://svn.code.sf.net/p/netpbm/code/advanced/', :revision => 1809
  version '10.60.05'
  revision 1

  head 'http://svn.code.sf.net/p/netpbm/code/trunk'

  depends_on "libtiff"
  depends_on "jasper"
  depends_on "libpng"

  def install
    system "cp", "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
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
      s.change_make_var! "JASPERHDR_DIR", "#{Formula["jasper"].opt_include}/jasper"
    end

    ENV.deparallelize
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"
    cd 'stage' do
      prefix.install %w{ bin include lib misc }
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir['man/man1/*.1']
      man5.install Dir['man/man5/*.5']
      lib.install Dir['link/*.a']
    end

    (bin/'doc.url').unlink
  end
end
