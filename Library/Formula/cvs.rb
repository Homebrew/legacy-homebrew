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
    sha1 "054097e7fccf4a8ba60b9d1c364c411a6cd5de3c" => :yosemite
    sha1 "8e84ffd198414118da1ffb18f9d18a885e68d60f" => :mavericks
    sha1 "dea18dfba299690f2d8ed5dfc2205323207bc856" => :mountain_lion
  end

  keg_only :provided_until_xcode5

  {
    "PR5178707"         => "732495a63f9ef2c12997686df5e7567c2dd4dc0128c4349aadd9e6540cf5e368",
    "ea"                => "54e99f44fde6d1502e03afc33cfced576109697d5d9d734e24296cb45743ad98",
    "endian"            => "9538a7bb6a614b29b171b87df079491b9985ef7b626b8ff6f2afb6656b6fdb52",
    "fixtest-client-20" => "22f6dddce9f8cc42f275fa297c73025c78738d4ee02c6240bb0a71ee09a38425",
    "fixtest-recase"    => "2485b4b89383120e3a6e8762a8decc29fc5adba8a1fb4cfa0a5f3e43aff60511",
    "i18n"              => "3c8c3e7be584b2f8224570acdba2f6b0a72564c2358deadcf576a6d91e1d99a5",
    "initgroups"        => "22640ec9ddedb21d69c924231a44b6875e9af7b50d848da66ed6b614741bd0d6",
    "nopic"             => "4a3b82984d7738d98d612d6951fded58e5513cb941ec82727c9f4e7786fa879d",
    "remove-info"       => "daa6c899a12ccd7737ddd96c16130d2c65aeb7e79aeee1dd867e9ccb744b650e",
    "remove-libcrypto"  => "7c739b061b892a0a3fd0ce4542257c661713e7fb854a77e2b34b8e192197338d",
    "tag"               => "f44dc8e9406824990b87e46aa4ed6b75c3884a9b376b408ae2ef62fdabf0d929",
    "zlib"              => "15067f80b61f98eee9907fc18c037857f6b949bd7f5faa79ce8b3a822ef01bca",
  }.each do |name, sha|
    patch :p0 do
      url "https://opensource.apple.com/source/cvs/cvs-45/patches/#{name}.diff?txt"
      sha256 sha
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
