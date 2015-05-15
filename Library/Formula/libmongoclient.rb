class Libmongoclient < Formula
  homepage "https://www.mongodb.org"
  url "https://github.com/mongodb/mongo-cxx-driver/archive/legacy-0.0-26compat-2.6.9.tar.gz"
  sha256 "fcbc8032afe7e3a45464aacf6ef34cfb7a3cf2afdd2a09d7cdaf23f6c7a24376"

  head "https://github.com/mongodb/mongo-cxx-driver.git", :branch => "26compat"

  bottle do
    sha1 "eb587e75d00fb4fd1c54c685862513b10586bc5f" => :yosemite
    sha1 "4e2c8814b0da3941e1006536aace5328ded68892" => :mavericks
    sha1 "f784fb305307b81b93ecb19f33daea475e4d3762" => :mountain_lion
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
