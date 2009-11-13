require 'formula'

class Gist <Formula
  url 'http://github.com/defunkt/gist/raw/595bddc77386b46f30dcae83748d4e2cc9d1b219/gist.rb'
  homepage 'http://github.com/defunkt/gist/'
  version '20091019'
  md5 '61ada08a5871b7011c1682be38e51da1'

  def install
    mv 'gist.rb', 'gist'
    bin.install "gist"
  end
end
