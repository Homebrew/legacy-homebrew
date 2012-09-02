require 'formula'

class Schroedinger < Formula
  homepage 'http://diracvideo.org/'
  url 'http://diracvideo.org/download/schroedinger/schroedinger-1.0.11.tar.gz'
  md5 'da6af08e564ca1157348fb8d92efc891'

  head  'git://diracvideo.org/git/schroedinger.git'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'orc'

  def install
    system "autoreconf -i -f" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Disable compiling the test suite.
    # The test suite is known not to build against Orc 0.4.16 in Schroedinger 1.0.11.
    # A fix is in upstream, so test when pulling 1.0.12 if this is still needed. See:
    # http://www.mail-archive.com/schrodinger-devel@lists.sourceforge.net/msg00415.html

    inreplace "Makefile" do |s|
      s.change_make_var! "SUBDIRS", "schroedinger doc tools"
      s.change_make_var! "DIST_SUBDIRS", "schroedinger doc tools"
    end

    system "make install"
  end
end
