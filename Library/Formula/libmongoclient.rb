require 'formula'

class Libmongoclient < Formula
  homepage 'http://www.mongodb.org'
  url 'https://github.com/mongodb/mongo-cxx-driver/archive/legacy-0.0-26compat-2.6.0.tar.gz'
  sha1 '16489b9afb506bf30e514152af7b5a49bbdb2486'

  head 'https://github.com/mongodb/mongo-cxx-driver.git', :branch => "26compat"

  # Support building with C++11.
  # This patch was originally applied to the legacy branch but not 26compat.
  # Now merged into 26compat HEAD for 2.6.1.
  # https://jira.mongodb.org/browse/CXX-196
  # https://github.com/mongodb/mongo-cxx-driver/pull/61
  stable do
    patch do
      url "https://github.com/mongodb/mongo-cxx-driver/commit/e2ee6767.diff"
      sha1 "aeca81f9e0db21963cdfd6e41246909736071231"
    end
  end

  option :cxx11

  depends_on 'scons' => :build
  if build.cxx11?
    depends_on 'boost' => 'c++11'
  else
    depends_on 'boost'
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
      "--sharedclient"
    ]

    if MacOS.version >= :mavericks
      args << "--osx-version-min=10.8"
      # --libc++ argument would be redundant with ENV.cxx11
      args << "--libc++" if not build.cxx11?
    elsif build.cxx11?
      # SConstruct adds --osx-version-min=10.6 if not specified, which causes
      # error: invalid deployment target for -stdlib=libc++
      # Pass 10.7 as it is the lowest version to support libc++
      args << "--osx-version-min=10.7"
    end

    scons *args
  end
end
