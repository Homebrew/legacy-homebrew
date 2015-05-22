require 'formula'

class Encfs < Formula
  homepage 'https://vgough.github.io/encfs/'

  stable do
    url 'https://github.com/vgough/encfs/archive/v1.8.1.tar.gz'
    sha1 '107e1bcc4b8fd60821a7c8dd99f0c7c37cf5619c'
  end

  head 'https://github.com/vgough/encfs.git'

  bottle do
    sha256 "4d79b4413c12e591e6de81a4ba3624f31b0937da17974fc63ac81cc82d08d6aa" => :mavericks
    sha256 "a63c7df51551d64eee771f7f6ab712367e951bad1a5933b423256ff81eddf0b2" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext' => :build
  depends_on 'boost'
  depends_on 'rlog'
  depends_on 'openssl'
  depends_on :osxfuse
  depends_on 'xz'
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "-f", "Makefile.dist"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end

  test do
    if Pathname.new("/Library/Filesystems/osxfusefs.fs/Support/load_osxfusefs").exist?
      (testpath/"print-password").write("#!/bin/sh\necho password")
      chmod 0755, testpath/"print-password"
      system "yes | #{bin}/encfs --standard --extpass=#{testpath}/print-password #{testpath}/a #{testpath}/b"
      system "umount", testpath/"b"
    end
  end
end


