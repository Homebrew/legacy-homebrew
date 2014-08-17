require 'formula'

class Rock < Formula
  homepage 'http://ooc-lang.org'
  url 'https://github.com/nddrylliog/rock/archive/v0.9.9.tar.gz'
  sha1 '11d4a46320e2b538989354505e0a6ac4311b049f'

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
      prefix.install "rock.use", 'README.md', "sdk", "docs"
  end
end
