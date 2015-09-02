class Physfs < Formula
  desc "Library to provide abstract access to various archives"
  homepage "https://icculus.org/physfs/"
  url "https://icculus.org/physfs/downloads/physfs-2.0.3.tar.bz2"
  sha256 "ca862097c0fb451f2cacd286194d071289342c107b6fe69079c079883ff66b69"

  bottle do
    cellar :any
    sha256 "72cf56b0e25ad508b8852b025886ed7a11a25afd3784e799dbee15cdeb53e222" => :yosemite
    sha256 "69f7775baf000521234dce1d4ebd51c2466bf798dcd91656b37d54964afafd06" => :mavericks
    sha256 "a9639a67469ae197cbed16faec7381417e5c6d662c5568ec721ef4bc194e4467" => :mountain_lion
  end

  head "https://hg.icculus.org/icculus/physfs/", :using => :hg

  depends_on "cmake" => :build

  def install
    mkdir "macbuild" do
      args = std_cmake_args
      args << "-DPHYSFS_BUILD_TEST=TRUE"
      args << "-DPHYSFS_BUILD_WX_TEST=FALSE" unless build.head?
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.txt").write "homebrew"
    system "zip", "test.zip", "test.txt"
    (testpath/"test").write <<-EOS.undent
      addarchive test.zip 1
      cat test.txt
      EOS
    assert_match /Successful\.\nhomebrew/, shell_output("#{bin}/test_physfs < test 2>&1")
  end
end
