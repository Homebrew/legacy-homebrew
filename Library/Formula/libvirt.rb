require 'formula'

class Libvirt < Formula
  homepage 'http://www.libvirt.org'
  url 'http://libvirt.org/sources/libvirt-1.2.5.tar.gz'
  sha256 '8ee97de3435b823ad2bc40a0b3c395efe2184ae748a92e2211fbe9393939ed45'

  bottle do
    sha1 "de5a7d8ead03f3f99222605eab33d73d4de25245" => :mavericks
    sha1 "9f45281b30f32e5930bab34186730ec75baea5d3" => :mountain_lion
    sha1 "b675166cf89022986fe4e7b0f5135e8501b7eb17" => :lion
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
