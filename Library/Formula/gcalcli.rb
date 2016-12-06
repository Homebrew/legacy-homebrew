require 'formula'

class Gcalcli < Formula
  homepage 'https://github.com/insanum/gcalcli'
  url 'https://github.com/insanum/gcalcli/archive/master.zip'
  sha1 '4aa4701349af60662506ad974da4cb79e6ee3abb'
  version '3.1'

  def install
    ENV.j1
    bin.install 'gcalcli'
  end

  def caveats; <<-EOS.undent
      Read gcalcli --help to get started!
      EOS
  end
end
