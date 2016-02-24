# Based on:
# Apple Open Source: https://opensource.apple.com/source/cvs/cvs-45/
# MacPorts: https://trac.macports.org/browser/trunk/dports/devel/cvs/Portfile
# Creating a useful testcase: http://mrsrl.stanford.edu/~brian/cvstutorial/

class Cvs < Formula
  desc "Version control system"
  homepage "http://cvs.nongnu.org/"
  url "https://ftp.gnu.org/non-gnu/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2"
  sha256 "78853613b9a6873a30e1cc2417f738c330e75f887afdaf7b3d0800cb19ca515e"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c454f576c58dbabc3d3ce4af4974dfdcf47c4232af3de9275f171a93dbdf264a" => :el_capitan
    sha256 "3b6a02a69d14c6a6476727ade22b47a542dae280df6375a9bce9374a21176f86" => :yosemite
    sha256 "ff6b161b7379b44bf42635828f45e7f43c932d2be9fbf9691714f2f4a356ec7f" => :mavericks
    sha256 "cbabf7f11bb08b7018117f5b45dda26d55a0584f9ef7e00c0a134bbbe1284655" => :mountain_lion
  end

  keg_only :provided_until_xcode5

  patch :p0 do
    url "https://opensource.apple.com/tarballs/cvs/cvs-45.tar.gz"
    sha256 "4d200dcf0c9d5044d85d850948c88a07de83aeded5e14fa1df332737d72dc9ce"
    apply "patches/PR5178707.diff",
          "patches/ea.diff",
          "patches/endian.diff",
          "patches/fixtest-client-20.diff",
          "patches/fixtest-recase.diff",
          "patches/i18n.diff",
          "patches/initgroups.diff",
          "patches/nopic.diff",
          "patches/remove-libcrypto.diff",
          "patches/remove-info.diff",
          "patches/tag.diff",
          "patches/zlib.diff"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}",
                          "--with-gssapi",
                          "--enable-pam",
                          "--enable-encryption",
                          "--with-external-zlib",
                          "--enable-case-sensitivity",
                          "--with-editor=vim",
                          "ac_cv_func_working_mktime=no"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    cvsroot = testpath/"cvsroot"
    cvsroot.mkpath
    system "#{bin}/cvs", "-d", cvsroot, "init"

    mkdir "cvsexample" do
      ENV["CVSROOT"] = cvsroot
      system "#{bin}/cvs", "import", "-m", "dir structure", "cvsexample", "homebrew", "start"
    end
  end
end
