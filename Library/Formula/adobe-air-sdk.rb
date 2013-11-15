require 'formula'

class AdobeAirSdk < Formula
  homepage 'http://adobe.com/products/air/sdk'
  option 'with-compiler', 'Grab the version with the new compiler (for non-Flex users).'

  if build.with? 'compiler'
    sha1 '1334fad165bab05f3abe0579ed1776e58c8da43e'
    url 'http://airdownload.adobe.com/air/mac/download/3.9/AIRSDK_Compiler.tbz2'
  else
    sha1 '715da9ad8f3bc7a61dcc54835084cbc7b9a92d66'
    url 'http://airdownload.adobe.com/air/mac/download/3.9/AdobeAIRSDK.tbz2'
  end

  def install
    libexec.install Dir['*']

    if build.with? 'compiler'
      bin.write_exec_script libexec/'bin/aasdoc'
      bin.write_exec_script libexec/'bin/acompc'
      bin.write_exec_script libexec/'bin/adl'
      bin.write_exec_script libexec/'bin/adt'
      bin.write_exec_script libexec/'bin/amxmlc'
      bin.write_exec_script libexec/'bin/asdoc'
      bin.write_exec_script libexec/'bin/compc'
      bin.write_exec_script libexec/'bin/fdb'
      bin.write_exec_script libexec/'bin/fontswf'
      bin.write_exec_script libexec/'bin/mxmlc'
      bin.write_exec_script libexec/'bin/optimizer'
      bin.write_exec_script libexec/'bin/swcdepends'
      bin.write_exec_script libexec/'bin/swfdump'
    else
      bin.write_exec_script Dir["#{libexec}/bin/*"]
    end
  end
end
