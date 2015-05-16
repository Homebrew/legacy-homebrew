class Ssdeep < Formula
  homepage "http://ssdeep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ssdeep/ssdeep-2.13/ssdeep-2.13.tar.gz"
  sha256 "6e4ca94457cb50ff3343d4dd585473817a461a55a666da1c5a74667924f0f8c5"

  bottle do
    cellar :any
    sha1 "65ea78b9b08334ce62b419672bdc4bdc40975dca" => :yosemite
    sha1 "03f7b4328bf9140f699fe5dfbf3afdb2ca0a3196" => :mavericks
    sha1 "7defdbf5042a2db364067a6f7f79ca4f0115d5a0" => :mountain_lion
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
