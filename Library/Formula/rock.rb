require 'formula'

class Rock < Formula
  homepage 'http://ooc-lang.org'
  url 'https://github.com/downloads/nddrylliog/rock/rock-0.9.3-source.tar.bz2'
  md5 'ce877bcc72b0a78ba088a1826d8c12b3'
  head 'https://github.com/nddrylliog/rock.git'

  def install
      # make rock using provided bootstrap
      system "make"
      bin.install 'bin/rock'
      man1.install "docs/rock.1"

      # install misc authorship files & rock binary in place
      # copy the sdk, libs and docs
      prefix.install "rock.use", 'README.md', "sdk", "libs", "docs"
  end
end
