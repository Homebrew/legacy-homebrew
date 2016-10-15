require 'formula'

class GnuApl < Formula
  homepage 'http://www.gnu.org/software/apl/'
  url 'http://ftpmirror.gnu.org/apl/apl-1.1.tar.gz'
  sha1 'de5071372b64a6d6921141cbbc3555e3b40da7af'

  # GNU Readline is required; libedit won't work.
  depends_on 'readline'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/apl", "--version"
  end
end
