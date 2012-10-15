require 'formula'

class PerforceServer < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86_64/p4d'
    version '2012.1.490371-x86_64'
    sha1 'ac74dcfc2cd42e07f111d28b9b79f5bc4ae41e08'
  else
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86/p4d'
    version '2012.1.490371-x86'
    sha1 '89380e86bede6cc84e29a9d8283931eb7e5fa2e6'
  end

  def install
    bin.install 'p4d'
  end
end
