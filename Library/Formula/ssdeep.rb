class Ssdeep < Formula
  desc "Recursive piecewise hashing tool"
  homepage "http://ssdeep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ssdeep/ssdeep-2.13/ssdeep-2.13.tar.gz"
  sha256 "6e4ca94457cb50ff3343d4dd585473817a461a55a666da1c5a74667924f0f8c5"

  bottle do
    cellar :any
    sha256 "1cfc5e0f2bda54443383d58583d9d23279820201350cb5d97ba37b4e7b14a17a" => :el_capitan
    sha256 "e01ebfb4bfb63ff3fa3f491c5b8bbf28055c70ccb1440ddacd4a2e31f84fe41d" => :yosemite
    sha256 "fb7b2a4b78b97b348f5a385bc58fb2ccfb285677a04f4ac73caffd2e4bf34921" => :mavericks
    sha256 "0077b7bb0348eb0b66e8cd575dd687e2dd82237beab1e2cd2f56ccb741614071" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    expected = <<-EOS.undent
      ssdeep,1.1--blocksize:hash:hash,filename
      192:15Jsxlk/azhE79EEfpm0sfQ+CfQoDfpw3RtU:15JsPz+7OEBCYLYYB7,"/usr/local/Cellar/ssdeep/2.13/include/fuzzy.h"
    EOS
    assert_equal expected, shell_output("#{bin}/ssdeep #{include}/fuzzy.h")
  end
end
