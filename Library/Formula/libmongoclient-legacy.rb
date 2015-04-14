require "formula"

class LibmongoclientLegacy < Formula
  homepage "http://www.mongodb.org"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/legacy-1.0.1.tar.gz"
  sha1 "356dafe8e8ca7fcd58e7da1e812470305c1fc0db"

  head "https://github.com/mongodb/mongo-cxx-driver.git", :branch => "legacy"

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
      "--sharedclient",
      # --osx-version-min is required to override --osx-version-min=10.6 added
      # by SConstruct which causes "invalid deployment target for -stdlib=libc++"
      # when using libc++
      "--osx-version-min=#{MacOS.version}",
      "install"
    ]

    args << "--libc++" if MacOS.version >= :mavericks

    scons *args
  end
end

__END__
