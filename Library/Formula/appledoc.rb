class Appledoc < Formula
  desc "Objective-C API documentation generator"
  homepage "http://appledoc.gentlebytes.com/"
  url "https://github.com/tomaz/appledoc/archive/2.2.1.tar.gz"
  sha256 "0ec881f667dfe70d565b7f1328e9ad4eebc8699ee6dcd381f3bd0ccbf35c0337"

  head "https://github.com/tomaz/appledoc.git"

  bottle do
    sha256 "c723bec6cdeb0eb067d7c67cee472f20a6f1935e1bbd6b0a3aa0ec7f77fea583" => :el_capitan
    sha256 "ada12050d25be7a3c9920b1b4e2aa8d8a1efa7d59d9e67325f4e83dab14d0f59" => :yosemite
    sha256 "dede0bad06c61e56350c5fc812e1c507d3b2e0b73b6d062eedfe8e47f39b74fb" => :mavericks
  end

  depends_on :xcode => :build
  depends_on :macos => :lion

  def install
    xcodebuild "-project", "appledoc.xcodeproj",
               "-target", "appledoc",
               "-configuration", "Release",
               "clean", "install",
               "SYMROOT=build",
               "DSTROOT=build",
               "INSTALL_PATH=/bin",
               "OTHER_CFLAGS='-DCOMPILE_TIME_DEFAULT_TEMPLATE_PATH=@\"#{prefix}/Templates\"'"
    bin.install "build/bin/appledoc"
    prefix.install "Templates/"
  end

  test do
    (testpath/"test.h").write <<-EOS.undent
      /**
       * This is a test class. It does stuff.
       *
       * Here **is** some `markdown`.
       */

      @interface X : Y

      /**
       * Does a thing.
       *
       * @returns An instance of X.
       * @param thing The thing to copy.
       */
      + (X *)thingWithThing:(X *)thing;

      @end
    EOS

    system bin/"appledoc", "--project-name", "Test",
                           "--project-company", "Homebrew",
                           "--create-html",
                           "--no-install-docset",
                           "--keep-intermediate-files",
                           "--docset-install-path", testpath,
                           "--output", testpath,
                           testpath/"test.h"
  end
end
