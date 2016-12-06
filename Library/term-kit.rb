require 'formula'

class TermKit < Formula
  homepage 'http://github.com/unconed/TermKit'
  version 'alpha'
  md5 '500280b37edb7a470bd4ea29a0169b4b'
  head 'git://github.com/unconed/TermKit.git', :branch => 'master'

  depends_on 'node'

  def install
    system "cd Build; unzip TermKit.zip; mv TermKit.app .."
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    TermKit.app installed to:
      #{prefix}

    To link TermKit.app into ~/Applications using homebrew:
        brew linkapps
    or manually:
        sudo ln -s #{prefix}/TermKit.app /Applications

    You'll need to have npm and node-mime installed:
        curl http://npmjs.org/install.sh | sh
        npm install mime

    In order for TermKit.app to run, you must start the nodekit daemon first:
        cd #{prefix}/Node; node nodekit.js
    EOS
  end
end
