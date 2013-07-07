require 'formula'

class Scrotwm < Formula
  homepage 'http://opensource.conformal.com/wiki/scrotwm'
  url 'http://opensource.conformal.com/snapshots/scrotwm/scrotwm-0.9.34.tgz'
  sha1 '9e943883ea55048487fe59ed09b8a84467a81593'

  depends_on :x11

  def install
    cd "osx" do
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  def caveats; <<-EOS
    To use scrotwm as your X window manager, create or edit  ~/.xinitrc and add:
      exec #{HOMEBREW_PREFIX}/bin/scrotwm
    EOS
  end
end
