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
    cellar :any
    revision 1
    sha1 "054097e7fccf4a8ba60b9d1c364c411a6cd5de3c" => :yosemite
    sha1 "8e84ffd198414118da1ffb18f9d18a885e68d60f" => :mavericks
    sha1 "dea18dfba299690f2d8ed5dfc2205323207bc856" => :mountain_lion
  end

  keg_only :provided_until_xcode5

  {
    "PR5178707"         => "372385b34a346753249a7808e8d5db0a6cadd3ee",
    "ea"                => "1ffcbe849e138229473e0cd796416dfbe4ad25bb",
    "endian"            => "98fa880e0e2f1edddf123cdfdcc305f01c241f9b",
    "fixtest-client-20" => "b9277695a611750fc4db063e8929a558658ba90f",
    "fixtest-recase"    => "d546783658257ad1af67cecfd6d5fef66dc63e72",
    "i18n"              => "ec7b44d5d138fd24ac551b880f59fb0351445b98",
    "initgroups"        => "2c0a11ae5af7da75e02b256c5d9f6b88c8bfd6db",
    "nopic"             => "260978aa2318cdc35121b09782f0924661d3cebb",
    "remove-info"       => "7c0c9c406ae8e3d1c81eec5b4ca9e1abe6a8b660",
    "remove-libcrypto"  => "6c83063cb625cd124dcac75527dbaaa2d52d55b6",
    "tag"               => "44374b8601dc7e48cf0f3a558565d28b2d0066ab",
    "zlib"              => "7781dc997c895df8cfa991ab7a04add245169ea4"
  }.each do |name, sha|
    patch :p0 do
      url "https://opensource.apple.com/source/cvs/cvs-45/patches/#{name}.diff?txt"
      sha1 sha
    end
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
