require 'formula'

class Rock < Formula
  homepage 'http://ooc-lang.org'
  url 'https://github.com/nddrylliog/rock/archive/v0.9.6.tar.gz'
  sha1 'c92bda98b94026fd493b1b0e46db62dc69459848'

  head 'https://github.com/nddrylliog/rock.git'

  depends_on 'bdw-gc'

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
