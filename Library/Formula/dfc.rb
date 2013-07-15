require 'formula'

class Dfc < Formula
  homepage 'http://projects.gw-computing.net/projects/dfc'
  url 'http://projects.gw-computing.net/attachments/download/42/dfc-2.5.0.tar.gz'
  sha1 '134477da818ddec47bc82a3155308e287863d46f'

  def install
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"
  end
end
