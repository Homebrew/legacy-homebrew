require 'formula'

class Dmd < Formula
  homepage 'http://dlang.org'
  url 'https://github.com/D-Programming-Language/dmd/archive/v2.064.2.tar.gz'
  sha1 '8f88af77aab4c206841d93d7f4cfd399cbe3fdd6'

  resource 'druntime' do
    url 'https://github.com/D-Programming-Language/druntime/archive/v2.064.2.tar.gz'
    sha1 '42bc0f252bbb0c71de6789bdf2697b5daf41dd43'
  end

  resource 'phobos' do
    url 'https://github.com/D-Programming-Language/phobos/archive/v2.064.2.tar.gz'
    sha1 'e39489a6c7c60c947559a084cc7619e373d3c464'
  end

  resource 'tools' do
    url 'https://github.com/D-Programming-Language/tools/archive/v2.064.2.tar.gz'
    sha1 '590dfb8cd4b6fea74d03ddf230ec2734e7c71c99'
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::bits}", "-f", "posix.mak"]

    system "make", "install", "TARGET_CPU=X86", "RELEASE=1", *make_args

    share.install prefix/'man'

    rm bin/'dmd.conf'

    make_args.unshift "DMD=#{bin}/dmd"

    resource('druntime').stage do
      system "make", "install", *make_args
    end

    resource('phobos').stage do
      system "make", "install", "DRUNTIME_PATH=#{prefix}", "VERSION=#{buildpath}/VERSION", *make_args
    end

    (bin/'dmd.conf').open('w+') do |f|
      f.puts "[Environment]"
      f.puts "DFLAGS=-I#{prefix}/import -L-L#{lib}"
    end

    resource('tools').stage do
      inreplace 'posix.mak' do |s|
        s.gsub! 'install: $(TOOLS) $(CURL_TOOLS)', 'install: $(TOOLS)'
        #Remove on next release
        s.gsub! 'install -t $(DESTDIR)$(PREFIX) $(^)', 'cp $^ $(INSTALL_DIR)/bin'
      end
      system "make", "install", *make_args
    end
  end

  test do
    system "dmd", "#{prefix}/samples/hello.d"
    system "./hello"
  end
end
