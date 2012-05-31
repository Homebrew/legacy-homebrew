require 'formula'

# Include a private copy of this Python app
# so we don't have to worry about clashing dependencies.
class Pygments < Formula
  url 'http://pypi.python.org/packages/source/P/Pygments/Pygments-1.3.1.tar.gz'
  homepage 'http://pygments.org/'
  md5 '54be67c04834f13d7e255e1797d629a5'
end

class Shocco < Formula
  homepage 'http://rtomayko.github.com/shocco/'
  head 'https://github.com/rtomayko/shocco.git',
          :commit => '06ab9ecebd713a1a6ae695b190a775ca6dfeb7b2'

  depends_on 'markdown'

  def install
    Pygments.new.brew { libexec.install 'pygmentize','pygments' }

    # Brew into libexec, along with Pygments
    system "./configure", "PYGMENTIZE=#{libexec}/pygmentize", "--prefix=#{libexec}"
    system "make"
    libexec.install "shocco"

    # Link the script into bin
    bin.install_symlink libexec+"shocco"
  end

  def caveats
    <<-EOS.undent
      You may also want to install browser:
        brew install browser
        shocco `which shocco` | browser
    EOS
  end
end
