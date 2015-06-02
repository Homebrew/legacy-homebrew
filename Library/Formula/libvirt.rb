class Libvirt < Formula
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-1.2.16.tar.gz"
  sha256 "419bee553442024b9ee8a1fa94023b1189bb52b7c3021fa37d8e4c108490060d"

  bottle do
    sha256 "395320c81107eeb1ec7d00512858849cc7a01f482821995c9a56f649765267fa" => :yosemite
    sha256 "b96b4793184ae698b7be038467e4b946ef706e8f4fb60f0db19c07f7b4c8aa1d" => :mavericks
    sha256 "91a6090536be7381379718ceefd526334227f029f17c895ae21cfd7531dbeec5" => :mountain_lion
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
