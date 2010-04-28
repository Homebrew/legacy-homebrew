require 'formula'

# Include a private copy of this Python app
# so we don't have to worry about clashing dependencies.
class Pygments <Formula
  url 'http://pypi.python.org/packages/source/P/Pygments/Pygments-1.3.1.tar.gz'
  homepage 'http://pygments.org/'
  md5 '54be67c04834f13d7e255e1797d629a5'
end

# Build against Adam V's branch until the change is taken upstream
class Shocco <Formula
  head 'git://github.com/adamv/shocco.git', :branch => 'homebrew'
  homepage 'http://rtomayko.github.com/shocco/'

  depends_on 'markdown'

  def install
    Pygments.new.brew { libexec.install ['pygmentize','pygments'] }

    # Brew into libexec, along with Pygments
    system "./configure", "PYGMENTIZE=#{libexec}/pygmentize", "--prefix=#{libexec}"
    system "make"
    libexec.install "shocco"

    # Link the script into bin
    bin.mkpath
    ln_s libexec+"shocco", bin
  end

  def caveats
    <<-EOS.undent
      You may also want to install browser:
        brew install browser
        shocco `which shocco` | browser
    EOS
  end
end
