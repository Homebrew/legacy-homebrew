require 'formula'

class Hla < Formula
  homepage 'http://www.ArtOfAssembly.com'
  url 'http://www.plantation-productions.com/Webster/HighLevelAsm/HLAv2.16/mac.hla.tar.gz'
  sha1 'e914f4617e66973a2399b663a4f26a304fcd8650'
  version '2.16'
  tmp = '/tmp'

  def install
    ohai "Installing into: #{prefix}"
    cp_r "hla/include", "#{prefix}/include"
    cp_r "hla/hlalib", "#{prefix}/lib"
    cp_r "hla", "#{prefix}/bin"

    old_bashrc_file = File.open("#{ENV['HOME']}/.bashrc")
    old_bashrc = old_bashrc_file.read
    old_bashrc_file.close

    if old_bashrc.match(/hlalib/)
        ohai "Your ~/.bashrc is already good to go"
    else
        ohai "Updating your ~/.bashrc"
        bashrc = File.open("#{ENV['HOME']}/.bashrc", "a")
        # Should not need to update the PATH because brew should get the symlinks
        bashrc_additions = <<END_OF_STRING

# Added for HLA (via brew)
export hlalib=#{lib}
export hlainc=#{include}
export hlatemp=#{tmp}
END_OF_STRING
        bashrc.puts bashrc_additions
        ohai "Note: before you can use this, update your current environment with:\n  source .bashrc"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test hla`.
    # system "hla -?" # Note, this returns non-zero, so ...
    hello_world_program = <<-END_OF_STRING
program HelloWorld;
#include( "stdlib.hhf" )
begin HelloWorld;
    stdout.put( "Hello, World of Assembly Language", nl );
end HelloWorld;
END_OF_STRING

    ohai "Creating 'Hello World' source file in #{tmp}"
    hw = File.open("#{tmp}/hw.hla", "w")
    hw.print hello_world_program
    hw.close

    test_compile_cmd = "cd #{tmp} && hla hw && rm hw.hla hw.o hw"
    ohai "Running test compile: #{test_compile_cmd}"
    system test_compile_cmd
  end
end
