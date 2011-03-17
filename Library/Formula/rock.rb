require 'formula'

class Rock < Formula
  url 'https://github.com/downloads/nddrylliog/rock/rock-0.9.1-source.tar.bz2'
  homepage 'http://ooc-lang.org'
  md5 '66c35a7d9271732790f08a4839cee287'
  head 'git://github.com/nddrylliog/rock.git'

  def install
      # make rock using provided bootstrap
      system "make"
      bin.install 'bin/rock'
      man1.install "docs/rock.1"

      # install misc authorship files & rock binary in place
      # copy the sdk, libs and docs
      prefix.install ['rock.use', 'README.rst', "sdk", "libs", "docs"]
  end
end
