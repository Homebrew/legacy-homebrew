require 'formula'

class Moreutils < Formula
  homepage 'http://packages.debian.org/unstable/utils/moreutils'
  url 'http://mirrors.kernel.org/debian/pool/main/m/moreutils/moreutils_0.48.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/m/moreutils/moreutils_0.48.tar.gz'
  sha1 '023893342ce68d877f4a8eb14142bbd7fd3706ee'

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
