require 'formula'

class Npm <Formula
  url 'http://github.com/isaacs/npm/tarball/v0.1.13'
  head 'git://github.com/isaacs/npm.git'
  homepage 'http://github.com/isaacs/npm'
  md5 'cd4d4b58781355c010e2bbc400f25d93'

  depends_on 'node'

  def install
    # install all the required libs in libexec
    libexec.install Dir["*"]

    # install man pages
    man1.mkpath
    ln_s libexec+'man/npm.1', man1+'npm.1'

    # install the wrapper executable
    (bin+"npm").write executable
  end

  def caveats
    <<-EOS.undent
      npm is still under heavy development.
      Hopefully this package will help keep people up to date.
    EOS
  end

  def executable
    <<-EOS
#!/bin/sh
exec "#{libexec}/cli.js" "$@"
    EOS
  end
end
