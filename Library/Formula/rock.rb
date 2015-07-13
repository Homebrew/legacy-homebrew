class Rock < Formula
  desc "ooc compiler written in ooc"
  homepage "https://ooc-lang.org/"
  url "https://github.com/fasterthanlime/rock/archive/v0.9.10.tar.gz"
  sha256 "39ac190ee457b2ea3c650973899bcf8930daab5b9e7e069eb1bc437a08e8b6e8"

  head "https://github.com/fasterthanlime/rock.git"

  bottle do
    cellar :any
    sha256 "3f95d26a49ed30031fd77e9d0e439a6366947201dfc6fd1393ebe5e2924d13d8" => :yosemite
    sha256 "3236af05000a82c81e428244840ca8c2047ca9608b9855998aeb15a78fe1d9e5" => :mavericks
    sha256 "34308d7af495565e3b9bc274615e0e5412a3721fc538ce73f68d973b1cb23a6a" => :mountain_lion
  end

  depends_on "bdw-gc"

  def install
    # make rock using provided bootstrap
    ENV["OOC_LIBS"] = prefix
    system "make", "rescue"
    bin.install "bin/rock"
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
