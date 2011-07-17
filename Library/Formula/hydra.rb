require 'formula'

class Hydra < Formula
  url 'http://www.thc.org/releases/hydra-6.5-src.tar.gz'
  homepage 'http://www.thc.org/thc-hydra/'
  md5 '69a5afbbcbe3b1fdd31f9bf616480336'
  version "6.5+diff1"

  def patches
    # this patch is provided by the original authors of this software!
    # Quote from their website:
    #INFORMATION FOR VERSION 6.5:
    #        As the next version will be v7.0 which will get a rewrite of the main function,
    #        it will take some months for the next release.
    #        For important issues there will be diff patches provided here for 6.5
    #        PATCH: The following diff patches two issues in the http-form module:
    { :p0 => "http://www.thc.org/thc-hydra/hydra-6.5-fix.diff" }
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make all install"
    share.install prefix+"man" # Put man pages in correct place
  end
end
