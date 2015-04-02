require "formula"

class Libvirt < Formula
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-1.2.14.tar.gz"
  sha256 "b8e8e6f1fc91eb8694fa21f9c57a736fa4a5af10562e14e4aa2c7e23510c4c07"

  bottle do
    sha256 "7bca5ddc327279ab529df9e2ec133cea56d59794121761d463e2820e0d91eb73" => :yosemite
    sha256 "47c3317f8f8e3cf7ceaea72db98523d5850f080edd143a635d02f2fff37ca4d4" => :mavericks
    sha256 "0dbd8987cc4b04b8f286e9488f68fd64cd3a887c3e5d3b69c7725b1a66623468" => :mountain_lion
  end

  option "without-libvirtd", "Build only the virsh client and development libraries"

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "yajl"

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

    args << "--without-libvirtd" if build.without? "libvirtd"

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
