require 'formula'

class IcePy < Formula
  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.1.tar.gz'
  homepage 'http://www.zeroc.com'
  md5 '3aae42aa47dec74bb258c1a1b2847a1a'

  depends_on 'ice'

  def patches
    "Patch from upstream that fixes Python servants having built-in
     operations invoked asynchronously on them. More on http://www.zeroc.com/forums/help-center/5210-ice_ping-marshalexception-refreshsession-python.html#post22745"
    DATA
  end

  def options
    [
      ['--install-demo', 'Install demo files'],
      ['--run-tests', 'Run Tests. Use verbose (-v) installation to see the results!']
    ]
  end

  def install
    ENV.O2
    ENV.append "ICE_HOME", "#{HOMEBREW_PREFIX}/Cellar/ice/3.4.1"
    inreplace "py/config/Make.rules" do |s|
      s.gsub! "#OPTIMIZE", "OPTIMIZE"
      s.gsub! "/opt/Ice-$(VERSION)", "#{prefix}"
      s.gsub! "/opt/Ice-$(VERSION_MAJOR).$(VERSION_MINOR)", "#{prefix}"
    end

    inreplace "py/config/Make.rules.Darwin" do |s|
      s.change_make_var! "CXXFLAGS", "#{ENV.cflags} -ftemplate-depth-128 -Wall -D_REENTRANT"
    end

    Dir.chdir "py" do
      system "make"
      if ARGV.include? '--run-tests'
        ohai "Use -v to see test results."
        system "make test"
      end
      if ARGV.include? '--install-demo'
        share.install Dir['demo'] => "IcePy-demo"
      end
      system "make install"
    end

  end

  def caveats; <<-EOS.undent
    Modify your PYTHONPATH environment variable to include the Ice
    extension for Python. Modify your environment as shown below:

    $ export ICEPY_HOME=#{prefix}
    $ export PYTHONPATH=$ICEPY_HOME/python:$PYTHONPATH
    EOS
  end

end

__END__
diff -ru ../Ice-3.4.1.orig/py/modules/IcePy/Operation.cpp ./py/modules/IcePy/Operation.cpp
--- ../Ice-3.4.1.orig/py/modules/IcePy/Operation.cpp	2010-06-03 09:48:35.000000000 -0700
+++ ./py/modules/IcePy/Operation.cpp	2011-01-18 10:55:11.000000000 -0800
@@ -3668,7 +3668,8 @@
             }
         }
 
-        __checkMode(op->mode, current.mode);
+        // See http://www.zeroc.com/forums/help-center/5210-ice_ping-marshalexception-refreshsession-python.html#post22745 .
+        // __checkMode(op->mode, current.mode);
 
         UpcallPtr up = new TypedUpcall(op, cb, current.adapter->getCommunicator());
         up->dispatch(_servant, inParams, current);
