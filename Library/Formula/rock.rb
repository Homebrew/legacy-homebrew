require 'formula'

class Rock < Formula
  url 'https://github.com/downloads/nddrylliog/rock/rock-0.9.2-source.tar.bz2'
  homepage 'http://ooc-lang.org'
  md5 '8e3afbd3e31b977930692ee781e84529'
  head 'https://github.com/nddrylliog/rock.git'

  fails_with_llvm "Fails in function 'AO_test_and_set_full' with an 'unsupported inline asm' error"

  def install
      # make rock using provided bootstrap
      system "make"
      bin.install 'bin/rock'
      man1.install "docs/rock.1"

      # install misc authorship files & rock binary in place
      # copy the sdk, libs and docs
      prefix.install ['rock.use', 'README.md', "sdk", "libs", "docs"]
  end
end
