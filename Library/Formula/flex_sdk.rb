class FlexSdk < Formula
  homepage "http://www.adobe.com/devnet/flex/flex-sdk-download.html"
  url "http://download.macromedia.com/pub/flex/sdk/flex_sdk_4.6.zip"
  sha256 "622b63f29de44600ff8d4231174a70fcb3085812c0e146a42e91877ca8b46798"
  version "4.6.0.23201"

  option "with-aot-stubs", "Include the Ahead of Time (AOT) stubs which fail to link"

  def install
    # Don't need windows files.
    rm_f Dir["bin/*.exe", "bin/*.bat"]

    # Don't need players and samples.
    rm_rf Dir["runtimes", "samples", "templates"]

    # Remove the Ahead of Time (AOT) stubs as they cause the `install_name_tool` to
    # fail (they appear to be intended for an incompatible architecture)
    if build.without? "aot-stubs"
      rm_rf "lib/aot/stub"
    end

    # Copy the remaining files.
    prefix.install Dir['*']
  end

  test do
    # Write out a very simple source file.
    (testpath/"Test.as").write <<-EOS.undent
      package
      {
        import flash.display.Sprite;

        public class Test extends Sprite
        {
          trace("Hello, World");
        }
      }
    EOS

    # Check the compiler works.
    system "FLEX_HOME='#{prefix}' && #{bin}/mxmlc Test.as -static-link-runtime-shared-libraries=true"
  end

  def caveats; <<-EOS.undent
    You should set FLEX_HOME:
      export FLEX_HOME="#{opt_prefix}"
    EOS
  end
end
