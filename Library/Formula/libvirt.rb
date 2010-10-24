require 'formula'

# This formula provides the libvirt daemon (libvirtd), development libraries, and the
# virsh command line tool.  This allows people to manage their virtualisation servers
# remotely, and (as this continues to be developed) manage virtualisation servers
# running on the local host

class Libvirt <Formula
  homepage 'http://www.libvirt.org'
  url 'http://justinclift.fedorapeople.org/libvirt_experimental/libvirt-0.8.4-10.tar.gz'
  sha256 'a878049469ca523aa3109218336fe68073473dca08bd3b16a3487a4de9a049b1'

  depends_on "gawk"
  depends_on "gnutls"
  depends_on "xhtml1-dtds"

  if MACOS_VERSION < 10.6
    # Definitely needed on Leopard, but definitely not Snow Leopard.
    # Likely also needed on earlier OSX releases, though that hasn't
    # been tested yet.
    depends_on "readline"
    depends_on "libxml2"
  end

  def options
    [['--without-libvirtd', 'Build only the virsh client and development libraries.']]
  end

  def install
    fails_with_llvm "Undefined symbols when linking", :build => "2326"

    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}",
            "--mandir=#{man}",
            "--sysconfdir=#{etc}",
            "--with-xml-catalog-file=#{HOMEBREW_PREFIX}/share/xhtml1-dtds-1.0/catalog.xml"]

    args << "--without-libvirtd" if ARGV.include? '--without-libvirtd'

    # Configure libvirt
    system "./configure", *args

    # Compile and install libvirt
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
