class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-1.2.16.tar.gz"
  sha256 "419bee553442024b9ee8a1fa94023b1189bb52b7c3021fa37d8e4c108490060d"

  bottle do
    sha256 "a68e9dc88e03404771892779217e88ece9aac7e40827e2337fe6ed7ef8e0c20e" => :yosemite
    sha256 "58a57ea01783a4045fd6891ab0cb75ad7fcedf80deb0afd338c30d2c6d7d9f06" => :mavericks
    sha256 "1c6fc151d3b2b34eac2989d17427330a61a78bfd87e851ad3353800d9431d810" => :mountain_lion
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
    system "make", "install"

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
