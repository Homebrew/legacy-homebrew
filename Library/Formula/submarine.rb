require 'formula'

class Submarine < Formula
  homepage 'https://github.com/rastersoft/submarine'
  url 'https://github.com/rastersoft/submarine/archive/0.1.4.tar.gz'
  sha1 '9ecbdfd25c299839a55ec7878b585525b03f2e8b'
  head 'https://github.com/rastersoft/submarine.git'

  depends_on 'glib'
  depends_on 'libgee'
  depends_on 'libsoup'
  depends_on 'libarchive'
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build
  depends_on 'vala' => :build


  def install
    # Because configure is looking for libgee-0.6 which provided
    # pkg-config viled numbered 1.0.
    #
    # See https://github.com/rastersoft/submarine/pull/1
    inreplace 'configure.ac', 'gee-1.0', 'gee-0.8'
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/submarine", "--help"
  end
end
