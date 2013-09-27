require 'formula'

class Nanomsg < Formula
  homepage 'http://nanomsg.org'
  url 'http://download.nanomsg.org/nanomsg-0.2-alpha.tar.gz'
  version '0.2-alpha'
  sha1 'ecdc7189787f6b000e94f29c648db1f292d872ac'

  head do
    url 'https://github.com/nanomsg/nanomsg.git'

    depends_on :autoconf
    depends_on :automake
  end

  option 'with-test', 'Verify the build with make check'
  option 'with-doc', 'Install man pages' if build.head?
  option 'without-nanocat', 'Do not install nanocat tool' if build.head?

  depends_on 'pkg-config'=> :build
  depends_on :libtool

  if build.with? 'doc'
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
