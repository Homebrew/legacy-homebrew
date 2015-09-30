class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "http://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%202.05.1/astyle_2.05.1_macosx.tar.gz"
  sha256 "de66da286dee2b9de1dc1c05092cbf5368c0889f25d1e2ee8b51766aff8e4baf"
  head "svn://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  bottle do
    cellar :any_skip_relocation
    sha256 "700aa3b6cb02fc702795c9f198553b01f944bf4f7eb4d706042979b6f432cad2" => :el_capitan
    sha256 "b0eaa29cb1899f79cdf30bc301754e50167471bd3e0427fc01e943bca2e2cdb2" => :yosemite
    sha256 "ce0c6f4c815d5eeaf547fcc7efb5e869ccba36ae80ebc30c6b96470ba73f02ff" => :mavericks
    sha256 "706419e9e1d02f93c67c68dbe10db43e1701c45106749ce79f952c3ddde73e98" => :mountain_lion
  end

  def install
    cd "src" do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<-EOS.undent
      int main()
      {
          return 0;
      }
    EOS
  end
end
