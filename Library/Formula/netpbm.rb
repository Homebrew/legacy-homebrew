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
    sha1 "66a50dea597d6073b6d3ff3642b15a1bfa675b9c" => :mavericks
    sha1 "3299a40b03766b7c75bc5b8496de1ba695ba9542" => :mountain_lion
    sha1 "0426adf328d43d0a6595b74127235c6e7e038912" => :lion
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
