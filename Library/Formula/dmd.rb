require 'formula'

class Dmd < Formula
  homepage 'http://dlang.org'
  url 'https://github.com/D-Programming-Language/dmd/archive/v2.065.0.tar.gz'
  sha1 '15f67e9b088d599c4091f1844676d107e873e850'

  bottle do
    sha1 "581cd8093ffe9fca493f06996e1d95e538fbb99e" => :mavericks
    sha1 "3dfec90ecfc970e05efea17d6f786a0a1fbbb322" => :mountain_lion
    sha1 "68d88b84a7f3407e867a83d093bf649f99830e23" => :lion
  end

  resource 'druntime' do
    url 'https://github.com/D-Programming-Language/druntime/archive/v2.065.0.tar.gz'
    sha1 '0118d9386b2d5f006381a5e4802f295132c8717b'
  end

  resource 'phobos' do
    url 'https://github.com/D-Programming-Language/phobos/archive/v2.065.0.tar.gz'
    sha1 '2af606451ee5d651fea91f252e09411714f779df'
  end

  resource 'tools' do
    url 'https://github.com/D-Programming-Language/tools/archive/v2.065.0.tar.gz'
    sha1 '54b5855599e64d0efbfc1cb21f1a31ef9939f8be'
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::bits}", "-f", "posix.mak"]

    system "make", "install", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "RELEASE=1", *make_args

    share.install prefix/'man'

    inreplace bin/'dmd.conf', "DFLAGS=-I%@P%/../../src/phobos -I%@P%/../../src/druntime/import -L-L%@P%/../lib",
                              "DFLAGS=-I#{prefix}/import -L-L#{lib}"

    etc.install bin/'dmd.conf'

    make_args.unshift "DMD=#{bin}/dmd"

    (buildpath/'druntime').install resource('druntime')
    (buildpath/'phobos').install resource('phobos')

    system "make", "-C", "druntime", "install", *make_args
    system "make", "-C", "phobos", "install", "VERSION=#{buildpath}/VERSION", *make_args

    resource('tools').stage do
      inreplace 'posix.mak', 'install: $(TOOLS) $(CURL_TOOLS)', 'install: $(TOOLS)'
      system "make", "install", *make_args
    end
  end

  test do
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
