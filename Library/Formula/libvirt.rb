require 'formula'

class Libvirt < Formula
  homepage 'http://www.libvirt.org'
  url 'http://libvirt.org/sources/libvirt-1.1.3.tar.gz'
  sha256 'af83e65b4b26520662ddd183c1358be0d05138dba3e66745419f06441eff5a7c'

  option 'without-libvirtd', 'Build only the virsh client and development libraries'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'yajl'
  depends_on :python => :recommended

  if MacOS.version <= :leopard
    # Definitely needed on Leopard, but not on Snow Leopard.
    depends_on "readline"
    depends_on "libxml2"
  end

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def patches
    {
      :p1 => [
        # getsockopt() on Mac OS X requires using SOL_LOCAL instead of
        # SOL_SOCKET for LOCAL_PEERCRED. This corrects that for Mac OS X
        "http://libvirt.org/git/?p=libvirt.git;a=commitdiff_plain;h=5a468b38b6b9ac66c1db5d8ed5d5a122a9cf01cd",
        # sysctlbyname() requires a different name on Mac OS X for CPU
        # frequency than FreeBSD does. This patch corrects the name.
        "http://libvirt.org/git/?p=libvirt.git;a=commitdiff_plain;h=2d74822a9eb4856c7f5216bb92bcb76630660f72",
        # Fix Snow Leopard and lower broken by the 1st patch
        "http://libvirt.org/git/?p=libvirt.git;a=commitdiff_plain;h=2f776d49796fe34dcf5a876f4c4e34f79b66f705",
      ]
    }
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
    args << "--without-python" if build.without? 'python'

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

  test do
    python do
      # Testing to import the mod because that is a .so file where linking
      # can break.
      system python, '-c', "import libvirtmod"
    end
  end
end
