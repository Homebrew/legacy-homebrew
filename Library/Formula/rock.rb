require 'formula'

class Rock < Formula
  homepage 'http://ooc-lang.org'
  url 'https://github.com/nddrylliog/rock/archive/v0.9.9.tar.gz'
  sha1 '11d4a46320e2b538989354505e0a6ac4311b049f'

  head 'https://github.com/nddrylliog/rock.git'

  bottle do
    cellar :any
    sha1 "340f82221554850f6f448e8a419eb4076c29af70" => :mavericks
    sha1 "aeb288109b82299dae4d5149c58915cd1bb973af" => :mountain_lion
    sha1 "f5e7ac002051485e95874157bdca2ec606da13e0" => :lion
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
