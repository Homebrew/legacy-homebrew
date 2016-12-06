require 'formula'

class FlowTools < Formula
  url 'ftp://ftp.eng.oar.net/pub/flow-tools/flow-tools-0.68.tar.gz'
  homepage 'http://www.splintered.net/sw/flow-tools/'
  md5 'c9e0a8b53c79611b6bffcb9d510a5a38'
  def patches
    # Fixes compilation issues with GCC4.0+
    "https://raw.github.com/gist/1105776/814312686748b059d7b56f9266c686bc56015ca1/gistfile1.txt"
  end
  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end