require 'formula'

class Phpsh <Formula
  head 'git://github.com/facebook/phpsh.git'
  homepage 'http://www.phpsh.org/'

  def install
    system "python", "setup.py", "build", "--build-scripts=build/scripts"
    libexec.install Dir["build/lib/*"]
    libexec.install "build/scripts/dbgp-phpsh.py"
    libexec.install "build/scripts/phpsh" => "phpsh.py"
    bin.mkpath
    ln_s libexec+'phpsh.py', bin+'phpsh'
    man1.install "src/doc/phpsh.1"
  end
end
