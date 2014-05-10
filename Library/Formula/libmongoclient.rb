require 'formula'

class Libmongoclient < Formula
  homepage 'http://www.mongodb.org'
  url 'https://github.com/mongodb/mongo-cxx-driver/archive/legacy-0.0-26compat-2.6.1.tar.gz'
  sha1 'a45e66d5182ede6b3a0f5bd5e020ebeb48dbddbe'

  head 'https://github.com/mongodb/mongo-cxx-driver.git', :branch => "26compat"

  depends_on 'scons' => :build
  depends_on 'boost' => :build

  def install
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
      args << "--libc++"
    end

    scons *args
  end
end
