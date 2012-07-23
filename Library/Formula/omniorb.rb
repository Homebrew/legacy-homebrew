require 'formula'

class OmniorbBindings < Formula
  homepage 'http://omniorb.sourceforge.net/'
  url 'http://sourceforge.net/projects/omniorb/files/omniORBpy/omniORBpy-3.6/omniORBpy-3.6.tar.bz2'
  sha1 '2def5ded7cd30e8d298113ed450b7bd09eaaf26f'
end

class Omniorb < Formula
  homepage 'http://omniorb.sourceforge.net/'
  url 'http://sourceforge.net/projects/omniorb/files/omniORB/omniORB-4.1.6/omniORB-4.1.6.tar.bz2'
  sha1 '383e3b3b605188fe6358316917576e0297c4e1a6'

  def options
    [
      ["--python", "Python mappings"]
    ]
  end

  def install
    ohai 'Installing omniORB.'
    python_exec = `python-config --exec-prefix`.strip

    system "./configure",
           "--prefix=#{prefix}",
           "PYTHON=#{python_exec}/bin/python"
    system "make"
    system "make install"

    omniorb_prefix = "#{prefix}"

    return unless ARGV.include? '--python'

    OmniorbBindings.new.brew do
      ohai 'Installing the omniORB Python mappings.'

      args = [
       "--with-omniorb=#{omniorb_prefix}",
       "--prefix=#{prefix}/src/lib",        # install into omniORB tree
       "PYTHON=#{python_exec}/bin/python"
      ]

      (prefix + "src/lib").mkpath
      system "./configure", *args
      system "make install"
    end
  end

  def caveats
    s = ''
    if ARGV.include? '--python'
      s += <<-EOS.undent
        The Python mappings won't function until you amend your PYTHONPATH like so:
          export PYTHONPATH="#{which_omniorb}/src/lib/lib/#{which_python}/site-packages:$PYTHONPATH"

        If you get an error like:
          $ omniidl: Could not import back-end 'python'
        You might want to further amend your PYTHONPATH like:
           export PYTHONPATH="#{which_omniorb}/src/lib/lib/#{which_python}/site-packages/omniidl_be:$PYTHONPATH"

      EOS
    end
    return s.empty? ? nil : s
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def which_omniorb
    `brew --prefix omniorb`.strip
  end

 def test
   system "omniidl", "-h"

   if ARGV.include? '--python'
       system "python", "-c", %(import omniORB; print 'omniORBpy', omniORB.__version__)
   end
 end
end
