class Fakeroot < Formula
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://mirrors.kernel.org/debian/pool/main/f/fakeroot/fakeroot_1.20.2.orig.tar.bz2"
  mirror "http://ftp.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.20.2.orig.tar.bz2"
  sha1 "367040df07043edb630942b21939e493f3fad888"

  # Compile is broken. https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=766649
  # Patches submitted upstream on 24/10/2014, but no reply from maintainer thus far.
  patch do
    url "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=0001-Implement-openat-2-wrapper-which-handles-optional-ar.patch;att=1;bug=766649"
    sha1 "9207619d6d8a55f25d50ba911bfa72f486911d81"
  end

  patch do
    url "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=0002-OS-X-10.10-introduced-id_t-int-in-gs-etpriority.patch;att=2;bug=766649"
    sha1 "a30907ffdcfe159c2ac6b3f829bd5b9a67188940"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "root", shell_output("#{bin}/fakeroot whoami").strip
  end
end
