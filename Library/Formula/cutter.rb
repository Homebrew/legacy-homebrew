require 'formula'

class Cutter < Formula
  homepage 'http://cutter.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cutter/cutter/1.2.0/cutter-1.2.0.tar.gz'
  md5 '509963983083be65e729ea646f3f8360'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'gettext'

  def patches
    # see https://github.com/mxcl/homebrew/pull/11163#issuecomment-4689357
    "https://github.com/clear-code/cutter/commit/46f985153f465ae22ce8acdde5ec95c3d4361c83.diff"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
           "--disable-glibtest", "--disable-goffice",
           "--disable-gstreamer", "--disable-libsoup"
    system "make"
    system "make install"
  end
end
