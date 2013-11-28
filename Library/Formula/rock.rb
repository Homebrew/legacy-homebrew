require 'formula'

class Rock < Formula
  homepage 'http://ooc-lang.org'
  url 'https://github.com/nddrylliog/rock/archive/v0.9.8.tar.gz'
  sha1 'e9c7f2352d53351b60485b27c70858a0ad5cddb3'

  head 'https://github.com/nddrylliog/rock.git'

  depends_on 'bdw-gc'

  def install
      # make rock using provided bootstrap
      ENV['OOC_LIBS'] = prefix
      system "make rescue"
      bin.install 'bin/rock'
      man1.install "docs/rock.1"

      # install misc authorship files & rock binary in place
      # copy the sdk, libs and docs
      prefix.install "rock.use", 'README.md', "sdk", "libs", "docs"
  end
end
