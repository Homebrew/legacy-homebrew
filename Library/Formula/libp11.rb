require 'formula'

class Libp11 < Formula
  homepage 'https://github.com/OpenSC/libp11/wiki'
  url 'http://sourceforge.net/projects/opensc/files/libp11/libp11-0.2.8.tar.gz'
  sha1 '2d1f6dc4200038f55a0cb7e22858f93e484b0724'

  head 'https://github.com/OpenSC/libp11.git'

  depends_on 'pkg-config' => :build
  depends_on :libltdl

  depends_on :automake if build.head?

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
