require 'formula'

# This formula provides the libvirt daemon (libvirtd), development libraries, and the
# virsh command line tool.  This allows people to manage their virtualisation servers
# remotely, and (as this continues to be developed) manage virtualisation servers
# running on the local host

class Libvirt <Formula
  homepage 'http://www.libvirt.org'
  url 'http://mitchellh.github.com/libvirt/libvirt-git-43c2c61f689948aaf18ecbd48b3fd71f3275695a.tar.gz'
  version '0.8.4-43c2c61f'
  md5 '00900bf644239693369a0cc0512129b7'

  depends_on "gawk"
  depends_on "gnutls"

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

    # There is a bug with the current regular autotools style build which
    # doesn't allow the normal "./configure; make; make install" sequence.
    # For now, we regenerate the files and make install manually.
    system "./autogen.sh", *args
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
