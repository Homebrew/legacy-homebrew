require 'formula'

class Npm <Formula
  url 'http://github.com/isaacs/npm/tarball/v0.1.17'
  head 'git://github.com/isaacs/npm.git'
  homepage 'http://github.com/isaacs/npm'
  md5 '0c5b90e2d0bd20c7b1d5a7ab90a835b3'

  depends_on 'node'

  def install
    # install all the required libs in libexec
    libexec.install %w[cli.js npm.js package.json doc lib man scripts]

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
