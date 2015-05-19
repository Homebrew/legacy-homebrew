require 'formula'

class Nanomsg < Formula
  desc "Socket library in C"
  homepage 'http://nanomsg.org'
  url 'http://download.nanomsg.org/nanomsg-0.5-beta.tar.gz'
  sha1 '2826bf58fe29550777dbe610e12ed20d386a6974'

  bottle do
    cellar :any
    sha1 "3a645be193f896f1a3b4f8593c1554656abdc4c1" => :yosemite
    sha1 "874eb890390defb22b89cbf4303d218d384bd9b6" => :mavericks
    sha1 "66775cd465f4351a92cb05824e279ed597b90270" => :mountain_lion
  end

  head do
    url 'https://github.com/nanomsg/nanomsg.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option 'with-test', 'Verify the build with make check'
  option 'with-doc', 'Install man pages'
  option 'without-nanocat', 'Do not install nanocat tool'
  option 'with-debug', 'Compile with debug symbols'

  depends_on 'pkg-config' => :build

  if build.with? 'doc'
    depends_on 'asciidoc' => :build
    depends_on 'xmlto' => :build
  end

  def install
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog" if build.with? 'doc'

    system './autogen.sh' if build.head?

    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--disable-nanocat" if build.without? 'nanocat'
    args << "--enable-debug" if build.with? 'debug'
    args << "--enable-doc" if build.with? 'doc'

    system './configure', *args
    system 'make'
    system 'make', '-j1', 'check' if build.with? 'test'
    system 'make', 'install'
  end
end
