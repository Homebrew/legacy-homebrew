require 'formula'

class Libvirt < Formula
  homepage 'http://www.libvirt.org'
  url 'http://libvirt.org/sources/stable_updates/libvirt-0.9.11.8.tar.gz'
  sha256 '70166babeae021bb22b601fb638354b1074e87c227bdfe1c5b605b4dc79c1032'

  # Latest (roughly) monthly release.
  devel do
    url 'http://libvirt.org/sources/libvirt-1.0.1.tar.gz'
    sha256 '4a16c76c46ebc41a6514082b5d95b5d5a0868e7a8cc00ab2e6cc1a23ec6b5a3b'
  end

  option 'without-libvirtd', 'Build only the virsh client and development libraries'

  depends_on "gnutls"
  depends_on 'libgcrypt'
  depends_on "yajl"

  if MacOS.version == :leopard
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
  end

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
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

    args << "--without-libvirtd" if build.include? 'without-libvirtd'

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make install"

    # Update the SASL config file with the Homebrew prefix
    inreplace "#{etc}/sasl2/libvirt.conf" do |s|
      s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
    end

    # If the libvirt daemon is built, update its config file to reflect
    # the Homebrew prefix
    unless build.include? 'without-libvirtd'
      inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
        s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
        s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
      end
    end
  end
end
