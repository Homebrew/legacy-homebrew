require 'formula'

class Rock < Formula
  homepage 'http://ooc-lang.org'
  url 'https://github.com/downloads/nddrylliog/rock/rock-0.9.4-source.tar.bz2'
  sha1 '9bba27995c90d029e3c5dc8b9591d819d8ce2531'

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
