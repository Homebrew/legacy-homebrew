require 'formula'

class Chapel < Formula
  homepage 'http://chapel.cray.com/'
  url 'http://downloads.sourceforge.net/project/chapel/chapel/1.6.0/chapel-1.6.0.tar.gz'
  # version '1.6.0'
  sha1 'a6b1a38c3aa01190c8eab8452dc6429a832c49eb'

  def install
    ENV.j1  # if your formula's build system can't parallelize
    system "make all"
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    Setup your shell:
      if using bash, just add to ~/.bash_profile

    cd /usr/local/Cellar/chapel/1.6.0 && source ./util/setchplenv.bash

    For other shells see other shell scripts in /usr/local/Cellar/chapel/1.6.0/util
    EOS
  end

end
