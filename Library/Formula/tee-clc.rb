require 'formula'

class TeeClc < Formula
  desc "Eclipse client for Visual Studio 2010 Team Foundation Server"
  homepage 'http://www.microsoft.com/en-us/download/details.aspx?id=47727'
  url 'http://download.microsoft.com/download/8/F/6/8F68DDC8-4E75-4BEA-951E-C14BFF336E81/TEE-CLC-14.0.1.zip'
  sha1 '46a717c58c53ebc2cd9c8d3e1dbe8d9b10fe5565'

  conflicts_with 'tiny-fugue', :because => 'both install a `tf` binary'

  def install
    libexec.install "tf", "lib"
    (libexec/"tf").chmod 0755
    (libexec/"native").install "native/macosx"
    bin.write_exec_script libexec/"tf"
    share.install "help"
  end

  test do
    system "#{bin}/tf"
  end
end
