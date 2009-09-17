require 'brewkit'

class Pwsafe <Formula
  @url='http://downloads.sourceforge.net/project/pwsafe/pwsafe/0.2.0/pwsafe-0.2.0.tar.gz'
  @homepage='http://nsd.dyndns.org/pwsafe/'
  @md5='4bb36538a2772ecbf1a542bc7d4746c0'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
