require 'formula'

class Moreutils < Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.47.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.47.tar.gz'
  sha1 '0459608fdb37bc59605d7a476717693afd133e00'

  conflicts_with 'parallel',
    :because => "both install a 'parallel' executable."

  conflicts_with 'task-spooler',
    :because => "both install a 'ts' executable."

  def install
    # "make all" will try to build the man pages, which requires Docbook
    scripts = %w{vidir vipe ts combine zrun chronic}
    bins = %w{isutf8 ifne pee sponge mispipe lckdo parallel errno}
    system "make", *bins
    bin.install scripts + bins
  end
end
