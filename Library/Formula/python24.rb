require 'formula'

class Python24 <Formula
  url 'http://www.python.org/ftp/python/2.4.6/Python-2.4.6.tgz'
  homepage 'http://www.python.org/download/releases/2.4.6/'
  md5 '7564b2b142b1b8345cd5358b7aaaa482'

  depends_on 'gdbm' => :optional
  depends_on 'readline'

  # Skip binaries so modules will load;
  # skip lib because it is mostly Python files
  skip_clean ['bin', 'lib']

  def prefix_site_packages
    # The HOMEBREW_PREFIX location of site-packages
    HOMEBREW_PREFIX + "lib/python2.4/site-packages"
  end

  def install
    # The system readline is broken (bus error), and the formula is keg_only.
    # It seems presumptuous to `brew link readline`. So:
    ENV['CC'] = ["gcc", "-I#{Formula.factory('readline').prefix}/include",
                 "-L#{Formula.factory('readline').prefix}/lib"].join(" ")

    system "./configure", "--prefix=#{prefix}", "--disable-tk",
      "MACOSX_DEPLOYMENT_TARGET=#{MACOS_VERSION}", "--enable-ipv6",
      "--enable-shared"
    ENV.j1
    system "/usr/bin/make"
    # no man pages; only install 'python2.4' binary, not 'python'
    system "make altbininstall"
    system "make libinstall"
    system "make inclinstall"
    system "make libainstall"
    system "make sharedinstall"
    system "make oldsharedinstall"
    # Add the Homebrew prefix path to site-packages via a .pth
    prefix_site_packages.mkpath
    (lib + "python2.4/site-packages/homebrew.pth").write prefix_site_packages
  end
end
