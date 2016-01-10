class RpmDownloadStrategy < CurlDownloadStrategy
  def stage
    tarball_name = "#{name}-#{version}.tar.gz"
    safe_system "rpm2cpio.pl <#{cached_location} | cpio -vi #{tarball_name}"
    safe_system "/usr/bin/tar -xzf #{tarball_name} && rm #{tarball_name}"
    chdir
  end

  def ext
    ".src.rpm"
  end
end

class Rpm < Formula
  desc "RPM package manager"
  homepage "http://www.rpm5.org/"
  url "http://rpm5.org/files/rpm/rpm-5.4/rpm-5.4.15-0.20140824.src.rpm",
      :using => RpmDownloadStrategy
  version "5.4.15"
  sha256 "d4ae5e9ed5df8ab9931b660f491418d20ab5c4d72eb17ed9055b80b71ef6c4ee"

  bottle do
    sha256 "29c05e064c80738733182e6688a82cef3a2c933b40acbeb43d3a842693ca91f4" => :el_capitan
    sha256 "ac5e32d13f8d61c4a7bfae758a98f4be00622e02a2db6e64430429a0ed17cc30" => :yosemite
    sha256 "26cb3e750a1333f5c66fd2c125f34a546ed1a200eeee7c950a0616ea7699453b" => :mavericks
    sha256 "67743955785cdb2f2c532d0a9cdd8c05adab1da9c10c9a2f5af18d53f3abaea5" => :mountain_lion
  end

  depends_on "rpm2cpio" => :build
  depends_on "berkeley-db"
  depends_on "libmagic"
  depends_on "popt"
  depends_on "libtasn1"
  depends_on "gettext"
  depends_on "xz"
  depends_on "ossp-uuid"

  def install
    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace "macros/macros.in", "@prefix@", HOMEBREW_PREFIX
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --with-path-cfg=#{etc}/rpm
      --with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic
      --with-path-sources=#{var}/lib/rpmbuild
      --with-libiconv-prefix=/usr
      --disable-openmp
      --disable-nls
      --disable-dependency-tracking
      --with-db=external
      --with-sqlite=external
      --with-file=external
      --with-popt=external
      --with-beecrypt=internal
      --with-libtasn1=external
      --with-neon=internal
      --with-uuid=external
      --with-pcre=internal
      --with-lua=internal
      --with-syck=internal
      --without-apidocs
      varprefix=#{var}
    ]

    system "./configure", *args
    inreplace "Makefile", "--tag=CC", "--tag=CXX"
    inreplace "Makefile", "--mode=link $(CCLD)", "--mode=link $(CXX)"
    system "make"
    # enable rpmbuild macros, for building *.rpm packages
    inreplace "macros/macros", "#%%{load:%{_usrlibrpm}/macros.rpmbuild}", "%{load:%{_usrlibrpm}/macros.rpmbuild}"
    # using __scriptlet_requires needs bash --rpm-requires
    inreplace "macros/macros.rpmbuild", "%_use_internal_dependency_generator\t2", "%_use_internal_dependency_generator\t1"
    system "make", "install"
  end

  def test_spec
    <<-EOS.undent
      Summary:   Test package
      Name:      test
      Version:   1.0
      Release:   1
      License:   Public Domain
      Group:     Development/Tools
      BuildArch: noarch

      %description
      Trivial test package

      %prep
      %build
      %install
      mkdir -p $RPM_BUILD_ROOT/tmp
      touch $RPM_BUILD_ROOT/tmp/test

      %files
      /tmp/test

      %changelog

    EOS
  end

  def rpmdir(macro)
    Pathname.new(`#{bin}/rpm --eval #{macro}`.chomp)
  end

  test do
    (testpath/"var/lib/rpm").mkpath
    (testpath/".rpmmacros").write <<-EOS.undent
      %_topdir		#{testpath}/var/lib/rpm
      %_specdir		%{_topdir}/SPECS
      %_tmppath		%{_topdir}/tmp
    EOS

    system "#{bin}/rpm", "-vv", "-qa", "--dbpath=#{testpath}"
    rpmdir("%_builddir").mkpath
    specfile = rpmdir("%_specdir")+"test.spec"
    (specfile).write(test_spec)
    system "#{bin}/rpmbuild", "-ba", specfile
    assert File.exist?(testpath/"var/lib/rpm/SRPMS/test-1.0-1.src.rpm")
  end
end
