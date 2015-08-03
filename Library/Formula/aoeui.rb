class Aoeui < Formula
  desc "Lightweight text editor optimized for Dvorak and QWERTY keyboards"
  homepage "http://aoeui.googlecode.com/"
  url "https://aoeui.googlecode.com/files/aoeui-1.6.tgz"
  sha256 "0655c3ca945b75b1204c5f25722ac0a07e89dd44bbf33aca068e918e9ef2a825"
  head "http://aoeui.googlecode.com/svn/trunk/"

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
