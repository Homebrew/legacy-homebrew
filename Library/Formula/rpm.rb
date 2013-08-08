require 'formula'

class RpmDownloadStrategy < CurlDownloadStrategy
  attr_reader :tarball_name
  def initialize name, package
    super
    package_name = @spec == :name ? @ref : name
    @tarball_name="#{package_name}-#{package.version}.tar.gz"
  end
  def stage
    safe_system "rpm2cpio.pl <#{@tarball_path} | cpio -vi #{@tarball_name}"
    safe_system "/usr/bin/tar -xzf #{@tarball_name} && rm #{@tarball_name}"
    chdir
  end

  def ext
    ".src.rpm"
  end
end

class Rpm < Formula
  homepage 'http://www.rpm5.org/'
  url 'http://rpm5.org/files/rpm/rpm-5.4/rpm-5.4.10-0.20120706.src.rpm',
      :using => RpmDownloadStrategy, :name => 'rpm'
  version '5.4.10'
  sha1 'ce43b5871c4f884bea679f6c37d5cb9df7f2e520'

  depends_on 'berkeley-db'
  depends_on 'libmagic'
  depends_on 'popt'
  depends_on 'beecrypt'
  depends_on 'libtasn1'
  depends_on 'neon'
  depends_on 'gettext'
  depends_on 'xz'
  depends_on 'ossp-uuid'
  depends_on 'pcre'
  depends_on 'rpm2cpio' => :build
  depends_on 'libtool' => :build

  # nested functions are not std C
  def patches
    'http://rpm5.org/cvs/patchset?cn=16840'
  end

  def install
    args = %W[
        --prefix=#{prefix}
        --localstatedir=#{var}
        --with-path-cfg=#{etc}/rpm
        --with-extra-path-macros=#{lib}/rpm/macros.*
        --disable-openmp
        --disable-nls
        --disable-dependency-tracking
        --with-libtasn1
        --with-neon
        --with-uuid
        --with-pcre
        --with-lua
        --with-syck
        --without-apidocs
        varprefix=#{var}
    ]

    system 'glibtoolize -if' # needs updated ltmain.sh
    system "./configure", *args
    system "make"
    system "make install"
  end
end
