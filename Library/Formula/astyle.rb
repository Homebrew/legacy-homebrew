class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "http://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%202.05.1/astyle_2.05.1_macosx.tar.gz"
  sha256 "de66da286dee2b9de1dc1c05092cbf5368c0889f25d1e2ee8b51766aff8e4baf"
  head "svn://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  bottle do
    cellar :any
    sha1 "eee1cfb500d564b2209cbe8bcc5cf8e55132c10a" => :yosemite
    sha1 "5d2cb65bffdbbb3718d72b5529354a5362d90bf5" => :mavericks
    sha1 "5125e27b1b8343ed7da7d223f06393aca25a6acd" => :mountain_lion
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
