class Libmongoclient < Formula
  desc "C and C++ driver for MongoDB"
  homepage "https://www.mongodb.org"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/legacy-0.0-26compat-2.6.9.tar.gz"
  sha256 "fcbc8032afe7e3a45464aacf6ef34cfb7a3cf2afdd2a09d7cdaf23f6c7a24376"

  head "https://github.com/mongodb/mongo-cxx-driver.git", :branch => "26compat"

  bottle do
    sha256 "8a627a9d8146d29946db5c1835a38266af2e2080d947917c45d165759d5f6eb7" => :yosemite
    sha256 "e526f5f2cc21c7a8c7051e4cbbff0e90a3d5ae4830035d9a66b6805c40f5958a" => :mavericks
    sha256 "d34debf8911f3ff31c950babb837ca49fedecf05cbe3dd679c25a93df460f01c" => :mountain_lion
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
      "--osx-version-min=#{MacOS.version}"
    ]

    args << "--libc++" if MacOS.version >= :mavericks

    scons *args
  end
end
