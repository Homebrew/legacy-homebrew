require 'formula'

class Direnv < Formula
  homepage 'https://github.com/zimbatm/direnv'
  url 'https://github.com/zimbatm/direnv/tarball/v0.1.65'
  md5 'fbcedf4ddd5ae2e2fa1760a4ef4280c6'

  head 'https://github.com/zimbatm/direnv.git'

  def install
    # App and support files live in libexec
    libexec.install Dir['libexec/*']
    # Symlink into bin
    bin.mkpath
    ln_s libexec+'direnv', bin+'direnv'
  end
end
