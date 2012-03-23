require 'formula'

class Cutter < Formula
  homepage 'http://cutter.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cutter/cutter/1.2.0/cutter-1.2.0.tar.gz'
  sha1 'f4da2693b3e449919b1e2aa34e5bd89623f4da07'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'gettext'

  # see https://github.com/mxcl/homebrew/pull/11163#issuecomment-4689357
  def patches
    "https://github.com/clear-code/cutter/commit/46f985153f465ae22ce8acdde5ec95c3d4361c83.diff"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make install"
  end
end
