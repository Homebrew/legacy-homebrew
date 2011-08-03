require 'formula'

class Libvirt < Formula
  homepage 'http://www.libvirt.org'
  url 'ftp://libvirt.org/libvirt/libvirt-0.9.4.tar.gz'
  sha256 'e76c026646ae4885b162bf711b854f36195f93538d6fcbee48479c2354a342af'

  depends_on "gnutls"
  depends_on "yajl"

  if MacOS.leopard?
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
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
            "--with-vbox=check",
            "--with-vmware",
            "--with-yajl"]

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

