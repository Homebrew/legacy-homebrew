require 'brewkit'

class Mongodb <Formula
  @url='http://downloads.mongodb.org/osx/mongodb-osx-x86_64-1.0.0.tgz'
  @homepage='http://www.mongodb.org/'
  @md5='21a7071f9bbc922c028b11a9b2b6963c'

  def install
    system "cp -prv * #{prefix}"
  end
end
