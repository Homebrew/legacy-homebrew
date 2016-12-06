require 'formula'

class AdvancedCopy < Formula
  homepage 'http://www.beatex.org/web/advancedcopy.html'

  url    'http://ftpmirror.gnu.org/coreutils/coreutils-8.21.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/coreutils/coreutils-8.21.tar.xz'
  sha256 'adaa44bdab3fa5eb352e80d8a31fdbf957b78653d0c2cd30d63e161444288e18'

  depends_on 'xz' => :build

  def patches
    "http://zwicke.org/web/advcopy/advcpmv-0.5-8.21.patch"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--program-prefix=advanced_",
                          "--without-gmp"

    system "make install"

    # only keep advanced_cp and advanced_mv
    rm_f Dir["#{bin}/advanced_*"]  - ["#{bin}/advanced_cp",    "#{bin}/advanced_mv"]
    rm_f Dir["#{man1}/advanced_*"] - ["#{man1}/advanced_cp.1", "#{man1}/advanced_mv.1"]
  end

end
