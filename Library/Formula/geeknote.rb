require 'formula'

class Geeknote < Formula
  homepage 'http://www.geeknote.me'
  url 'https://github.com/VitaliyRodnenko/geeknote/tarball/master'
  version '0.1'
  sha1 ''

  def install
    prefix.install Dir['*']
    system "echo python #{prefix}/geeknote.py > #{prefix}/geeknote"
    (prefix+"geeknote").chmod 0755
    bin.install_symlink "#{prefix}/geeknote" => 'geeknote'
  end

  def test
    system "true"
  end
end
