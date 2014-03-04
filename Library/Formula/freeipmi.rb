require 'formula'

class Freeipmi < Formula
  homepage 'http://www.gnu.org/software/freeipmi/'
  url 'http://ftpmirror.gnu.org/freeipmi/freeipmi-1.4.1.tar.gz'
  sha1 'd59fd66e6fe9a58437d55a4bdd96ee431a8348e4'

  bottle do
    sha1 "352a236f1154284520b0e08da3c509ca9a6f816e" => :mavericks
    sha1 "a0c6f7d0aa29f2dcd87f28cb53c68e885ad3532a" => :mountain_lion
    sha1 "529f6c95ef5a2542bbc7fa3788d71c52a29894f7" => :lion
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
