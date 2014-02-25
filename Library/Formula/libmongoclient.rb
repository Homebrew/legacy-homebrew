require 'formula'

class Libmongoclient < Formula
  homepage 'http://www.mongodb.org'
  url 'http://fastdl.mongodb.org/src/mongodb-src-r2.5.4.tar.gz'
  sha1 'ad40b93c9638178cd487c80502084ac3a9472270'

  head 'https://github.com/mongodb/mongo.git'

  depends_on 'scons' => :build
  depends_on 'boost' => :build

  def install
    boost = Formula.factory('boost').opt_prefix

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

    scons 'install-mongoclient', *args
  end
end
