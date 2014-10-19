require "formula"

class Openalpr < Formula
  homepage "https://www.github.com/openalpr/openalpr"
  url "https://github.com/openalpr/openalpr/archive/v1.2.0.tar.gz"
  sha1 "4287255e1f13693e1c3f3f88e02addb656d75ca3"

  head "https://github.com/openalpr/openalpr.git", :branch => "master"

  option "without-daemon", "Do not include the alpr daemon (alprd)"

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "tesseract"
  depends_on "homebrew/science/opencv"

  if build.with? "daemon"
    depends_on "log4cplus"
    depends_on "beanstalk"
  end

  # I hope to remove the need for these patches if/when this pull
  # request gets accepted:
  # https://github.com/openalpr/openalpr/pull/55
  if build.head?
    patch :p1 do
      url "https://github.com/openalpr/openalpr/pull/55.diff"
      sha1 "715eff19b65c6c3faab7801bfed34b2ac5a37cd0"
    end
  else
    depends_on "ossp-uuid"

    # A partial backport of the pull request used in the HEAD patch above.
    patch :p1 do
      url "https://gist.githubusercontent.com/twelve17/460c57fbe732fd59dc6c/raw/b910f3f47f231408499d34f9e67ccbe96c5f5449/openalpr_1.2_cmakelists.patch"
      sha1 "403b9af8c174db9fff7051d4bbe972c49c308c6d"
    end
  end

  def install
    mkdir "src/build"
    cd "src/build" do
      args = std_cmake_args

      if build.head?
        # This flag is not available in current release.
        args << "-D CMAKE_MACOSX_RPATH=true"
      end

      if build.without? "daemon"
        args << "-D WITHOUT_DAEMON=YES"
      end

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    actual = `#{bin}/alpr #{HOMEBREW_PREFIX}/Library/Homebrew/test/fixtures/test.jpg`
    assert_equal "No license plates found.\n", actual, "output from reading test JPG image"
  end
end

