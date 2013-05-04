require 'formula'

class Rock < Formula
  homepage 'http://ooc-lang.org'
  url 'https://github.com/nddrylliog/rock/archive/v0.9.6.tar.gz'
  sha1 '5d1cc6f194f76a2b0a8c0ed0b48fcd0e26e75c95'

  head 'https://github.com/nddrylliog/rock.git'

  def install
      # make rock using provided bootstrap
      system "make rescue"
      bin.install 'bin/rock'
      man1.install "docs/rock.1"

      # install misc authorship files & rock binary in place
      # copy the sdk, libs and docs
      prefix.install "rock.use", 'README.md', "sdk", "libs", "docs"
  end
end
