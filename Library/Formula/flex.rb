require 'formula'

class Flex < Formula
  homepage 'http://flex.sourceforge.net'
  url 'https://downloads.sourceforge.net/flex/flex-2.5.37.tar.bz2'
  sha1 'db4b140f2aff34c6197cab919828cc4146aae218'

  bottle do
    sha1 "ea93eb8bc57868e9e4cfe50ab39fc3c7f2ccbb58" => :mavericks
    sha1 "ec164496e9eec22a920e935f57dea4bc16fa4afd" => :mountain_lion
    sha1 "654c2f9978368c6f761720f7fa1a29127bf9deea" => :lion
  end

  keg_only :provided_by_osx, 'Some formulae require a newer version of flex.'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system 'make install'
  end
end
