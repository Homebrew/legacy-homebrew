require 'formula'

class Rock < Formula
  homepage 'http://ooc-lang.org'
  url 'https://github.com/downloads/nddrylliog/rock/rock-0.9.3-source.tar.bz2'
  sha1 'ddc00c7298198962781fd28a2cc4c65f7fb9ccd2'
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
