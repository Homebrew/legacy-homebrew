require 'formula'

class Netpbm < Formula
  homepage 'http://netpbm.sourceforge.net'
  # Maintainers: Look at http://netpbm.svn.sourceforge.net/viewvc/netpbm/
  # for versions and matching revisions
  url 'svn+http://svn.code.sf.net/p/netpbm/code/advanced/', :revision => 2294
  version '10.68'

  head 'http://svn.code.sf.net/p/netpbm/code/trunk'

  bottle do
    cellar :any
    revision 1
    sha1 "c44d6b98a6e2358081e29570cc65e463a2580d0c" => :mavericks
    sha1 "b8182333c2bad2a03669ab820199a1f367c0f8fe" => :mountain_lion
    sha1 "701c82ac12208ae9f7312f1d68724a8f61d69415" => :lion
  end

  option :universal

  depends_on "libtiff"
  depends_on "jasper"
  depends_on "libpng"

  def install
    ENV.universal_binary if build.universal?

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
      inreplace "pkgconfig_template" do |s|
        s.gsub! "@VERSION@", File.read("VERSION").sub("Netpbm ", "").chomp
        s.gsub! "@LINKDIR@", lib
        s.gsub! "@INCLUDEDIR@", include
      end

      prefix.install %w{ bin include lib misc }
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir['man/man1/*.1']
      man5.install Dir['man/man5/*.5']
      lib.install Dir['link/*.a']
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end

    (bin/'doc.url').unlink
  end
end
