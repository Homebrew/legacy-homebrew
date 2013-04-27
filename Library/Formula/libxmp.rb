require 'formula'

class Libxmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/libxmp/4.1.0/libxmp-4.1.0.tar.gz'
  sha1 '778df5d2bbbf49a454024753c07dca6fb60bfdf9'
  head 'git://git.code.sf.net/p/xmp/libxmp'

  depends_on :autoconf if build.head?

  def patches
    [
      # disables symbol versioning via alias, which compiler rejects:
      # "only weak aliases are supported in this configuration"
      "https://github.com/cmatsuoka/libxmp/commit/ca0ba5c9bba275b964e9a2b61e2c089ef26c4096.patch",
      # upstream patches for build failures due to strncat/strncpy macros;
      # can remove on next release
      "https://github.com/cmatsuoka/libxmp/commit/c1c58d926912299c41e7828d1d8954a0745da72c.patch",
      "https://github.com/cmatsuoka/libxmp/commit/d8483eb3d330455e42b118e54e0f88ef2acde56d.patch"
    ]
  end unless build.head?

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
