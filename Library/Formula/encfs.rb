require 'formula'

class Encfs < Formula
  homepage 'https://vgough.github.io/encfs/'

  stable do
    url 'https://github.com/vgough/encfs/archive/v1.8.tar.gz'
    sha1 'f3723aa7ba64ad3fc6087dba6c26bf6d54762085'
  end

  head 'https://github.com/vgough/encfs.git'

  bottle do
    sha256 "a9014044ed57522f70e9b90d52212ce08775ebd6c00411481947984197aefa1e" => :mavericks
    sha256 "b577b5a48c9bb5af3a2a02aff3575048c02049c91fb6fc63dd5f5182a0ad4a2e" => :mountain_lion
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


