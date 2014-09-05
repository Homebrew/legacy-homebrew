require 'formula'

class PerprofPy < Formula
  homepage 'http://lpoo.github.io/perprof-py/'
  url 'https://codeload.github.com/lpoo/perprof-py/legacy.tar.gz/v1.0.0'
  sha1 'd6f79abe04c5529ce42fcd2d77ecbc7209c18681'


  head "https://github.com/lpoo/perprof-py.git", :using => :git, :tag => "v1.0.0"

  depends_on :python3
  test do 
    
  end
  def install
    system "pip3",  "install", "-r", "REQUIREMENTS"
    system "python3",  "setup.py", "install"
  end
end
