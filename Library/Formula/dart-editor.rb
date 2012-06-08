require 'formula'

class Requires64Bit < Requirement
  def message
    "Requires 64-bit OS"
  end

  def satisfied?
    MacOS.prefer_64_bit?
  end

  def fatal?
    true
  end
end

class RequiresNoDart < Requirement
  def message
    <<-EOS.undent
    You must uninstall the 'dart' formula before continuing.
    This formula includes a superset of the functionality in 'dart'.
    EOS
  end

  def satisfied?
    not Formula.factory('dart').installed?
  end

  def fatal?
    true
  end
end

class DartEditor < Formula
  homepage 'http://www.dartlang.org/'
  url 'http://gsdview.appspot.com/dart-editor-archive-integration/8641/dart-editor-macosx.cocoa.x86_64.zip'
  version '8641'
  sha1 '1bafaa6193da27393f21623c08eff80bcafabeaa'

  devel do
    url 'https://gsdview.appspot.com/dart-editor-archive-continuous/8588/dart-editor-macosx.cocoa.x86_64.zip'
    version '8588'
    md5 '7e9e60fcb89348049951c99d580e19eb'
  end

  depends_on Requires64Bit.new
  depends_on RequiresNoDart.new

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec dart "#{target}" "$@"
    EOS
  end

  def install
    prefix.install Dir['*']

    bin.install_symlink prefix+'dart-sdk/bin/dart'

    (bin+'dart2js').write shim_script(prefix+'dart-sdk/lib/compiler/implementation/dart2js.dart')
    (bin+'dartdoc').write shim_script(prefix+'dart-sdk/lib/dartdoc/dartdoc.dart')
    (bin+'pub').write shim_script(prefix+'dart-sdk/util/pub/pub.dart')
  end

  def caveats; <<-EOS.undent
    DartEditor.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
  end

  def test
    mktemp do
      (Pathname.pwd+'sample.dart').write <<-EOS.undent
      void main() {
        Options opts = new Options();
        for (String arg in opts.arguments) {
          print(arg);
        }
      }
      EOS

      `#{bin}\dart sample.dart test message` == "test\nmessage\n"
    end
  end
end
