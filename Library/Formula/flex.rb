require 'formula'

class Flex < Formula
  homepage 'http://flex.sourceforge.net'
  url 'http://downloads.sourceforge.net/flex/flex-2.5.37.tar.bz2'
  sha1 'db4b140f2aff34c6197cab919828cc4146aae218'

  keg_only :provided_by_osx, 'Some formulae require a newer version of flex.'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system 'make install'
  end
end
