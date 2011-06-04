require 'formula'

class Direnv < Formula
  homepage 'https://github.com/zimbatm/direnv'
  url 'https://github.com/zimbatm/direnv/tarball/v0.1.62'
  md5 '28eb1aa6b66f34c1a1990634bea02561'

  head 'git://github.com/zimbatm/direnv.git'

  def install
    # App and support files live in libexec
    libexec.install Dir['libexec/*']
    # Symlink into bin
    bin.mkpath
    ln_s libexec+'direnv', bin+'direnv'
  end
end
