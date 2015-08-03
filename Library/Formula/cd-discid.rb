class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "http://linukz.org/cd-discid.shtml"
  url "http://linukz.org/download/cd-discid-1.1.tar.gz"
  sha256 "5d28ea26947ea364edfcd1af617d369fad92cb7b1944faa971d66cfbff627d69"

  patch :p0 do
    url "https://trac.macports.org/export/70630/trunk/dports/audio/cd-discid/files/patch-cd-discid.c.diff"
    sha256 "45719b39bf70ee6d247027102dfd76ccdda10cb40c047ce25e5e0d77218cbf5b"
  end

  def install
    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end
end
