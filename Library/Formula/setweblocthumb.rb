require 'formula'

class Setweblocthumb < Formula
  homepage 'http://hasseg.org/setWeblocThumb'
  url 'https://github.com/ali-rantakari/setWeblocThumb/archive/v1.0.0.tar.gz'
  sha1 '2837bc2a4a8c1011c95c05ee45d6232c84552eca'

  def install
    system "make"
    bin.install "setWeblocThumb"
  end

  def caveats; <<-EOS.undent
    You can use Launch Agents to watch a particular folder and have setWeblocThumb automatically operate periodically on that folder.

    setWeblocThumb -a <path>

      Create and automatically load a user-specific launch agent for <path> that
      runs this program each time the contents of <path> change

    setWeblocThumb -w

      List paths that are being watched by user-specific launch agents

    setWeblocThumb is installed as written in all prior cases, but can be invoked in any case, e.g. setweblocthumb, SETWEBLOCTHUMB, setWeblocThumb, etc.
    EOS
  end

  test do
    system "#{bin}/setWeblocThumb"
  end
end
