require 'formula'

class Texi2html < Formula
  homepage 'http://www.nongnu.org/texi2html/'
  url 'http://download.savannah.gnu.org/releases/texi2html/texi2html-1.82.tar.gz'
  sha1 'e7bbe1197147566250abd5c456b94c8e37e0a81f'

  bottle do
    sha1 "ee0099661cd70c241925a3e4209331b0a4a74758" => :mavericks
    sha1 "d37da7d38ccd13121a94855bae7b9e93a10fc832" => :mountain_lion
    sha1 "353a17e497893b956b3a6afc8b47911a70f4a537" => :lion
  end

  keg_only :provided_pre_mountain_lion

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--mandir=#{man}", "--infodir=#{info}"
    system "make install"
  end

  test do
    system "#{bin}/texi2html", "--help"
  end
end
