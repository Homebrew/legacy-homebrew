require 'formula'

class Asterisk < Formula
  url 'http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-1.8.3.2.tar.gz'
  homepage 'http://www.asterisk.org/'
  md5 '0bee03f4498a6081146a579b51130633'

  skip_clean :all # Or modules won't load

  def options
    [['--with-sample-config', "Install the sample config files.  NOTE. Without this, you won't have any config file."]]
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--localstatedir=#{var}", "--sysconfdir=#{etc}"
    system "make"
    system "make install"
    system "make samples" if ARGV.include? '--with-sample-config'
  end
end
