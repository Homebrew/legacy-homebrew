require 'formula'

class DansGdalScripts < Formula
  homepage 'https://github.com/gina-alaska/dans-gdal-scripts/'
  url 'https://github.com/dayne/dans-gdal-scripts/archive/v0.22.zip'
  sha1 '021d8dfa2b636c20be4e91dea69fefda1618b53e'
  version '0.22'

  depends_on 'automake'
  depends_on 'autoconf'
  depends_on 'boost'
  depends_on 'gdal'
  depends_on :libtool

  def install
    (buildpath/'m4').mkpath # or autogen fails
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    `gdal_list_corners`.split[0] == "Usage:" # ghetto test but it is a start
  end
end
