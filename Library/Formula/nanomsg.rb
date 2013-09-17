require 'formula'

class Nanomsg < Formula
  homepage 'http://nanomsg.org'
  url 'http://download.nanomsg.org/nanomsg-0.1-alpha.tar.gz'
  version '0.1-alpha'
  sha1 '6b2d9bd60bfcf9377befa006608598716e1c1fe9'

  head 'https://github.com/nanomsg/nanomsg.git'

  option 'with-test', 'Verify the build with make check'
  option 'with-doc', 'Install man pages' if build.head?
  option 'without-nanocat', 'Do not install nanocat tool' if build.head?

  if build.head? then
    depends_on :autoconf
    depends_on :automake
  end

  depends_on 'pkg-config'=> :build
  depends_on :libtool

  if build.with? 'doc' then
    depends_on 'asciidoc' => :build
    depends_on 'xmlto' => :build
  end

  def install
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog" if build.with? 'doc'

    system './autogen.sh' if build.head?

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--disable-nanocat" if build.without? 'nanocat'
    args << "--enable-doc" if build.with? 'doc'

    system './configure', *args
    system 'make'
    system 'make', '-j1', 'check' if build.with? 'test'
    system 'make', 'install'
  end
end
