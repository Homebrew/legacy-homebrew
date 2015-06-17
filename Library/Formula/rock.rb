require 'formula'

class Rock < Formula
  desc "ooc compiler written in ooc"
  homepage 'http://ooc-lang.org'
  url 'https://github.com/nddrylliog/rock/archive/v0.9.9.tar.gz'
  sha1 '11d4a46320e2b538989354505e0a6ac4311b049f'

  head 'https://github.com/nddrylliog/rock.git'

  bottle do
    cellar :any
    revision 1
    sha1 "8d8dc4f1c1507758216242a7dabea4344395712c" => :mavericks
    sha1 "74e99570d8e3b12cba3da7c83b4a07dbe1da0f6b" => :mountain_lion
    sha1 "d6d12b185228741f0a34b7a4836413092c5968a5" => :lion
  end

  depends_on 'bdw-gc'

  def install
      # make rock using provided bootstrap
      ENV['OOC_LIBS'] = prefix
      system "make rescue"
      bin.install 'bin/rock'
      man1.install "docs/rock.1"

      # install misc authorship files & rock binary in place
      # copy the sdk, libs and docs
      prefix.install "rock.use", "sdk.use", "sdk-net.use", "sdk-dynlib.use", "pcre.use", "sdk", "README.md"
      doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.ooc").write <<-EOS.undent
      import os/Time
      Time dateTime() println()
    EOS
    system "#{bin}/rock", "--run", "hello.ooc"
  end
end
