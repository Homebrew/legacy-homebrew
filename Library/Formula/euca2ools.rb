require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Euca2ools < Formula
  homepage 'https://github.com/eucalyptus/euca2ools'
  url 'https://github.com/eucalyptus/euca2ools/tarball/2.1.0'
  sha1 'a1903a3df759b6e8d123da6771febe6857393e3e'

  depends_on 'swig'
  depends_on 'M2Crypto' => :python
  depends_on 'boto' => :python

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    system "python setup.py build"
    system "python setup.py install --home=#{prefix}"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test euca2ools`.
    system "euca-version"
  end
end
