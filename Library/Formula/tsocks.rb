require 'formula'

class Tsocks <Formula
  url 'http://downloads.sourceforge.net/project/tsocks/tsocks/1.8%20beta%205/tsocks-1.8beta5.tar.gz'
  homepage 'http://tsocks.sourceforge.net/'
  version '1.8beta5'
  md5 '51caefd77e5d440d0bbd6443db4fc0f8'
  sha1 '489f88c5df999ba21b27cdaa7836d9426d062aec'

  def patches
    { :p0 => 'https://gist.github.com/raw/822588/da08fa2cb067935584cf87d6e104f2f949682b38/tsocks.patch' }
  end

  def install
    system 'autoconf'
    system './configure', '--disable-debug', "--prefix=#{prefix}", "--libdir=#{lib}", "--with-conf=#{etc}/tsocks.conf"

    system 'make'
    system 'make install'
  end
end
