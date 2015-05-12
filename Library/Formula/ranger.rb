class Ranger < Formula
  homepage "http://ranger.nongnu.org/"
  url "http://ranger.nongnu.org/ranger-1.7.1.tar.gz"
  sha256 "f8b06135165142508ae7ec22ab2c95f6e51b4018c645d11226086d4c45b7df86"

  head "git://git.savannah.nongnu.org/ranger.git"

  # requires 2.6 or newer; Leopard comes with 2.5
  depends_on :python if MacOS.version <= :leopard

  def install
    inreplace %w[ranger.py ranger/ext/rifle.py] do |s|
      s.gsub! "#!/usr/bin/python", "#!#{PythonDependency.new.which_python}"
    end if MacOS.version <= :leopard

    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    bin.install_symlink libexec+"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("script -q /dev/null #{bin}/ranger --version")
  end
end
