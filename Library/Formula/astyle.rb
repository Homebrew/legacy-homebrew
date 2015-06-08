class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "http://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%202.05/astyle_2.05_macosx.tar.gz"
  sha1 "143be1d605ba05855451c3d96f9a4612d2feb554"
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
