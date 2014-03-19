require 'formula'

class Libvirt < Formula
  homepage 'http://www.libvirt.org'
  url 'http://libvirt.org/sources/libvirt-1.2.1.tar.gz'
  sha256 'bc29b5751bf36753c17e2fdbb75e70c7b07df3d9527586d3426e90f5f4abb898'
  revision 2

  bottle do
    sha1 "0bfaabdc25891e5f01915eba40c9ffc262fc5417" => :mavericks
    sha1 "93fa00f726556ad96b33f71a4bffb55bac5f0ce4" => :mountain_lion
    sha1 "b13fe900124c065e247d3a472197cca19d52221a" => :lion
  end

  option 'without-libvirtd', 'Build only the virsh client and development libraries'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'yajl'

  if MacOS.version <= :leopard
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

    args << "--without-libvirtd" if build.without? 'libvirtd'

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
    if build.with? "libvirtd"
      inreplace "#{etc}/libvirt/libvirtd.conf" do |s|
        s.gsub! "/etc/", "#{HOMEBREW_PREFIX}/etc/"
        s.gsub! "/var/", "#{HOMEBREW_PREFIX}/var/"
      end
    end
  end
end
