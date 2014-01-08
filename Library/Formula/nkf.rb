require 'formula'

class Nkf < Formula
  homepage 'http://sourceforge.jp/projects/nkf/'
  url 'http://dl.sourceforge.jp/nkf/59912/nkf-2.1.3.tar.gz'
  sha1 'cb491b63b1a984dd6015e4946ac9579de132be6f'

  def install
    inreplace 'Makefile', "$(prefix)/man", "$(prefix)/share/man"
    system 'make', "CC=#{ENV.cc}"
    # Have to specify mkdir -p here since the intermediate directories
    # don't exist in an empty prefix
    system "make", "install", "prefix=#{prefix}", "MKDIR=mkdir -p"
  end
end
