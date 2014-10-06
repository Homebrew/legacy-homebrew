require "formula"

class Libmongoclient < Formula
  homepage "http://www.mongodb.org"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/legacy-0.0-26compat-2.6.4.tar.gz"
  sha1 "98510e610c7ad05b238149f6440c16c4c4cd21d9"

  head "https://github.com/mongodb/mongo-cxx-driver.git", :branch => "26compat"

  bottle do
    sha1 "4cfc88b78420b4346459b5cbdb82bf3eac632ede" => :mavericks
    sha1 "89199bb5d9f0a21ef133834f7c9be4d7701a8210" => :mountain_lion
    sha1 "375548f6c620f30b59d3188af3d3d72f79d830a7" => :lion
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
