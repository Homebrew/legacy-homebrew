class TeeClc < Formula
  desc "Eclipse client for Visual Studio 2010 Team Foundation Server"
  homepage "https://www.microsoft.com/en-us/download/details.aspx?id=47727"
  url "http://download.microsoft.com/download/8/F/6/8F68DDC8-4E75-4BEA-951E-C14BFF336E81/TEE-CLC-14.0.1.zip"
  sha256 "2b7725901ae1e87427ba13df7c76e1492b37e4da7f6fbcd3b0edf2a723d0e556"

  conflicts_with "tiny-fugue", :because => "both install a `tf` binary"

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
