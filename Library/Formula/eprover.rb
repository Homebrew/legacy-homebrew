require 'formula'

class Eprover < Formula
  homepage 'http://www4.informatik.tu-muenchen.de/~schulz/E/E.html'
  url 'http://www4.in.tum.de/~schulz/WORK/E_DOWNLOAD/V_1.8/E.tgz'
  version '1.8'
  sha1 '43cec71bc1187798352036b550794a4d03137f87'

  def install
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make install"
  end

  test do
    system "#{bin}/eproof"
  end
end
