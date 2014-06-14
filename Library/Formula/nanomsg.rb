require 'formula'

class Nanomsg < Formula
  homepage 'http://nanomsg.org'
  url 'http://download.nanomsg.org/nanomsg-0.4-beta.tar.gz'
  sha1 'a511f19f8574875e8e43f7ba27f7951f67fbe161'

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

  depends_on 'pkg-config'=> :build

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
