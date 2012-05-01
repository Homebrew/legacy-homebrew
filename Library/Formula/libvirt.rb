require 'formula'

class Libvirt < Formula
  homepage 'http://www.libvirt.org'
  version "0.9.11.3"
  url 'ftp://libvirt.org/libvirt/libvirt-0.9.11.3.tar.gz'
  sha256 'aa73b329d2f6eb200991b9dc378d4636c15cd2f95ca224995d01b45257584fa2'

  # Latest (roughly) monthly release.  Enable this by brewing with --devel option
  devel do
    version "0.9.11"
    url 'ftp://libvirt.org/libvirt/libvirt-0.9.11.tar.gz'
    sha256 'ce98fe435f83e109623a021b1f714fe806c3ab556d0780ce959cf75c98766062'
  end

  depends_on "gnutls"
  depends_on "yajl"

  if MacOS.leopard?
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
  end

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def options
    [
      ['--devel', 'Build from the leading edge release series, instead of the stable series.'],
      ['--without-libvirtd', 'Build only the virsh client and development libraries.']
    ]
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
