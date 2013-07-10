require 'formula'

# Force use of SSL3
# https://github.com/mxcl/homebrew/issues/20991
class CurlSSL3DownloadStrategy < CurlDownloadStrategy
  def _fetch
    curl @url, '-3', '-C', downloaded_size, '-o', @temporary_path
  end
end

class EasyTag < Formula
  homepage 'http://projects.gnome.org/easytag'
  url 'https://download.gnome.org/sources/easytag/2.1/easytag-2.1.8.tar.xz',
    :using => CurlSSL3DownloadStrategy
  sha1 '7f9246b0eab97ed9739daf5356c89925634241a2'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'libid3tag'
  depends_on 'id3lib'
  depends_on 'libvorbis' => :optional
  depends_on 'speex' => :optional
  depends_on 'mp4v2' => :optional
  depends_on 'wavpack' => :optional

  depends_on 'flac' => :optional
  depends_on 'libogg' if build.with? 'flac'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # make install fails in parallel
    system "make install"
  end
end
