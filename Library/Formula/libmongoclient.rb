class Libmongoclient < Formula
  desc "C and C++ driver for MongoDB"
  homepage "https://www.mongodb.org"
  head "https://github.com/mongodb/mongo-cxx-driver.git", :branch => "26compat"

  stable do
    url "https://github.com/mongodb/mongo-cxx-driver/archive/legacy-0.0-26compat-2.6.11.tar.gz"
    sha256 "b73ffaab09dca318cf286d607fb8b8aa8ace0ab08cef77637d58d33d1c449f2c"

    # Adds recognition for OS X 10.11.
    patch do
      url "https://github.com/mongodb/mongo-cxx-driver/commit/3fe5139.diff"
      sha256 "3ba04f8b4155ef9f06b91c077a89ae863d06959dec30d787551e30f41680c7a5"
    end
  end

  bottle do
    sha256 "d3d4000249b00eccfe72be5e32ff13282cd227123bd7ae34056d77cdefb3f0d6" => :el_capitan
    sha256 "1d84db7d1de7df82c7b5cb1e69eb619d4e27ba739af6b48440c8ccf25a5e97bc" => :yosemite
    sha256 "6fd8e141443fc7cac43a76ba2474e9e15cb4e0c2e66a9de5a1d9e1886dcf4cd4" => :mavericks
  end

  option :cxx11

  depends_on "scons" => :build

  if build.cxx11?
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if build.cxx11?

    boost = Formula["boost"].opt_prefix

    args = [
      "--prefix=#{prefix}",
      "-j#{ENV.make_jobs}",
      "--cc=#{ENV.cc}",
      "--cxx=#{ENV.cxx}",
      "--extrapath=#{boost}",
      "--full",
      "--use-system-all",
      "--sharedclient",
      # --osx-version-min is required to override --osx-version-min=10.6 added
      # by SConstruct which causes "invalid deployment target for -stdlib=libc++"
      # when using libc++
      "--osx-version-min=#{MacOS.version}",
    ]

    args << "--libc++" if MacOS.version >= :mavericks

    scons *args
  end
end
