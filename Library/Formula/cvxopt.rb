require 'formula'

class Cvxopt < Formula
	url 'http://abel.ee.ucla.edu/cvxopt/download.php'
	homepage 'http://abel.ee.ucla.edu/cvxopt/'
	md5 '5f3cb7e84de726ad561a122f8196c7e5'
	version '1.1.3'

	depends_on 'glpk' => :optional

	def setup_file
		'src/setup.py'
	end

	def install
		inreplace setup_file, "BUILD_GLPK = 0", "BUILD_GLPK = 1"
		inreplace setup_file, "GLPK_LIB_DIR = '/usr/lib'", "GLPK_LIB_DIR = '#{HOMEBREW_PREFIX}/lib'"
		inreplace setup_file, "GLPK_INC_DIR = '/usr/include'", "GLPK_INC_DIR = '#{HOMEBREW_PREFIX}/include'"
		inreplace  'src/setup.py', "ATLAS_LIB_DIR = '/usr/lib'", "ATLAS_LIB_DIR = '/System/Library/Frameworks/vecLib.framework'"
		system "cd src && python setup.py install --home=#{HOMEBREW_PREFIX}"
	end

	def caveats
		the_caveat = <<-EOS
	  Ensure that homebrew python packages can be seen by Python:
	  	export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
				EOS
		return the_caveat
	end
end
