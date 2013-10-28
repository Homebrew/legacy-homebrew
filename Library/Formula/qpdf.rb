require 'formula'

class Qpdf < Formula
  homepage 'http://qpdf.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/qpdf/qpdf/5.0.1/qpdf-5.0.1.tar.gz'
  sha1 '41a4bd91bfbc2d3585ea229b53bfd1183186b1b3'

  depends_on 'pcre'

  # Fix building using Clang and libc++
  # https://github.com/qpdf/qpdf/issues/19
  def patches
    'https://github.com/qpdf/qpdf/pull/21.diff'
  end

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
