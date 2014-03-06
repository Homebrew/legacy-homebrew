require 'formula'

class Freeipmi < Formula
  homepage 'http://www.gnu.org/software/freeipmi/'
  url 'http://ftpmirror.gnu.org/freeipmi/freeipmi-1.4.1.tar.gz'
  sha1 'd59fd66e6fe9a58437d55a4bdd96ee431a8348e4'
  revision 1

  bottle do
    sha1 "b98405e8318c8dd990f598b769d1e6a155e3c2a3" => :mavericks
    sha1 "15d32bf5d1f7f54240fba3012b2222ae1e70e209" => :mountain_lion
    sha1 "695a73d4e94af49e9a02bf103d16a3e5aa194a51" => :lion
  end

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
