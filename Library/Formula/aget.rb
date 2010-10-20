require 'formula'

class Aget <Formula
  url 'http://www.enderunix.org/aget/aget-0.4.1.tar.gz'
  homepage 'http://www.enderunix.org/aget/'
  md5 'ddee95ad1d394a4751ebde24fcb36fa1'

	def patches
		{ :p0 => "http://gist.github.com/raw/636606/aget0.4.1.patch" }
	end

  def install
    system "make"
		system "make strip"
		bin.install ["aget"]
  end
end
