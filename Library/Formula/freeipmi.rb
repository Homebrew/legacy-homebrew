require 'formula'

class Freeipmi < Formula
  homepage 'http://www.gnu.org/software/freeipmi/'
  url 'http://ftpmirror.gnu.org/freeipmi/freeipmi-1.4.1.tar.gz'
  sha1 'd59fd66e6fe9a58437d55a4bdd96ee431a8348e4'

  depends_on 'argp-standalone'
  depends_on 'libgcrypt'

  def install
    system './configure', "--prefix=#{prefix}"
    # This is a big hammer to disable building the man pages
    # It breaks under homebrew's build system and I'm not sure why
    inreplace "man/Makefile", "install: install-am", "install:"
    system 'make', 'install'
  end

  test do
    system "#{sbin}/ipmi-fru", "--version"
  end

end
