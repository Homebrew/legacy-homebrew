class Lsdvd < Formula
  desc "Read the content info of a DVD"
  homepage "http://sourceforge.net/projects/lsdvd"
  url "https://downloads.sourceforge.net/project/lsdvd/lsdvd/0.16%20-%20I%20hate%20James%20Blunt/lsdvd-0.16.tar.gz"
  sha256 "04ae3e2d823ed427e31d57f3677d28ec36bdf3bf984d35f7bdfab030d89b20f1"

  depends_on "libdvdread"
  depends_on "libdvdcss" => :optional

  patch :p0 do
    url "https://trac.macports.org/export/89276/trunk/dports/sysutils/lsdvd/files/patch-configure.diff"
    sha256 "3535ad1ad4c8fc2e49287190edcd89cd9d0679682ee94aca200252b9e1d80cd9"
  end

  patch :p0 do
    url "https://trac.macports.org/export/89276/trunk/dports/sysutils/lsdvd/files/patch-lsdvd_c.diff"
    sha256 "33a8f5876a0aa09532424066da71c64d18ab67154ecbebd66f81d98843937079"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
