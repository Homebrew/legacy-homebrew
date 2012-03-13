require 'formula'

class Libvirt < Formula
  homepage 'http://www.libvirt.org'
  url 'ftp://libvirt.org/libvirt/libvirt-0.9.10.tar.gz'
  sha256 '5b81d9f054ee4b395b0ab4f59845d082baaa6d6c2a038c966309156dde16e11d'

  depends_on "gnutls"
  depends_on "yajl"

  if MacOS.leopard?
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
  end

  # Includes a patch by Lincoln Myers <lincoln_myers@yahoo.com>,
  # fixing a recently introduced compilation bug on OSX.
  # Patch is already included upstream, and will be in libvirt 0.9.11.
  def patches
    DATA
  end

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def options
    [['--without-libvirtd', 'Build only the virsh client and development libraries.']]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}",
            "--mandir=#{man}",
            "--sysconfdir=#{etc}",
            "--with-esx",
            "--with-init-script=none",
            "--with-remote",
            "--with-test",
            "--with-vbox",
            "--with-vmware",
            "--with-yajl",
            "--without-qemu"]

    args << "--without-libvirtd" if ARGV.include? '--without-libvirtd'

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make install"

    # Update the SASL config file with the Homebrew prefix
    inreplace "#{etc}/sasl2/libvirt.conf" do |s|
      s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
      s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
    end

    # If the libvirt daemon is built, update its config file to reflect
    # the Homebrew prefix
    unless ARGV.include? '--without-libvirtd'
      inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
        s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
        s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
      end
    end
  end
end

__END__
# Fix for OSX by Lincoln Myers <lincoln_myers@yahoo.com>
--- a/src/util/virfile.h
+++ b/src/util/virfile.h
@@ -58,10 +58,10 @@ typedef virFileWrapperFd *virFileWrapperFdPtr;

 int virFileDirectFdFlag(void);

-enum {
+enum virFileWrapperFdFlags {
     VIR_FILE_WRAPPER_BYPASS_CACHE   = (1 << 0),
     VIR_FILE_WRAPPER_NON_BLOCKING   = (1 << 1),
-} virFileWrapperFdFlags;
+};

 virFileWrapperFdPtr virFileWrapperFdNew(int *fd,
                                         const char *name,
--
1.7.8.3
