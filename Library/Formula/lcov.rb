class Lcov < Formula
  desc "Graphical front-end for GCC's coverage testing tool (gcov)"
  homepage "http://ltp.sourceforge.net/coverage/lcov.php"
  url "https://downloads.sourceforge.net/ltp/lcov-1.12.tar.gz"
  sha256 "b474e49c6c962754063b3be97a757a2ba9e7a455f0aea612863bf67e9b8b8ea7"

  head "https://github.com/linux-test-project/lcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "922c6785490b66abc36ca3189c7a8d3f1c28b7aa952936ae327ca1f99b2ac606" => :el_capitan
    sha1 "edad7ab819deb6032734442ea88c343e6779f60c" => :mavericks
    sha1 "61cb990e2928ad0a1b29e131790790994b5a95d6" => :mountain_lion
    sha1 "b417a6801535d439dc26200213e63a4536989d11" => :lion
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
