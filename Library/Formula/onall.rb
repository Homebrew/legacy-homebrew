require 'formula'

class Onall < Formula
  homepage 'https://code.google.com/p/code-ticketmaster-com/wiki/Onall'
  # I'm rehosting the project with a patch for a sane return value on
  # --help, as well as not having to check out from subversion or git.
  url 'https://github.com/KB1JWQ/onall/archive/v2.11.tar.gz'
  sha1 '21abe3171f216700fcb218df5f9018f38587803e'

  def install
    bin.install 'onall'
  end

  test do
    system "#{bin}/onall", "--help"
  end

end
