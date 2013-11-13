require 'formula'

class Libmongoclient < Formula
  homepage 'http://www.mongodb.org'
  url 'http://fastdl.mongodb.org/src/mongodb-src-r2.5.3.tar.gz'
  sha1 '8fbd7f6f2a55092ae0e461ee0f5a4a7f738d40c9'

  head 'https://github.com/mongodb/mongo.git'

  depends_on 'scons' => :build
  depends_on 'boost' => :build

  def install
    args = [
      "--prefix=#{prefix}",
      "-j#{ENV.make_jobs}",
      "--cc=#{ENV.cc}",
      "--cxx=#{ENV.cxx}",
      "--full",
      "--use-system-all",
      "--sharedclient"
    ]

    if MacOS.version >= :mavericks
      args << "--osx-version-min=10.8"
      args << "--libc++"
    end

    system 'scons', 'install-mongoclient', *args
  end
end
