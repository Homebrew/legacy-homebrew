require 'formula'

# This formula provides the libvirt daemon (libvirtd), development libraries, and the
# virsh command line tool.  This allows people to manage their virtualisation servers
# remotely, and (as this continues to be developed) manage virtualisation servers
# running on the local host

class Libvirt <Formula
  homepage 'http://www.libvirt.org'
  url 'http://justinclift.fedorapeople.org/libvirt_experimental/libvirt-0.8.4-6.tar.gz'
  md5 '88c00d745d18159e5a05a5d49a571bc7'

  # Other formulas this depends upon
  depends_on "gawk"
  depends_on "gnutls"

  def options
    [
      ['--without-libvirtd', 'Build only the virsh client and development libraries.']
    ]
  end

  def install
    # Libvirt default compilation option for Mac OS X (for now)
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}",
            "--mandir=#{man}",
            "--sysconfdir=#{etc}"]

    # Instruct libvirt not to build the daemon, if requested by the user
    args << "--without-libvirtd" if ARGV.include? '--without-libvirtd'

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make install"

    # Update the SASL config file with the Homebrew prefix
    inreplace "#{etc}/sasl2/libvirt.conf", "/etc/", "#{HOMEBREW_PREFIX}/etc/"
    inreplace "#{etc}/sasl2/libvirt.conf", "/var/", "#{HOMEBREW_PREFIX}/var/"

    # If the libvirt daemon is built, update its config file to reflect
    # the Homebrew prefix
    if not ARGV.include? '--without-libvirtd'
      inreplace "#{etc}/libvirt/libvirtd.conf", "/etc/", "#{HOMEBREW_PREFIX}/etc/"
      inreplace "#{etc}/libvirt/libvirtd.conf", "/var/", "#{HOMEBREW_PREFIX}/var/"
    end

  end
end
