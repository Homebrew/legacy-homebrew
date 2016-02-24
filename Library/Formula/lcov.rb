class Lcov < Formula
  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "http://ltp.sourceforge.net/coverage/lcov.php"
  url "https://downloads.sourceforge.net/ltp/lcov-1.12.tar.gz"
  sha256 "b474e49c6c962754063b3be97a757a2ba9e7a455f0aea612863bf67e9b8b8ea7"

  head "https://github.com/linux-test-project/lcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "60a39cebc7d60df4b3f5db3dc83b74327bb472b4ee874626efc36709b5670377" => :el_capitan
    sha256 "5e2d2a144846f0b04986507f0e0b2b20cee0e9db888a748cb50a6d89c8309826" => :yosemite
    sha256 "6e2ffa607ebeec0b4c58cabeb8831ed1fa2f410bdb9032030209ab50afb8082a" => :mavericks
  end

  patch :DATA

  def install
    inreplace %w[bin/genhtml bin/geninfo bin/lcov],
      "/etc/lcovrc", "#{prefix}/etc/lcovrc"
    system "make", "PREFIX=#{prefix}", "BIN_DIR=#{bin}", "MAN_DIR=#{man}", "install"
  end
end

__END__
--- lcov-1.12/bin/install.sh
+++ lcov-1.12/bin/install.sh
@@ -34,7 +34,8 @@ do_install()
   local TARGET=$2
   local PARAMS=$3
 
-  install -p -D $PARAMS $SOURCE $TARGET
+  mkdir -p `dirname $TARGET`
+  install -p $PARAMS $SOURCE $TARGET
 }
