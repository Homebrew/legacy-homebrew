require 'formula'

# This formula provides the libvirt daemon (libvirtd), development libraries, and the
# virsh command line tool.  This allows people to manage their virtualisation servers
# remotely, and (as this continues to be developed) manage virtualisation servers
# running on the local host

class Libvirt <Formula
  homepage 'http://www.libvirt.org'
  url 'http://libvirt.org/sources/libvirt-0.8.5.tar.gz'
  sha256 '0d4e6aa61ecbfccd3f3289a9821742d599db546eb3f37fe05036a616b3a9df8d'

  depends_on "gawk"
  depends_on "gnutls"

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
            "--sysconfdir=#{etc}"]

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
