require 'brewkit'

class Mongodb <Formula
  url 'http://downloads.mongodb.org/osx/mongodb-osx-x86_64-1.1.1.tgz'
  homepage 'http://www.mongodb.org/'
  md5 '8d22a1a5c7ae9d84ff6092e801fd5ebf'

  def install
    system "cp -prv * #{prefix}"
  end
end
