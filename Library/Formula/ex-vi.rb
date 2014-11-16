require 'formula'

class ExVi < Formula
  homepage 'http://ex-vi.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ex-vi/ex-vi/050325/ex-050325.tar.bz2'
  sha1 '573501d15fa4be59f136641957c7f893e86bac82'

  conflicts_with 'vim',
    :because => 'ex-vi and vim both install bin/ex and bin/view'

  def install
    system "make", "install", "INSTALL=/usr/bin/install",
                              "PREFIX=#{prefix}",
                              "PRESERVEDIR=/var/tmp/vi.recover",
                              "TERMLIB=ncurses"
  end
end
