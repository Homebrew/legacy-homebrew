require 'formula'

class PerforceServer <Formula
  url 'http://filehost.perforce.com/perforce/r10.1/bin.darwin80u/p4d'
  homepage 'http://www.perforce.com/'
  md5 'dd2f6de1b1a57a70838379d425606896'
  version '2010.1.260003'

  def install
    bin.install 'p4d'
  end
end
